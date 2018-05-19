//
//  KMeans.swift
//  KMeansSwift
//
//  Created by sdq on 15/12/22.
//  Copyright © 2015年 sdq. All rights reserved.
//

import Foundation
import Accelerate
import Darwin

typealias KMVectors = Array<[Double]>
typealias KMVector = [Double]
// Hata Çeşitleri
enum KMeansError: Error {
    case noDimension
    case noClusteringNumber
    case noVectors
    case clusteringNumberLargerThanVectorsNumber
    case otherReason(String)
}
// Singleton Metot
class KMeansSwift {
    
    static let sharedInstance = KMeansSwift()
    fileprivate init() {}
    
    //MARK: Parameter
    
    //dimension of every vector
    var dimension:Int = 2
    //clustering number K
    var clusteringNumber:Int = 2
    //max interation
    var maxIteration = 100
    //convergence error
    var convergenceError = 0.01
    //number of excution
    var numberOfExcution = 1
    //vectors
    var vectors = KMVectors()
    //final centroids
    var finalCentroids = KMVectors()
    //final clusters
    var finalClusters = Array<KMVectors>()
    //temp centroids
    fileprivate var centroids = KMVectors()
    //temp clusters
    fileprivate var clusters = Array<KMVectors>()
    
    //MARK: Public
    
    //check parameters (Parametreleri kontrol ediyor.)
    func checkAllParameters() -> Bool {
        if dimension < 1 { return false }
        if clusteringNumber < 1 { return false }
        if maxIteration < 1 { return false }
        if numberOfExcution < 1 { return false }
        if vectors.count < clusteringNumber { return false }
        return true
    }
    
    //add vectors
    func addVector(_ newVector:KMVector) {
        vectors.append(newVector)
    }
    
    func addVectors(_ newVectors:KMVectors) {
        for newVector:KMVector in newVectors {
            addVector(newVector)
        }
    }
    
    //clustering
    func clustering(_ numberOfExcutions:Int, completion:(_ success:Bool, _ centroids:KMVectors, _ clusters:[KMVectors])->()) {
        beginClusteringWithNumberOfExcution(numberOfExcutions)
        return completion(true, finalCentroids, finalClusters)
    }
    // tüm değerleri siliyor.
    func reset() {
        vectors.removeAll()
        centroids.removeAll()
        clusters.removeAll()
        finalCentroids.removeAll()
        finalClusters.removeAll()
    }
    
    //MARK: Private
    
    // 1: pick initial clustering centroids randomly
    // 2: rasgetle olarak ilk kümeleme merkezlerini seç
    fileprivate func pickingInitialCentroidsRandomly() {
        let indexes = vectors.count.indexRandom[0..<clusteringNumber]
        var initialCenters = KMVectors()
        for index:Int in indexes {
            initialCenters.append(vectors[index])
        }
        centroids = initialCenters
    }
    
    // 2: assign each vector to the group that has the closest centroid.
    // 2: Her bir vektör en yakın merkeze sahip olan gruba atanır.
    fileprivate func assignVectorsToTheGroup() {
        clusters.removeAll()
        for _ in 0..<clusteringNumber {
            clusters.append([])
        }
        for vector in vectors{
            var tempDistanceSquare = -1.0
            var groupNumber = 0
            for index in 0..<clusteringNumber {
                if tempDistanceSquare == -1.0 {
                    tempDistanceSquare = EuclideanDistanceSquare(vector, v2: centroids[index])
                    groupNumber = index
                    continue
                }
                if EuclideanDistanceSquare(vector, v2: centroids[index]) < tempDistanceSquare {
                    groupNumber = index
                }
            }
            clusters[groupNumber].append(vector)
        }
    }
    
    // 3: recalculate the positions of the K centroids. (return move distance square)
    // 3: K centroid'lerin pozisyonlarını yeniden hesaplar.
    fileprivate func recalculateCentroids() -> Double {
        var moveDistanceSquare = 0.0
        for index in 0..<clusteringNumber {
            var newCentroid = KMVector(repeating: 0.0, count: dimension)
            let vectorSum = clusters[index].reduce(newCentroid, { vectorAddition($0, anotherVector: $1) })
            var s = Double(clusters[index].count)
            vDSP_vsdivD(vectorSum, 1, &s, &newCentroid, 1, vDSP_Length(vectorSum.count))
            if moveDistanceSquare < EuclideanDistanceSquare(centroids[index], v2: newCentroid) {
                moveDistanceSquare = EuclideanDistanceSquare(centroids[index], v2: newCentroid)
            }
            centroids[index] = newCentroid
        }
        print("=====new centers=====")
        print(centroids)
        return moveDistanceSquare
    }
    
    // 4: repeat 2,3 until the new centroids cannot move larger than convergenceError or the iteration is over than maxIteration
    // 4: Yeni centroid'ler, convergenceError'dan daha büyük hareket edemedikçe veya yineleme(iterasyon) maksimuma çıkana kadar 2,3'ü tekrarlayın
    fileprivate func beginClustering() -> Double {
        pickingInitialCentroidsRandomly()
        var iteration = 0
        var moveDistance = 1.0
        while iteration < maxIteration && moveDistance > convergenceError {
            iteration += 1
            assignVectorsToTheGroup()
            moveDistance = recalculateCentroids()
        }
        return costFunction()
    }
    
    // the cost function
    fileprivate func costFunction() -> Double {
        var cost = 0.0
        for index in 0..<clusteringNumber {
            for vector in clusters[index] {
                cost += EuclideanDistanceSquare(vector, v2: centroids[index])
            }
        }
        return cost
    }
    
    // 5: excute again (up to the number of excution), then choose the best result
    // 5: tekrar gerçekleştir (Excution sayısana kadar ), sonra en iyi sonucu seç
    private func beginClusteringWithNumberOfExcution(_ number:Int) {
        var number = number
        if number < 1 { return }
        var cost = -1.0
        while number > 0 {
            let newCost = beginClustering()
            if cost == -1.0 || cost > newCost {
                cost = newCost
                finalCentroids = centroids
                finalClusters = clusters
            }
            number -= 1
        }
    }
    
}

//MARK: Helper (Yardımcı metotlar)

//Add Vector (Vektor ekleme)
private func vectorAddition(_ vector:KMVector, anotherVector:KMVector) -> KMVector {
    var addresult = KMVector(repeating: 0.0, count: vector.count)
    vDSP_vaddD(vector, 1, anotherVector, 1, &addresult, 1, vDSP_Length(vector.count))
    return addresult
}

//Calculate Euclidean Distance (Öklit Mesafesi)
private func EuclideanDistance(_ v1:[Double],v2:[Double]) -> Double {
    let distance = EuclideanDistanceSquare(v1,v2: v2)
    return sqrt(distance)
}

private func EuclideanDistanceSquare(_ v1:[Double],v2:[Double]) -> Double {
    var subVec = [Double](repeating: 0.0, count: v1.count)
    vDSP_vsubD(v1, 1, v2, 1, &subVec, 1, vDSP_Length(v1.count))
    var distance = 0.0
    vDSP_dotprD(subVec, 1, subVec, 1, &distance, vDSP_Length(subVec.count))
    return abs(distance)
}

//Extension to pick random number. According to stackoverflow.com/questions/27259332/get-random-elements-from-array-in-swift
// Rastgele sayı eklentisi
private extension Int {
    var random: Int {
        return Int(arc4random_uniform(UInt32(abs(self))))
    }
    var indexRandom: [Int] {
        return  Array(0..<self).shuffle
    }
}

private extension Array {
    var shuffle:[Element] {
        var elements = self
        for index in 0..<elements.count {
            let anotherIndex = Int(arc4random_uniform(UInt32(elements.count - index))) + index
            anotherIndex != index ? elements.swapAt(index, anotherIndex) : ()
        }
        return elements
    }
    mutating func shuffled() {
        self = shuffle
    }
}


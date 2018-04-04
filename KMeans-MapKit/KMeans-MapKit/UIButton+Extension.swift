//
//  UIButton+Extension.swift
//  KMeans-MapKit
//
//  Created by CBS MOBIL on 4.04.2018.
//  Copyright © 2018 fozoglu. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func addShadow(opacity : Float, radius:CGFloat){
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        
    }
}

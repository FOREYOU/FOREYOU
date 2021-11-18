//
//  GradientBottomView.swift
//  FOREYOU
//
//  Created by Mac MIni on 06/07/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

class GradientBottomView: UIView {

    override open class var layerClass: AnyClass {
           return CAGradientLayer.classForCoder()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            let gradientLayer = layer as! CAGradientLayer
            gradientLayer.colors =  [
                UIColor(red: 0.992, green: 0.417, blue: 0, alpha: 1).cgColor,
                UIColor(red: 0.863, green: 0.012, blue: 0.557, alpha: 1).cgColor
              ]
            gradientLayer.locations = [0.0 , 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
            
            layer.bounds = self.bounds.insetBy(dx: -0.5*self.bounds.size.width, dy: -0.5*self.bounds.size.height)
        
            layer.position = self.center

            
            
        }
    
}

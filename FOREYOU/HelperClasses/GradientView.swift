//
//  GradientView.swift
//  FOREYOU
//
//  Created by Mac MIni on 03/07/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override open class var layerClass: AnyClass {
           return CAGradientLayer.classForCoder()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            let gradientLayer = layer as! CAGradientLayer
            gradientLayer.colors = [ UIColor(red: 0.795, green: 0.858, blue: 0.883, alpha: 1).cgColor,
                                    UIColor(red: 0.824, green: 0.192, blue: 0.573, alpha: 1).cgColor]
            gradientLayer.locations = [0.0 , 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)

           


            
            
        }

}

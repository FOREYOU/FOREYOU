//
//  UIView+extensions.swift
//  Mandoub Services Platform
//
//  Created by Ashutosh Mishra on 04/04/19.
//  Copyright © 2019 Ashutosh Mishra. All rights reserved.
//

import Foundation
import UIKit

public let kShapeDashed : String = "kShapeDashed"

//MARK: - Getting instance of controller
protocol InstantiateFromStoryBoard {
    static var viewControllerIdentifier:String {get}
    static var storyBoardIdentifier:String {get}
    static func instantiateFromStoryboard() -> Self
}

extension InstantiateFromStoryBoard{
    static func instantiateFromStoryboard() -> Self{
        let controller = UIStoryboard(name:storyBoardIdentifier, bundle: nil).instantiateViewController(withIdentifier: viewControllerIdentifier)
        return controller as! Self
    }
}

extension UITableView{
    func registerCell(_ identifier:String){
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }
        set {
            self.layer.cornerRadius = CGFloat(CGFloat(newValue))
        }
    }

    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    /// The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    /// The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
    
    func addShadow()
    {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
    }
    
    func removeDashedBorder(_ view: UIView) {
        view.layer.sublayers?.forEach {
            if kShapeDashed == $0.name {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    func addDashedBorder(width: CGFloat? = nil, height: CGFloat? = nil, lineWidth: CGFloat = 2, lineDashPattern:[NSNumber]? = [6,3], strokeColor: UIColor = .black, fillColor: UIColor = UIColor.clear) {
        
        
        var fWidth: CGFloat? = width
        var fHeight: CGFloat? = height
        
        if fWidth == nil {
            fWidth = self.frame.width
        }
        
        if fHeight == nil {
            fHeight = self.frame.height
        }
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        let shapeRect = CGRect(x: 0, y: 0, width: fWidth!, height: fHeight!)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: fWidth!/2, y: fHeight!/2)
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.name = kShapeDashed
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 22).cgPath
        self.removeDashedBorder(self)
        self.layer.addSublayer(shapeLayer)
    }
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

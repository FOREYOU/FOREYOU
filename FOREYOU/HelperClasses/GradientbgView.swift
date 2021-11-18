//
//  GradientbgView.swift
//  FOREYOU
//
//  Created by Mac MIni on 07/07/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

@IBDesignable  class GradientbgView: UIView {

    @IBInspectable var firstColor: UIColor =  Colors.ORANGE_COLOR //
    @IBInspectable var secondColor: UIColor = Colors.PINK_COLOR

        @IBInspectable var vertical: Bool = true

        lazy var gradientLayer: CAGradientLayer = {
            let layer = CAGradientLayer()
            layer.locations = [0, 1]


            layer.colors = [firstColor.cgColor, secondColor.cgColor]
            layer.startPoint =  CGPoint(x: 0.25, y: 0.5)


            layer.bounds = self.bounds.insetBy(dx: -0.5*self.bounds.size.width, dy: -0.5*self.bounds.size.height)
        
            layer.position = self.center

             return layer
        }()

        //MARK: -

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)

            applyGradient()
        }

        override init(frame: CGRect) {
            super.init(frame: frame)

            applyGradient()
        }

        override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            applyGradient()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            updateGradientFrame()
        }

        //MARK: -

        func applyGradient() {
            updateGradientDirection()
            layer.sublayers = [gradientLayer]
        }

        func updateGradientFrame() {
            
            
            
            gradientLayer.frame = bounds
        }

        func updateGradientDirection() {
            gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        }
    }

    @IBDesignable class ThreeColorsGradientView: UIView {
        @IBInspectable var firstColor: UIColor = Colors.ORANGE_COLOR//Colors.PINK_COLOR
        @IBInspectable var secondColor: UIColor = Colors.PINK_COLOR
        @IBInspectable var thirdColor: UIColor =  Colors.PINK_COLOR

        @IBInspectable var vertical: Bool = true {
            didSet {
                updateGradientDirection()
            }
        }

        lazy var gradientLayer: CAGradientLayer = {
            let layer = CAGradientLayer()
            layer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
            layer.startPoint =  CGPoint(x: 0.25, y: 0.5)
            return layer
        }()

        //MARK: -

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)

            applyGradient()
        }

        override init(frame: CGRect) {
            super.init(frame: frame)

            applyGradient()
        }

        override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            applyGradient()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            updateGradientFrame()
        }

        //MARK: -

        func applyGradient() {
            updateGradientDirection()
            layer.sublayers = [gradientLayer]
        }

        func updateGradientFrame() {
            gradientLayer.frame = bounds
        }

        func updateGradientDirection() {
            gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        }
    }

    @IBDesignable class RadialGradientView: UIView {

        @IBInspectable var outsideColor: UIColor =  Colors.ORANGE_COLOR//Colors.PINK_COLOR
        @IBInspectable var insideColor: UIColor =  Colors.PINK_COLOR

        override func awakeFromNib() {
            super.awakeFromNib()

            applyGradient()
        }

        func applyGradient() {
            let colors = [insideColor.cgColor, outsideColor.cgColor] as CFArray
            let endRadius = sqrt(pow(frame.width/2, 2) + pow(frame.height/2, 2))
            let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
            let context = UIGraphicsGetCurrentContext()

            context?.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endRadius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        }

        override func draw(_ rect: CGRect) {
            super.draw(rect)

            #if TARGET_INTERFACE_BUILDER
                applyGradient()
            #endif
        }

}

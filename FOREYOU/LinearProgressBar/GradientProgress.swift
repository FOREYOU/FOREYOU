//
//  GradientProgress.swift
//  GradientProgress
//
//  Created by Dmitry Smetankin on 09.09.17.
//  Copyright © 2017 GradientProgress. All rights reserved.
//

import UIKit

public class GradientProgressBar : UIProgressView {
    
    // MARK: - Properties
    
    
   
    /// An array of CGColorRef objects defining the color of each gradient stop. Animatable.
    public var gradientColors: [CGColor] = [Colors.ORANGE_COLOR.cgColor, Colors.PINK_COLOR.cgColor] {
        didSet {
            gradientLayer.colors = gradientColors
        }
    }

    
    /** The radius to use when drawing rounded corners for the gradient layer and progress view backgrounds. Animatable.
    *   The default value of this property is 0.0.
    */
    @IBInspectable public override var cornerRadius: Double {
        didSet {
            self.layer.cornerRadius = CGFloat(cornerRadius)
            self.clipsToBounds = true
        }
    }
    
    public override var trackTintColor: UIColor? {
        didSet {
            if trackTintColor != UIColor.clear {
                backgroundColor = trackTintColor
                trackTintColor = UIColor.clear
            }
        }
    }
    
    public override var progressTintColor: UIColor? {
        didSet {
            if progressTintColor != UIColor.clear {
                progressTintColor = UIColor.clear
            }
        }
    }
    
    lazy private var gradientLayer: CAGradientLayer = self.initGradientLayer()

    // MARK: - init methods
    
    override public init (frame : CGRect) {
        super.init(frame : frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayer()
    }
    
    override public func setProgress(_ progress: Float, animated: Bool) {
        super.setProgress(progress, animated: animated)
        updateGradientLayer()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.addSublayer(gradientLayer)
        progressTintColor = UIColor.clear
        gradientLayer.colors = gradientColors
    }
    
    private func initGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = sizeByPercentage(originalRect: bounds, width: CGFloat(progress))
        
        gradientLayer.locations = [0.0 , 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        

       gradientLayer.cornerRadius = CGFloat(cornerRadius)
        gradientLayer.masksToBounds = true
        return gradientLayer
    }
    
    private func updateGradientLayer() {
        gradientLayer.frame = sizeByPercentage(originalRect: bounds, width: CGFloat(progress))
        gradientLayer.cornerRadius = CGFloat(cornerRadius)
    }
    
    private func sizeByPercentage(originalRect: CGRect, width: CGFloat) -> CGRect {
        let newSize = CGSize(width: originalRect.width * width, height: originalRect.height)
        return CGRect(origin: originalRect.origin, size: newSize)
    }
}

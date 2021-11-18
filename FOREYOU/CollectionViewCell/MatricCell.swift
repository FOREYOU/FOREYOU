//
//  MatricCell.swift
//  FOREYOU
//
//  Created by Mac MIni on 03/09/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

class MatricCell:UICollectionViewCell{
var progress: KDCircularProgress!

@IBOutlet weak var firstGradientProgress: GradientProgressBar!
@IBOutlet weak var SecondGradientProgress: GradientProgressBar!
@IBOutlet weak var ThirdGradientProgress: GradientProgressBar!
@IBOutlet weak var FourthGradientProgress: GradientProgressBar!

@IBOutlet weak var fifthGradientProgress: GradientProgressBar!
@IBOutlet weak var SixthGradientProgress: GradientProgressBar!
@IBOutlet weak var seventhGradientProgress: GradientProgressBar!
@IBOutlet weak var eighthGradientProgress: GradientProgressBar!

@IBOutlet weak var circularProgressView: UIView!
@IBOutlet weak var circularProgressView1: UIView!

@IBOutlet weak var circularProgressView2: UIView!
@IBOutlet weak var circularProgressView3: UIView!

@IBOutlet weak var highView: UIView!
@IBOutlet weak var mediumView: UIView!
@IBOutlet weak var Low: UIView!
@IBOutlet weak var OtherView: UIView!
@IBOutlet weak var lblPercent1: UILabel!
@IBOutlet weak var lblPercent2: UILabel!
@IBOutlet weak var lblPercent3: UILabel!
@IBOutlet weak var lblPercent4: UILabel!

@IBOutlet weak var lblPercent5: UILabel!
@IBOutlet weak var lblPercent6: UILabel!
@IBOutlet weak var lblPercent7: UILabel!
@IBOutlet weak var lblPercent8: UILabel!
   
    @IBOutlet weak var  highlabel: UILabel!
    @IBOutlet weak var mediumlabel: UILabel!
    @IBOutlet weak var lowlabel: UILabel!
    @IBOutlet weak var otherlabel: UILabel!

    @IBOutlet weak var fininsh: UIButton!




override func awakeFromNib() {
    super.awakeFromNib()
    setInitials()
}


    func setInitials(){
        
        
      firstGradientProgress.setProgress(78/100, animated: false)
     SecondGradientProgress.setProgress(52/100, animated: false)
        ThirdGradientProgress.setProgress(52/100, animated: false)
        FourthGradientProgress.setProgress(52/100, animated: false)
        
        fifthGradientProgress.setProgress(78/100, animated: false)
        SixthGradientProgress.setProgress(78/100, animated: false)
        seventhGradientProgress.setProgress(78/100, animated: false)
        eighthGradientProgress.setProgress(78/100, animated: false)
        
        firstGradientProgress.cornerRadius = 15.0
        SecondGradientProgress.cornerRadius = 15.0
        ThirdGradientProgress.cornerRadius = 15.0
        FourthGradientProgress.cornerRadius = 15.0
        
        fifthGradientProgress.cornerRadius = 15.0
        SixthGradientProgress.cornerRadius = 15.0
        seventhGradientProgress.cornerRadius = 15.0
        eighthGradientProgress.cornerRadius = 15.0
        
        
         highView.borderColor = UIColor.black
        highView.borderWidth = 1
        highView.cornerRadius = Double(highView.frame.height/2)
        
        mediumView.borderColor = UIColor.black
        
        mediumView.borderWidth = 1
        mediumView.cornerRadius = Double(mediumView.frame.height/2)
        
        Low.borderColor = UIColor.black
        Low.borderWidth = 1
        Low.cornerRadius = Double(Low.frame.height/2)
        
        OtherView.borderColor = UIColor.black
        OtherView.borderWidth = 1
        OtherView.cornerRadius = Double(OtherView.frame.height/2)
        
       
        setupCircularProgress()
        setupCircularProgress1()
        setupCircularProgress2()
        setupCircularProgress3()
    }
    
    func setupCircularProgress(){
        
        highlabel.text = "MID"
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        progress.angle = 270
        progress.startAngle = 0
        progress.progressThickness = 0.8
        progress.trackThickness = 0.8
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0
        progress.trackColor = UIColor.white
        progress.set(colors: Colors.PINK_COLOR,Colors.ORANGE_COLOR)
         
        circularProgressView.addSubview(progress)
    }
    func setupCircularProgress1(){
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        progress.angle = 290
        progress.startAngle = 0
        progress.progressThickness = 0.8
        progress.trackThickness = 0.8
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0
        progress.trackColor = UIColor.white
        progress.set(colors: Colors.PINK_COLOR,Colors.ORANGE_COLOR)
         
        lowlabel.text = "HIGH"
         
        circularProgressView1.addSubview(progress)
    }
    func setupCircularProgress2(){
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        progress.angle = 290
        mediumlabel.text = "HIGH"
        progress.startAngle = 0
        progress.progressThickness = 0.8
        progress.trackThickness = 0.8
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0
        progress.trackColor = UIColor.white
        progress.set(colors: Colors.PINK_COLOR,Colors.ORANGE_COLOR)
         
        circularProgressView2.addSubview(progress)
    }
    func setupCircularProgress3(){
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        progress.angle = 290
        otherlabel.text = "HIGH"
        progress.startAngle = 0
        progress.progressThickness = 0.8
        progress.trackThickness = 0.8
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0
        progress.trackColor = UIColor.white
        progress.set(colors: Colors.PINK_COLOR,Colors.ORANGE_COLOR)
         
        circularProgressView3.addSubview(progress)
    }


}



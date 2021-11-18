//
//  destilcrCell.swift
//  FOREYOU
//
//  Created by Syncrasy on 11/11/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

class destilcrCell: UITableViewCell {
    var progress: KDCircularProgress!
    
    @IBOutlet weak var circularProgressView: KDCircularProgress!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    
    @IBOutlet weak var Outerview: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        Outerview.borderColor = UIColor.black
        Outerview.borderWidth = 1
        Outerview.cornerRadius = Double(Outerview.frame.height/2)
        self.setupCircularProgress()
        // Configure the view for the selected state
    }
    
    func setupCircularProgress(){
        
     
        circularProgressView.startAngle = 0
        circularProgressView.progressThickness = 0.8
        circularProgressView.trackThickness = 0.8
        circularProgressView.clockwise = true
        circularProgressView.gradientRotateSpeed = 2
        circularProgressView.roundedCorners = false
        circularProgressView.glowMode = .forward
        circularProgressView.glowAmount = 0
        circularProgressView.trackColor = UIColor.white
        circularProgressView.set(colors: Colors.PINK_COLOR,Colors.ORANGE_COLOR)
         

    }
}



//
//  SocialMediaTableViewCell.swift
//  Vella
//
//  Created by Vikas Kushwaha on 28/10/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
protocol SocialMediaTableViewCellDelegate {
    func btnSwitchAction(index:Int)
}

class SocialMediaTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    var switchIndex = -1
    var delegate:SocialMediaTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setHorizontalGradientColor(view: btnSwitch)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setHorizontalGradientColor(view: UIView) {
        let gradientLayer = CAGradientLayer()
        var updatedFrame = view.bounds
        updatedFrame.size.height += 20
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = [UIColor(red: 203/255, green: 219/255, blue: 226/255, alpha: 1), UIColor(red: 210/255, green: 57/255, blue: 150/255, alpha: 1)]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func btnSwitchAction(_ sender: Any) {
        btnSwitch.isOn = false
        self.delegate?.btnSwitchAction(index: switchIndex)
    }
    
    
    
}

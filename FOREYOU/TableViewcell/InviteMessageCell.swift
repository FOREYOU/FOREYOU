//
//  InviteMessageCell.swift
//  FOREYOU
//
//  Created by Dj on 12/06/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

class InviteMessageCell: UITableViewCell {

    @IBOutlet weak var firstitle:UILabel?
    @IBOutlet weak var secondtitle:UILabel?
    @IBOutlet weak var Intivebtn:UIButton?
    @IBOutlet weak var crossgotbtn:UIButton?
    @IBOutlet weak var Heighrconstant:NSLayoutConstraint?



    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstitle?.kerning =  -0.64
        secondtitle?.kerning =  -0.64
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

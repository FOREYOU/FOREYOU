//
//  ExperienceCell.swift
//  FOREYOU
//
//  Created by Apple on 22/03/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import TTTAttributedLabel
class ExperienceCell: UITableViewCell {

    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var exname:UILabel?
    @IBOutlet weak var exptitle:UILabel?
    @IBOutlet weak var expdesc: TTTAttributedLabel?

    @IBOutlet weak var expdate:UILabel?
    @IBOutlet weak var exptime:UILabel?
    @IBOutlet weak var expimg:UIImageView?
    @IBOutlet weak var explogo:UIImageView?
    @IBOutlet weak var Shareexpbtn:UIButton?

    @IBOutlet weak var Bookeventbtn:UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        shareBtn.layer.borderWidth = 1
        shareBtn.layer.borderColor = UIColor.black.cgColor
        
    
      
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  InviteExperienceTableViewCell.swift
//  Hang
//
//  Created by Vikas Kushwaha on 12/11/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit

class InviteExperienceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var name: UILabel!

    
    @IBOutlet weak var btnTick: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnTickAction(_ sender: Any) {
        
    }
    
    
    
}

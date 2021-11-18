//
//  SettingsTableViewCell.swift
//  Hang
//
//  Created by Vikas Kushwaha on 29/10/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

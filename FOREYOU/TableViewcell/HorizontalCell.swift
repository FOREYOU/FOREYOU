//
//  HorizontalCell.swift
//  FOREYOU
//
//  Created by Mac MIni on 07/09/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

class HorizontalCell: UITableViewCell {
    var progress: KDCircularProgress!
    @IBOutlet weak var firstGradientProgress: GradientProgressBar!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var status:UISwitch?
    @IBOutlet weak var  tabstatus: UILabel!
    @IBOutlet weak var  Descepition: UILabel!
    @IBOutlet weak var  Dropdownbnt: UIButton!
    

   override func awakeFromNib() {
        super.awakeFromNib()
        firstGradientProgress.cornerRadius = 15.0
      
       
    // Initialization code
    }

  override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

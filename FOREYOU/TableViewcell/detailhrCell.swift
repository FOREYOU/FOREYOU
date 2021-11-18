//
//  detailhrCell.swift
//  FOREYOU
//
//  Created by Syncrasy on 11/11/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

class detailhrCell: UITableViewCell {
    var progress: KDCircularProgress!
    @IBOutlet weak var firstGradientProgress: GradientProgressBar!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        firstGradientProgress.cornerRadius = 15.0
        // Configure the view for the selected state
    }
    
}

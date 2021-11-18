//
//  ExperienceTableViewCell.swift
//  Hang
//
//  Created by Vikas Kushwaha on 29/10/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
protocol ExperienceTableViewCellDelegate {
    func btnSendInvitationTapped()
}

class ExperienceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var btnSendInvitation: UIButton!
    @IBOutlet weak var btnReserve: UIButton!
    var delegate:ExperienceTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.cornerRadius = Double(profileImageView.frame.height/2)
        blackView.cornerRadius = 15
        btnSendInvitation.cornerRadius = Double(btnSendInvitation.frame.height/2)
        btnReserve.cornerRadius = Double(btnReserve.frame.height/2)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnSendInvitationAction(_ sender: Any) {
        self.delegate?.btnSendInvitationTapped()
    }
    
    
}

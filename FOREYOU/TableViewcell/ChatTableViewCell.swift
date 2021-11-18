//
//  ChatTableViewCell.swift
//  Hang
//


import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var msgDate: UILabel!
    @IBOutlet weak var lblCount: UILabel!
   
    @IBOutlet weak var msgDetail: UILabel!
    @IBOutlet weak var uNAme: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var seprateview: UIView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        profileImageView.cornerRadius = Double(profileImageView.frame.height/2)
        lblCount.cornerRadius = Double(lblCount.frame.height/2)
        lblCount.clipsToBounds = true
      //  seprateview.backgroundColor = .red
        
    

   
}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}




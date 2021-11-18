//
//  AddCocumentCollectionViewCell.swift
//  HITACHI
//
//  Created by MAC on 1/9/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit
protocol AddDocumentCollectionViewCellDelegate {
    func crossAction(index:Int)
}
class AddDocumentCollectionViewCell: UICollectionViewCell {

    var delegate:AddDocumentCollectionViewCellDelegate?
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var addicon: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var RremoveBtn: UIButton!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.delegate?.crossAction(index: sender.tag)
    }
    
}

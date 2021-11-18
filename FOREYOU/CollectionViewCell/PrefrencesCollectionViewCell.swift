//
//  PrefrencesCollectionViewCell.swift
//  Hang
//

import UIKit
protocol PrefrencesCollectionViewCellDelegate
{
    func btnHideAccTapped()

    func btnLogOutTapped()
    func btnDeleteAcc()
    func btntermconditionAcc()
}

class PrefrencesCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var hideAcc: UIButton!
    @IBOutlet weak var download: UIButton!

    
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var settingPreferenceDeleteAcc: UIView!
    var delegate:PrefrencesCollectionViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        settingPreferenceDeleteAcc.isHidden = true
        download.underline()
        if UserDefaults.standard.value(forKey: "account_status") as? Int == 0
        {
            hideAcc.setTitle("Unhide Account", for: .normal)
        }
        else
        {
            hideAcc.setTitle("Hide Account", for: .normal)

        }
        // Initialization code
    }
    
    @IBAction func btnDeleteAction(_ sender: Any) {
        settingPreferenceDeleteAcc.isHidden = false
        self.alpha = 0.5

    }
    
    
    @IBAction func btnHideaccount(_ sender: Any) {
        
      
        self.delegate?.btnHideAccTapped()

    }
    @IBAction func btnLogoutAction(_ sender: Any) {
        self.delegate?.btnLogOutTapped()
        
    }
  
    @IBAction func noBtn(_ sender: Any) {
    
        self.alpha = 1
        
        settingPreferenceDeleteAcc.isHidden = true
    }
    
    @IBAction func yesbtn(_ sender: Any) {
        
        self.delegate?.btnDeleteAcc()

    }
    @IBAction func termcondition(_ sender: Any) {
        self.delegate?.btntermconditionAcc()

    }
}

extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
      
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

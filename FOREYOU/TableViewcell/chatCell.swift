//


import UIKit
import SDWebImage
import Kingfisher
protocol ChatCellDelegate: class {
  func messageTableViewCellUpdate()
}
class chatCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var chatImgLeading: NSLayoutConstraint!
    @IBOutlet weak var onBtn: UIButton!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var chatImgTrailing: NSLayoutConstraint!
    @IBOutlet weak var cellViewLeading: NSLayoutConstraint!
    @IBOutlet weak var chatLbl: UILabel!
     @IBOutlet weak var cellViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cellViewTop: NSLayoutConstraint!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var chatImg: UIImageView!
    @IBOutlet weak var cellViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var timeStampLblOther: UILabel!
    
    @IBOutlet weak var messageViewTrailingConstraint: NSLayoutConstraint!
    var trailingConstraint:NSLayoutConstraint!
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var messageBackgroundViewOther: GradientBottomView!
    @IBOutlet weak var chatImageOther: UIImageView!
    var leadingConstraint:NSLayoutConstraint!
    @IBOutlet weak var chatLblOther: UILabel!
    
    
    var delegate:ChatCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImg.clipsToBounds = true
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        
        chatImg.layer.cornerRadius = 5
        chatImageOther.layer.cornerRadius = 5
        
     
        
    }
    
    
     override func prepareForReuse() {
        super.prepareForReuse()
        chatLbl.text = nil
        chatLblOther.text = nil
        profileImg.isHidden = true
        onBtn.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateCellForImage(isMeSender:Bool,imgUrl:String,timeStamp:String){
    
        chatLbl.isHidden = true
        messageBackgroundViewOther.isHidden = true
        messageBackgroundView.isHidden = true
        
        messageBackgroundView.roundCorners(corners: [.bottomLeft, .topLeft], radius: 50)
        messageBackgroundViewOther.roundCorners(corners: [.bottomRight, .topRight], radius: 50)

     
        chatLblOther.isHidden = true
        
        if isMeSender{
            messageBackgroundView.isHidden = false
            messageBackgroundViewOther.isHidden = true
       
            onBtn.isHidden = true
            timeStampLbl.isHidden = true
            timeStampLblOther.isHidden = true
            chatImg.isHidden = false
            chatImageOther.isHidden = true
            profileImg.isHidden = true
            timeStampLbl.text = AppHelper.convertDateStringToFormattedDateTimeString(dateE: timeStamp)
            
            let imgPic = imgUrl
            
             if imgUrl == ""
             {
                chatImageOther.sd_setImage(with: URL(string:imgUrl), placeholderImage: UIImage(named: "Foreyou"))
             }
             else {
            let trimmedString = imgPic.trimmingCharacters(in: .whitespaces)
       
              chatImg.sd_setShowActivityIndicatorView(true)
            chatImg.sd_setIndicatorStyle(.gray)

             chatImg.sd_setImage(with: URL(string:trimmedString), placeholderImage: UIImage(named: "."))
             }
          
            self.delegate?.messageTableViewCellUpdate()
            
        }else{
            timeStampLblOther.text = AppHelper.convertDateStringToFormattedDateTimeString(dateE: timeStamp)
            onBtn.isHidden = true
            timeStampLbl.isHidden = true
            timeStampLblOther.isHidden = true
            chatImg.isHidden = true
            chatImageOther.isHidden = false
            profileImg.isHidden = true
            messageBackgroundViewOther.isHidden = false
         
            
             if  imgUrl == ""
             {
                chatImageOther.sd_setImage(with: URL(string:imgUrl), placeholderImage: UIImage(named: "Foreyou"))

             }
             else {
                
                
                
                
            let trimmedString = imgUrl.trimmingCharacters(in: .whitespaces)
         
           
              
            chatImageOther.sd_setShowActivityIndicatorView(true)
           chatImageOther.sd_setIndicatorStyle(.gray)
 
                
          chatImageOther.sd_setImage(with: URL(string:trimmedString), placeholderImage: UIImage(named: "."))
             }
       
            self.delegate?.messageTableViewCellUpdate()

        }
    }
    
    func updateMessageCell(isMeSender:Bool,message:String,timeStamp:String){
        messageBackgroundView.roundCorners(corners: [.bottomLeft, .topLeft], radius: 22)
        messageBackgroundViewOther.roundCorners(corners: [.bottomRight, .topRight], radius: 22)

        messageBackgroundView.clipsToBounds = true
        messageBackgroundViewOther.clipsToBounds = true
        
        if isMeSender{
            
            messageBackgroundView.layer.backgroundColor = UIColor(red: 0.946, green: 0.946, blue: 0.946, alpha: 1).cgColor
            messageBackgroundView.isHidden = false
            chatLbl.isHidden = false
            messageBackgroundViewOther.isHidden = true
            chatLblOther.isHidden = true
            chatLbl.textAlignment = .left
            chatImg.isHidden = true
            chatImageOther.isHidden = true
            timeStampLbl.isHidden = true
            timeStampLblOther.isHidden = true
            timeStampLbl.text = AppHelper.convertDateStringToFormattedDateTimeString(dateE: timeStamp)
          
        }else{
            timeStampLblOther.text = AppHelper.convertDateStringToFormattedDateTimeString(dateE: timeStamp)
            timeStampLblOther.isHidden = true
            timeStampLbl.isHidden = true
          
             messageBackgroundViewOther.isHidden = false
            chatLblOther.isHidden = false
            messageBackgroundView.isHidden = true
            chatLbl.isHidden = true
            profileImg.isHidden = true
            chatLblOther.textAlignment = .left
            chatImg.isHidden = true
            chatImageOther.isHidden = true
        }
    }

}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            var masked = CACornerMask()
            if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
            if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
            if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
            if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
            self.layer.maskedCorners = masked
        }
        else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}

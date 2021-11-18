//
//  InviteFriends.swift
//  FOREYOU
//
import UIKit
import SwiftyJSON
import SDWebImage
class InviteFriends: UITableViewCell {

    var images : [JSON] = []
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var matchPercent: UILabel!
    @IBOutlet weak var distance: UILabel!

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var percentange: UILabel!
    @IBOutlet weak var detailbtn: UIButton!
    @IBOutlet weak var matchView: UIView!
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var personImageCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        personImageCollectionView.register(UINib(nibName: "InviteCell", bundle: nil), forCellWithReuseIdentifier: "InviteCell")
        address.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)


        userName.kerning = -1.12
//        for singleView in views{
//            if singleView.tag == 1{
//                singleView.borderWidth = 1
//                singleView.borderColor = UIColor.black
//                singleView.backgroundColor = UIColor.white
//            }
//            singleView.cornerRadius = Double(singleView.frame.height/2)
            
        
        // Initialization code
        //AppHelper.setHorizontalGradientColor(views: matchView)
    }
    func loadlockedimage(images:[JSON])
    {
        self.images = images
        personImageCollectionView.delegate = self
        personImageCollectionView.dataSource = self
        personImageCollectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension InviteFriends:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.self.images.count > 0
        {
            return  self.images.count
        }
        else {
             return 1
        }
        
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = personImageCollectionView.dequeueReusableCell(withReuseIdentifier: "InviteCell", for: indexPath) as? InviteCell
        
        
        if self.self.images.count > 0
        {
            let object = images[indexPath.row].stringValue
            cell?.profileImg.sd_setShowActivityIndicatorView(true)
            cell?.profileImg.sd_setIndicatorStyle(.gray)
            cell?.profileImg.sd_setImage(with: URL(string:object), placeholderImage: UIImage(named: ""))
        }
        else {
            cell?.profileImg.image = UIImage(named: "user_place")
        }
     
        
       
      return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: collectionView.bounds.width/2, height: 255)
        return cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return sectionInset
    }
    
}

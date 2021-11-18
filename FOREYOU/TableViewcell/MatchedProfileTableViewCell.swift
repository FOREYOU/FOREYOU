//
//  MatchedProfileTableViewCell.swift
//  Hang
//
//  Created by Vikas Kushwaha on 20/11/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
protocol matchCellDelegate: class {
    func fetchimage(urlimg:[JSON], Start:Int)
}
class MatchedProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgVieww: UIView!
    var arrimagData : [JSON] = []
    var matchlist = [MatchData]()

    var islocked:String?
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!

    @IBOutlet weak var matchPercent: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var percentange: UILabel!
    @IBOutlet weak var detailbtn: UIButton!
    @IBOutlet weak var matchView: UIView!
    @IBOutlet weak var matchView1: UIView!

    @IBOutlet weak var matchView2: UIView!
    @IBOutlet weak var matchlabel: UILabel!
    @IBOutlet weak var match: UILabel!
    var delete:matchCellDelegate?

    
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var personImagesCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        address.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        address.alpha = 0.5
        userName.kerning = -1.12
        match.kerning = -0.48
        address.kerning  = -0.56
        matchlabel.kerning =  -0.44
        personImagesCollectionView.register(UINib(nibName: "MatchProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MatchProfileCollectionViewCell")
       
        

      //  for singleView in views{
      //      if singleView.tag == 1{
              
            
     ///   }
    
        // Initialization code
       /// AppHelper.setHorizontalGradientColor(views: matchView)
    }
    func loadimage(images:[JSON])
    {
        self.arrimagData = images
       
        personImagesCollectionView.delegate = self
        personImagesCollectionView.dataSource = self
        self.personImagesCollectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension MatchedProfileTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.arrimagData.count > 0
        {
            return arrimagData.count
        }
        else {
             return 1
        }
        
       
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = personImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "MatchProfileCollectionViewCell", for: indexPath) as? MatchProfileCollectionViewCell
        if self.arrimagData.count > 0
        {
        let object = arrimagData[indexPath.row].stringValue
        
         
        let profilpic =  object.replacingOccurrences(of: "//", with: "/", options: .literal, range: nil)
         
          
            
            cell?.profileImageView.sd_setShowActivityIndicatorView(true)
            cell?.profileImageView.sd_setIndicatorStyle(.gray)

            
              cell?.profileImageView.sd_setImage(with: URL(string:profilpic), placeholderImage: UIImage(named: "."))
              
         }
        else {
            cell?.profileImageView.image = UIImage(named: "user_place")
        }
        
        if let indexPath = collectionView.visibleCurrentCellIndexPath {
           
            cell?.alpha = 1
            cell?.profileImageView.alpha = 1
             
                
            }
            else {
                cell?.alpha = 1
                   cell?.profileImageView.alpha = 1
            }
             
        
        
       
    
      return cell!
            
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  self.arrimagData.count > 0
        {
            ///let img = self.arrimagData[indexPath.row].stringValue
            
            self.delete?.fetchimage(urlimg: self.arrimagData, Start:indexPath.row)
      }
    
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

      
        let visibleRect = CGRect(origin: personImagesCollectionView.contentOffset, size: personImagesCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = personImagesCollectionView.indexPathForItem(at: visiblePoint)
         
         }
    
    
    
}

extension UILabel {

    @IBInspectable var kerning: Float {
        get {
            var range = NSMakeRange(0, (text ?? "").count)
            guard let kern = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: &range),
                let value = kern as? NSNumber
                else {
                    return 0
            }
            return value.floatValue
        }
        set {
            var attText:NSMutableAttributedString

            if let attributedText = attributedText {
                attText = NSMutableAttributedString(attributedString: attributedText)
            } else if let text = text {
                attText = NSMutableAttributedString(string: text)
            } else {
                attText = NSMutableAttributedString(string: "")
            }

            let range = NSMakeRange(0, attText.length)
            attText.addAttribute(NSAttributedString.Key.kern, value: NSNumber(value: newValue), range: range)
            self.attributedText = attText
        }
    }
}
extension UICollectionView {
  var visibleCurrentCellIndexPath: IndexPath? {
    for cell in self.visibleCells {
      let indexPath = self.indexPath(for: cell)
      return indexPath
    }
    
    return nil
  }
}

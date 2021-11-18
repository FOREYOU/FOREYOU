//
//  DetailCell.swift
//  FOREYOU
//
//  Created by Mac MIni on 13/07/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol DetailCellDelegate: class {
    func detaiimage(urlimg:[JSON], Start:Int)
}
class DetailCell: UITableViewCell {

    @IBOutlet weak var match_percentage: UILabel!
    
    @IBOutlet weak var Extrovert: UILabel!
    @IBOutlet weak var user_extrovert: UILabel!
    @IBOutlet weak var sentimental: UILabel!
    @IBOutlet weak var user_sentimental: UILabel!
    @IBOutlet weak var adventurous: UILabel!
    @IBOutlet weak var user_adventurous: UILabel!
    @IBOutlet weak var extrovertView: UIView!
    @IBOutlet weak var about: UILabel!
  
    @IBOutlet weak var music: UILabel!

    @IBOutlet weak var  moviees: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
   

     @IBOutlet weak var sentimentalView: UIView!
      @IBOutlet weak var adventrousView: UIView!
    @IBOutlet weak var sentimentalmainView: UIView!
     @IBOutlet weak var adventrousmainView: UIView!
     @IBOutlet weak var extrovertmainView: UIView!

    @IBOutlet weak var discoverCollectionView: UICollectionView!
    @IBOutlet weak var  lblNamw: UILabel!
    @IBOutlet weak var  messagename: UILabel!
    @IBOutlet weak var  specailname : UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var lblAdd: UILabel!
    @IBOutlet weak var aboutgender: UILabel!
    @IBOutlet weak var meesagebtn: UIButton!
    @IBOutlet weak var invitetn:  UIButton!

    @IBOutlet weak var collectionViewheighConstraint: NSLayoutConstraint!



    
    var extrovertProgress: KDCircularProgress!
    var sentimentalProgress: KDCircularProgress!
    var adventrousProgress: KDCircularProgress!
    
    var arrimagData : [JSON] = []
    
    var delegate:DetailCellDelegate?


    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
        if UIScreen.screenHeight == 568
        {
            
        }
        else  if UIScreen.screenHeight ==  667
        {
        }
        else if UIScreen.screenHeight == 736
        {
            
        }
        if  UIScreen.screenHeight == 812.0
        {
            
        }
        else {
            collectionViewheighConstraint.constant =  400
        }
         
        
        
      
        sentimentalmainView.borderColor = UIColor.black
        sentimentalmainView.borderWidth = 1
        sentimentalmainView.cornerRadius = Double(sentimentalmainView.frame.height/2)
        
        adventrousmainView.borderColor = UIColor.black
        adventrousmainView.borderWidth = 1
        adventrousmainView.cornerRadius = Double(adventrousmainView.frame.height/2)
        
        extrovertmainView.borderColor = UIColor.black
        extrovertmainView.borderWidth = 1
        extrovertmainView.cornerRadius = Double(extrovertmainView.frame.height/2)
        
        self.setInitials()
        self.setupCircularProgress()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadimage(images:[JSON])
    {
        self.arrimagData = images
        self.pageControl.numberOfPages = self.arrimagData.count
        self.scrollAutomatically()
        discoverCollectionView.delegate = self
        discoverCollectionView.dataSource = self
        self.discoverCollectionView.reloadData()
    }
    func setInitials(){
      
        discoverCollectionView.register(UINib(nibName: "ProfileDetailCell", bundle: nil), forCellWithReuseIdentifier: "ProfileDetailCell")
       // discoverCollectionView.delegate = self
       // discoverCollectionView.dataSource = self
    }
    func setupCircularProgress(){
        extrovertProgress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
        extrovertProgress.angle = 270
        extrovertProgress.startAngle = 0
        extrovertProgress.progressThickness = 0.8
        extrovertProgress.trackThickness = 0.8
        extrovertProgress.clockwise = true
        extrovertProgress.gradientRotateSpeed = 2
        extrovertProgress.roundedCorners = false
        extrovertProgress.glowMode = .forward
        extrovertProgress.glowAmount = 0
        extrovertProgress.trackColor = UIColor.white
        extrovertProgress.set(colors: Colors.PINK_COLOR,Colors.ORANGE_COLOR)
        extrovertView.addSubview(extrovertProgress)
        
        sentimentalProgress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
        sentimentalProgress.angle = 270
        sentimentalProgress.startAngle = 0
        sentimentalProgress.progressThickness = 0.8
        sentimentalProgress.trackThickness = 0.8
        sentimentalProgress.clockwise = true
        sentimentalProgress.gradientRotateSpeed = 2
        sentimentalProgress.roundedCorners = false
        sentimentalProgress.glowMode = .forward
        sentimentalProgress.glowAmount = 0
        sentimentalProgress.trackColor = UIColor.white
        sentimentalProgress.set(colors: Colors.PINK_COLOR,Colors.ORANGE_COLOR)
        sentimentalView.addSubview(sentimentalProgress)
        
        adventrousProgress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
        adventrousProgress.angle = 270
        adventrousProgress.startAngle = 0
        adventrousProgress.progressThickness = 0.8
        adventrousProgress.trackThickness = 0.8
        adventrousProgress.clockwise = true
        adventrousProgress.gradientRotateSpeed = 2
        adventrousProgress.roundedCorners = false
        adventrousProgress.glowMode = .forward
        adventrousProgress.glowAmount = 0
        adventrousProgress.trackColor = UIColor.white
        adventrousProgress.set(colors: Colors.PINK_COLOR,Colors.ORANGE_COLOR)
        adventrousView.addSubview(adventrousProgress)
        
    
}


    
        
        func scrollAutomatically() {
         
             for cell in discoverCollectionView.visibleCells {
                 
                 if self.arrimagData.count == 1 {
                     
                     
                     return
                 }
                 let indexPath = discoverCollectionView.indexPath(for: cell)!
                 if indexPath.row < (self.arrimagData.count - 1) {
                     let indexPath1 = IndexPath.init(row: indexPath.row + 1, section: indexPath.section)
                     discoverCollectionView.scrollToItem(at: indexPath1, at: .right, animated: true)
                     pageControl.currentPage = indexPath1.row
                   
                 }
                 else {
                     let indexPath1 = IndexPath.init(row: 0, section: indexPath.section)
                     discoverCollectionView.scrollToItem(at: indexPath1, at: .left, animated: true)
                     pageControl.currentPage = indexPath1.row
                   
                     
                 }
             }
         }
        
         func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
             
             
            let visibleRect = CGRect(origin: self.discoverCollectionView.contentOffset, size: self.discoverCollectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = self.discoverCollectionView.indexPathForItem(at: visiblePoint) {
             
              
            
             
             pageControl.currentPage = visibleIndexPath.row
            }
         }
        
            @IBAction func page_action(_ sender: UIPageControl) {
             
             self.discoverCollectionView.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)

                pageControl.currentPage =  self.arrimagData.count
            }
         
         }
       

       
     extension DetailCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
         
         
         func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
              
             if self.arrimagData.count > 0
             {
                 return self.arrimagData.count
             }
             else{
                 return 1
             
             }
             
                 }
         
          func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
             let cell = discoverCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileDetailCell", for: indexPath)as? ProfileDetailCell
             
             if self.arrimagData.count > 0
             {
                 let img = self.arrimagData[indexPath.row].stringValue
                 
                cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                cell?.profileImageView.sd_setIndicatorStyle(.gray)
              cell?.profileImageView.sd_setImage(with: URL(string: img),   placeholderImage: UIImage(named: "."))
                 
                 
             }
             else {
               
                 cell?.profileImageView.image = UIImage(named: "user_place")
             }
             return cell!
         }
        
        
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            if UIScreen.screenHeight == 667
            {
                let cellSize = CGSize(width: collectionView.bounds.width/1.5, height:  collectionView.bounds.height - 80)
                return cellSize
            }
            else if  UIScreen.screenHeight == 736
            {
                let cellSize = CGSize(width: collectionView.bounds.width/1.5, height:  collectionView.bounds.height )
                return cellSize
            }
            else {
                let cellSize = CGSize(width: collectionView.bounds.width/1.5, height:  collectionView.bounds.height )
                return cellSize
            }
          
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
        
        
        
        
         func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
             if  self.arrimagData.count > 0
             {
                
                if  self.arrimagData.count > 0
                {
                  
                self.delegate?.detaiimage(urlimg: self.arrimagData, Start: indexPath.row)
              }
                
           }
         
         }
     }
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

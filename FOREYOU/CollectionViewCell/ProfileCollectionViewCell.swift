//
//  ProfileCollectionViewCell.swift
//  Hang
//
//  Created by Vikas Kushwaha on 23/11/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
import CropViewController
import BSImagePicker
import Photos
import MapleBacon
import SwiftyJSON
import SDWebImage
protocol ProfileCollectionViewCellDelegate {
    func callPickImage()
    func changePassword( )
    func deleletimage(index:Int)
}

class ProfileCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLocation: UITextField!
    @IBOutlet weak var txtFieldOccupation: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPhone: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var Gender: UITextField!

    @IBOutlet weak var  lookingfor : UITextField!

    var  Profileimage:[JSON] = []
    @IBOutlet var containerView: [UIView]!
    @IBOutlet weak var documentCollectionView: UICollectionView!
    
    var delegate:ProfileCollectionViewCellDelegate?
    var image:UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        setInitials()
    }
    
    @IBAction func btnChangePassword(_ sender: UIButton) {
        if sender.tag == 100
        {
            delegate?.changePassword()
        }
        else if sender.tag == 101
        { delegate?.changePassword()
            
        }
        else {
            delegate?.changePassword()
        }
       
    }
    
    
    func setInitials(){
        documentCollectionView.register(UINib(nibName: "AddDocumentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddDocumentCollectionViewCell")
        documentCollectionView.delegate = self
        documentCollectionView.dataSource = self
        
        for everyView in containerView{
            everyView.borderColor = UIColor.black
            everyView.borderWidth = 1
        }
    }
    
}
extension ProfileCollectionViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         if self.Profileimage.count == 3
        {
           return   self.Profileimage.count
         }
        else {
            
            return  self.Profileimage.count + 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = documentCollectionView.dequeueReusableCell(withReuseIdentifier: "AddDocumentCollectionViewCell", for: indexPath) as? AddDocumentCollectionViewCell
        
       
        
        if indexPath.row ==  self.Profileimage.count
        {
            
            cell?.containerView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
            cell?.containerView.layer.borderWidth = 0.5
            cell?.containerView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            image = UIImage(named: "addIcon")
            cell?.addicon.image = self.image
            cell?.addicon.isHidden = false
            cell?.documentImageView.isHidden = true
            cell?.RremoveBtn.isHidden =  true
            return cell!
            
        }
        else  {
            if indexPath.row == 0 {
                cell?.documentImageView.isHidden = false
                cell?.addicon.isHidden = true
                cell?.RremoveBtn.isHidden =  false
            cell?.containerView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
                cell?.containerView.layer.borderWidth = 0.5
                cell?.containerView.layer.borderColor = UIColor.red.cgColor
                
                let dict = self.Profileimage[indexPath.row].dictionaryValue
               let object = dict["url"]?.stringValue
             
               cell?.documentImageView.sd_setImage(with: URL(string:object ?? ""), placeholderImage: UIImage(named: "user_place"))
             
                cell?.RremoveBtn.addTarget(self, action: #selector(deleteimage), for: .touchUpInside)
                 cell?.RremoveBtn.tag  = indexPath.row
            }
            else if  indexPath.row == 1  {
                cell?.documentImageView.isHidden = false
                cell?.addicon.isHidden = true
                cell?.RremoveBtn.isHidden =  false
            cell?.containerView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
                cell?.containerView.layer.borderWidth = 0.5
                cell?.containerView.layer.borderColor = UIColor.gray.cgColor
                
                let dict = self.Profileimage[indexPath.row].dictionaryValue
               let object = dict["url"]?.stringValue
             
               cell?.documentImageView.sd_setImage(with: URL(string:object ?? ""), placeholderImage: UIImage(named: "user_place"))
             
                cell?.RremoveBtn.addTarget(self, action: #selector(deleteimage), for: .touchUpInside)
                 cell?.RremoveBtn.tag  = indexPath.row
                
            }
            else {
                cell?.documentImageView.isHidden = false
                cell?.RremoveBtn.isHidden =  false
                cell?.addicon.isHidden = true
                cell?.containerView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
                cell?.containerView.layer.borderWidth = 0.5
                    cell?.containerView.layer.borderColor = UIColor.white.cgColor
                cell?.containerView.layer.borderColor = UIColor.clear.cgColor
               
                let dict = self.Profileimage[indexPath.row].dictionaryValue
               let object = dict["url"]?.stringValue
             
               cell?.documentImageView.sd_setImage(with: URL(string:object ?? ""), placeholderImage: UIImage(named: "user_place"))
                
                cell?.RremoveBtn.addTarget(self, action: #selector(deleteimage), for: .touchUpInside)
                 cell?.RremoveBtn.tag  = indexPath.row
                
                
                
                
                
                
            }
           
            return cell!
        }
        
    }
    
    @objc  func deleteimage(sender:UIButton)
    {
        
       
        self.delegate?.deleletimage(index: sender.tag)
       
    }
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 101)
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      if self.Profileimage.count == 3
        {
         
        }
        else {
            
             let dict = self.Profileimage[indexPath.row].dictionaryValue
             let object = dict["url"]?.stringValue
             if object == "" || object == nil
           
            {
                 self.delegate?.callPickImage()
             }
            else {
                
            }
           
        }
       
        
        
        
    }
    
    
   
}

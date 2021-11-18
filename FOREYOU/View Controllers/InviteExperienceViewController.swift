//
//  InviteExperienceViewController.swift
//  Hang
//
//  Created by Vikas Kushwaha on 02/12/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import IQKeyboardManagerSwift
class InviteExperienceViewController: BaseViewControllerClass {
    @IBOutlet weak var searchContainer: UIView!
    
    @IBOutlet weak var itemList: UITableView!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var messageTextView: IQTextView!
    var expobjct:ExprienceModel?
    var userinfo = [JSON]()
    var Recieverid:String?
     
    
    @IBOutlet weak var messageContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableheightconstant: NSLayoutConstraint!

    
    @IBOutlet weak var btnInvite: UIButton!
    var count = 0
    static var viewControllerId = "InviteExperienceViewController"
    static var storyBoard = "Main"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
        setInitials()
    }
    
    func setInitials(){
        itemList.registerCell("InviteExperienceTableViewCell")
        itemList.delegate = self
        itemList.dataSource = self
        searchContainer.borderColor = UIColor.black
        searchContainer.borderWidth = 1
        btnInvite.isEnabled = false
        btnInvite.backgroundColor = UIColor.gray
        messageContainerHeightConstraint.constant = 0
        messageContainerView.isHidden = true
        messageTextView.borderWidth = 1
        messageTextView.borderColor = UIColor.black
        if APPDELEGATE.selecttap ==  true
        {
            searchContainer.isHidden = true
            
            count = 1
            self.Recieverid =   APPDELEGATE.userdict?["user_id"]?.stringValue
            messageContainerHeightConstraint.constant = 132
            messageContainerView.isHidden = false
            btnInvite.isEnabled = true
            btnInvite.backgroundColor = UIColor.black
            tableheightconstant.constant = 44

            
            
        }
        else {
            count = 0
            searchContainer.isHidden = false
           // tableheightconstant.constant = 44
            
            self.explistApi()
        }
        
      
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func enableDisable(){
        
        if APPDELEGATE.selecttap == true
        {
            messageContainerHeightConstraint.constant = 132
            messageContainerView.isHidden = false
            btnInvite.isEnabled = true
            btnInvite.backgroundColor = UIColor.black
        }
        else
        {
        if count == 0{
            messageContainerHeightConstraint.constant = 0
            messageContainerView.isHidden = true
            btnInvite.isEnabled = false
            btnInvite.backgroundColor = UIColor.gray
        }else{
            messageContainerHeightConstraint.constant = 132
            messageContainerView.isHidden = false
            btnInvite.isEnabled = true
            btnInvite.backgroundColor = UIColor.black
        }
        }
        
    }
    @IBAction func btnInviteAction(_ sender: Any) {
        
         if checkValidation() == true
         {
            self.ShareApi()
            
         }
    }
func checkValidation() -> Bool{
    
  
    if (messageTextView.text!.isEmpty) == true {
        self.messageTextView.becomeFirstResponder()
        showAlertWithMessage(ConstantStrings.ALERT, "Please Write message")
        return false
    }
    
    return true
}
    
    override func showAlertWithMessage(_ title : String, _ message : String) {
    let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
    
    let defaultAction = UIAlertAction.init(title: ConstantStrings.OK_STRING, style: .default, handler: nil)
    alertController.addAction(defaultAction)
    
    present(alertController, animated: true, completion: nil)
}
}

extension InviteExperienceViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if APPDELEGATE.selecttap == true
        {
             return 1
        }
        else {
          return   self.userinfo.count
        }
        
      
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemList.dequeueReusableCell(withIdentifier: "InviteExperienceTableViewCell") as? InviteExperienceTableViewCell
        
        if APPDELEGATE.selecttap == true
        {
            
            let name = APPDELEGATE.userdict?["user_firstname"]?.stringValue
                     
                   
            cell?.name.text  = name?.capitalized
            let profilearr   =   APPDELEGATE.userdict?["user_profile_pic"]?.arrayValue
          
            let imgurl  = profilearr?.first?.stringValue
            cell?.profileImageView?.sd_setShowActivityIndicatorView(true)
            cell?.profileImageView?.sd_setIndicatorStyle(.gray)
           cell?.profileImageView?.sd_setImage(with: URL(string:imgurl ?? ""), placeholderImage: UIImage(named: "user_place"))
            
         
            
            if self.Recieverid == APPDELEGATE.userdict?["user_id"]?.stringValue
            {
             
                cell?.btnTick.setImage(UIImage(named: "selected"), for: .normal)
            }
            else {
                cell?.btnTick.setImage(UIImage(named: "normal"), for: .normal)
            }
                       
                      
            cell?.selectionStyle = .none
            
        return cell!
            
        }
        else {
            
            let object  = self.userinfo[indexPath.row].dictionaryValue
            
            let user_firstname =  object["user_firstname"]?.string
            let user_lastname =  object["user_lastname"]?.string
          
            cell?.name.text =    user_firstname! +  (user_lastname ?? "")
            
            let profilearr   =   object["user_profile_pic"]?.arrayValue
          
            let imgurl  = profilearr?.first?.stringValue
            cell?.profileImageView?.sd_setShowActivityIndicatorView(true)
            cell?.profileImageView?.sd_setIndicatorStyle(.gray)
           cell?.profileImageView?.sd_setImage(with: URL(string:imgurl ?? ""), placeholderImage: UIImage(named: "."))
            
         
            
            if self.Recieverid == object["user_id"]?.stringValue
            {
             
                cell?.btnTick.setImage(UIImage(named: "selected"), for: .normal)
            }
            else {
                cell?.btnTick.setImage(UIImage(named: "normal"), for: .normal)
            }
            cell?.selectionStyle = .none
            return  cell!
        }
        
       
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
       
        if APPDELEGATE.selecttap == true
        {
            
          
            self.Recieverid =   APPDELEGATE.userdict?["user_id"]?.stringValue

        }
        
        else {
            let object  = self.userinfo[indexPath.row].dictionaryValue
          
            self.Recieverid =  object["user_id"]?.stringValue

        }
          
        count = 1
       
        
    itemList.reloadData()
        enableDisable()
    }
    
    func explistApi()
     {
        
        
        
         let param = ["app_type": AppType,
                   
                      "user_id": UserDetails.sharedInstance.userID
                 ] as [String : Any]
         
         WebServiceHandler.performPOSTRequest(urlString: experienceshareusersUrl, params: param ) { (result, error) in
             
             if (result != nil){
                 let statusCode = result!["status"]?.string
                 let msg = result!["msg"]?.string
                 if statusCode == "200"
                 {
                
                    let arr  =  result!["users"]?.arrayValue
                    self.userinfo = arr!
                    DispatchQueue.main.async {
                    
                   self.itemList.dataSource  = self
                        self.itemList.delegate = self
                    self.itemList.reloadData()
                    }
                    
                 
                   
                }
                 else{
                     self.showAlertWithMessage("ALERT", msg!)
                 }
                 
             }
             else{
                
             }
         }
         
     }
    
    
    func ShareApi()
     {
        
         let param = ["app_type": AppType,
                   
                "user_id":UserDetails.sharedInstance.userID
                ,
                 "receiver_user_id": self.Recieverid!,
                "venue_id": expobjct?.venue_id ?? "",
                "event_id": expobjct?.event_id ?? "",
               "message": messageTextView.text!
                
                 ] as [String : Any]
         
         WebServiceHandler.performPOSTRequest(urlString: experienceshareUrl, params: param ) { (result, error) in
             
             if (result != nil){
                 let statusCode = result!["status"]?.string
                 let msg = result!["msg"]?.string
                 if statusCode == "200"
                 {
                
                  
                 DispatchQueue.main.async {
                    self.count = 0
                    self.enableDisable()
                    self.itemList.dataSource = self
                    self.itemList.delegate = self
                    self.itemList.reloadData()
                 self.showAlertWithMessage("", msg!)
                    
                    
                    }
                   
                }
                 else{
                     self.showAlertWithMessage("ALERT", msg!)
                 }
                 
             }
             else{
                
             }
         }
         
     }
    
}

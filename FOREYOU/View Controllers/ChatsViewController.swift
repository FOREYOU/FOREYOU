//
//  ChatsViewController.swift
//  Hang
//

//

import UIKit
import Alamofire
import SwiftyJSON
class ChatsViewController: BaseViewControllerClass
{
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var itemList: UITableView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var Messageview: UIView!
    @IBOutlet weak var messageaccount: UILabel!
    @IBOutlet weak var messageempty: UILabel!

    @IBOutlet weak var imgViewwidthConstraint: NSLayoutConstraint!


    var userDictionary: [String:AnyObject] = [:]
    var userArr : [AnyObject] = []
    var userArrFiltered : [AnyObject] = []
    var coachArr : [AnyObject] = []
    var coachFilteredArr : [AnyObject] = []
    static var viewControllerId = "ChatsViewController"
    static var storyBoard = "Main"
    var arrTableViewDatSource : [AnyObject] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if #available(iOS 13.0, *)
        {
         overrideUserInterfaceStyle = .light
        }
        else
        {
        }
        self.Messageview.isHidden = true
        
        imgViewwidthConstraint.constant = 7

       
        let  firstword = "You don’t have any messages yet. Why not and  \n send someone a message"
        let middletWord = "browse your matches"
        

        let longestWordRange = (firstword as NSString).range(of: middletWord)

        let attributedString = NSMutableAttributedString(string: firstword, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)])

        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.red], range: longestWordRange)


      //  messageempty.attributedText = attributedString
        
        
        setInitials()
    }
    override func viewWillAppear(_ animated: Bool) {
       
      
        
        messageListApi()
    }
    func messageListApi()
    {
        
       
          
        let urlString = kgetChatList
        

          let parameter: Parameters =
                [
                    "user_id":UserDetails.sharedInstance.userID,
                    "app_type":"HANG"
                    ]
               
        
        Alamofire.request(urlString, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
          
            DispatchQueue.main.async() {
                
            }

        switch response.result {
        case .success(let value):
            
            if let JSON = value as? [String: Any]
            {
                print(JSON)
                let status = JSON["status"] as? Int
                print(status)
                var messages = JSON["msg"] as? String
                if(status == 200)
                {
                    print(JSON)
                    if let userData = JSON["chat_group_data"] as? NSArray
                    {
                    self.arrTableViewDatSource = NSMutableArray(array: userData) as [AnyObject]
                    }
                    
                    if self.arrTableViewDatSource.count > 0
                    {
                        self.messageaccount.text =  String(self.arrTableViewDatSource.count) + " " + "New Message"
                        self.itemList.isHidden = false
                        self.Messageview.isHidden = true
                        self.itemList.reloadData()
                    }
                    else
                    {  self.itemList.isHidden = true
                        self.Messageview.isHidden = false
                        self.messageaccount.text =  String(0) + " " + "New Message"
                    }
                    
                    }
                else
                {
                        self.itemList.isHidden = true
                        self.Messageview.isHidden = false
                        self.messageaccount.text =  String(0) + " " + "New Message"
                }
            }
        case .failure(_):
            self.itemList.isHidden = true
                self.Messageview.isHidden = false
                self.messageaccount.text =  String(0) + " " + "New Message"
            print("failed")
            break
        }}
        
        }
    func setInitials(){
        itemList.registerCell("ChatTableViewCell")
        itemList.delegate = self
        itemList.dataSource = self
        searchContainerView.borderColor = UIColor.black
        searchContainerView.borderWidth = 1
        notificationView.cornerRadius = Double(notificationView.frame.height/2)
    }
    
    @IBAction func btnSettingsAction(_ sender: Any)
    {
        openSettings()
    }
    
    func openSettings()
    {
        let controller = SettingsViewController.instantiateFromStoryBoard()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
}
extension ChatsViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        self.arrTableViewDatSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = itemList.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as? ChatTableViewCell
        var recArr : [String : Any] = [:]
        let msgData = self.arrTableViewDatSource[indexPath.row] as? [String : Any]
        print("LLLL",msgData)
        let msgType = msgData?["message_text"] as? String
        cell?.msgDetail.text = msgType

        let msgCreatedTime = msgData?["create_time"] as? String
        
        cell?.msgDate.text = AppHelper.convertDateStringToFormattedDateTimeString(dateE: msgCreatedTime!)
        let msgSenderData = msgData?["sender"] as? [String : Any]

        let msgReciverData = msgData?["receiver"] as? [String : Any]
        let sender_user_id = msgData?["sender_user_id"] as? String
        let message_count = msgData?["message_count"] as? Int ?? 0

         let receiver_user_id = msgData?["receiver_user_id"] as? String
         let messageType = msgData?["message_type"] as? String
            ?? ""
           
            if message_count > 0
            {
                cell?.msgDetail.font = UIFont.systemFont(ofSize: 14, weight: .bold)
                cell?.lblCount.isHidden = false
                cell?.lblCount.text = "\(message_count)"
                
                let gradient: CAGradientLayer = CAGradientLayer()

             gradient.colors = [ UIColor(red: 0.795, green: 0.858, blue: 0.883, alpha: 1).cgColor,
                                     UIColor(red: 0.824, green: 0.192, blue: 0.573, alpha: 1).cgColor]
                 gradient.locations = [0.0 , 1.0]
                gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
                 gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
                gradient.frame = CGRect(x: 0.0, y: 0.0, width: (cell?.seprateview.frame.size.width)!, height: 3)


                cell?.seprateview.layer.insertSublayer(gradient, at: 0)
                
            }
            else
            {
        
                cell?.lblCount.isHidden = true
                 cell?.msgDetail.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            }
        
         if(sender_user_id != UserDetails.sharedInstance.userID )
          {
            cell?.uNAme.text = msgSenderData?["user_firstname"] as? String
            
            let pImg = (msgSenderData?["user_profile_pic"] as? NSArray)
             
            for eachImg in pImg!
            {
                cell?.profileImageView.sd_setImage(with: URL(string:eachImg as! String ), placeholderImage: UIImage(named: "user_place"))
            }
          
          print("SSSS",msgData)
        }
        else
        {
            cell?.uNAme.text = msgReciverData?["user_firstname"] as? String
            let pImg = (msgReciverData?["user_profile_pic"] as? NSArray)
            
            for eacharr in pImg!
            {
                cell?.profileImageView.sd_setImage(with: URL(string:eacharr as! String ), placeholderImage: UIImage(named: "user_place"))
            }
           
        }
        

    return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var Fname = ""
        var pPic = ""
        let msgData = self.arrTableViewDatSource[indexPath.row] as? [String : Any]
        let message_group_id = msgData?["message_group_id"] as? Int
        let sender_user_id = msgData?["sender_user_id"] as? String
        let msgSenderData = msgData?["sender"] as? [String : Any]

        let msgReciverData = msgData?["receiver"] as? [String : Any]
        let receiver_user_id = msgData?["receiver_user_id"] as? String
        var userId = ""
        if(sender_user_id != UserDetails.sharedInstance.userID )
        {
            Fname = (msgSenderData?["user_firstname"] as? String ?? "")
           let imgArr = (msgSenderData?["user_profile_pic"] as? NSArray)!
            for each in imgArr
            {
             pPic = each as! String
            }
            userId = sender_user_id ?? "9"
            
        }
        else
        {
            Fname = msgReciverData?["user_firstname"] as? String ?? ""
            let imgArr = (msgReciverData?["user_profile_pic"] as? NSArray)
           for each in imgArr!
           {
            pPic = each as! String
           }
            userId = receiver_user_id ?? "8"
            
            
        }
        
        if #available(iOS 13.0, *)
        {
            let jumpVC = (self.storyboard?.instantiateViewController(identifier: "ChatVC") as? ChatVC)!
            jumpVC.msgGrpId = "\(message_group_id!)"
            jumpVC.userNme = Fname
            jumpVC.profileImg = pPic
            jumpVC.userId = userId
            jumpVC.selecttag = true
            self.navigationController?.pushViewController(jumpVC, animated: true)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
}



import UIKit
import Alamofire
import IQKeyboardManagerSwift
import AWSS3
import AWSCognito
import FirebaseDatabase
 import Lightbox


@available(iOS 13.0, *)
class ChatVC: BaseViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate
{
   
    var arrTableViewDatSource : [[String:Any]] = []
    var userNme = ""
    var userId = ""
    
    var msgGrpId = ""
    var msgType = ""
    var ImgData = ""
    var profileImg = ""
    var is_block = ""
    var base64ImgString = ""
    var userType = ""
    var selectedImgName = ""
    var imgUrlArr = ""
    var ref:DatabaseReference!
    var selecttag:Bool?
    var   upcoming:Bool?
    let bucketName = "foreyouawsnewbucket"
    
    @IBOutlet weak var chatVW: UIView!
   

    @IBOutlet weak var msgVWBottom: NSLayoutConstraint!
    @IBOutlet weak var msgVW: UIView!
   
   
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var featuresVWHeight: NSLayoutConstraint!
    @IBOutlet weak var tblTop: NSLayoutConstraint!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messagesTFHeight: NSLayoutConstraint!
    @IBOutlet weak var tblVWBottom: NSLayoutConstraint!
    @IBOutlet weak var chatImgLeading: NSLayoutConstraint!
    @IBOutlet weak var onBttn: UIButton!
    @IBOutlet weak var featuresVW: UIView!
    @IBOutlet weak var visitProfileBtn: UIButton!
    @IBOutlet weak var viewFeatures: UIView!
    @IBOutlet weak var imgVWSelect: UIView!
    @IBOutlet weak var msgTW: IQTextView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var msgTF: UITextField!
    @IBOutlet weak var Message: UILabel!

    
    @IBOutlet weak var msgViewBottomConstraint: NSLayoutConstraint!
    var indicator = UIActivityIndicatorView()
    
    var encodeStr = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
        msgTW.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor

        msgTW.layer.borderWidth = 1

        msgTW.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        
        if #available(iOS 13.0, *)
        {
         overrideUserInterfaceStyle = .light
        }
        else
        {
            
        }
        ref = Database.database().reference(withPath: "messages")
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        userName.text = userNme.capitalized
        
        imgVWSelect.isHidden = true
        visitProfileBtn.clipsToBounds = true
        visitProfileBtn.layer.cornerRadius = visitProfileBtn.frame.width/2
        let imgURl = profileImg
         
        visitProfileBtn.sd_setImage(with: URL(string:imgURl ), for: .normal, placeholderImage: UIImage(named: "user_place"))
        visitProfileBtn.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.tapFunction))
        userName.isUserInteractionEnabled = true
        userName.addGestureRecognizer(tap)
        readCheck()
      
        IQKeyboardManager.shared.enable = false
        activityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = .white
        tblVw.registerCell("DatetimeCell")
        
         self.Message.isHidden = true
         self.tblVw.isHidden = true
        
          getmsghistory()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       

    }
    
    @IBAction func profileimgaction(sender:UITapGestureRecognizer) {

        if self.selecttag == true
        {
            
           let controller = DiscoverViewController.instantiateFromStoryBoard()
            controller.userId = userId
            push(controller)
            
        }
        else {
        self.navigationController?.popViewController(animated: true)
        }
     
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        
        if self.selecttag == true
        {
            
           let controller = DiscoverViewController.instantiateFromStoryBoard()
            controller.userId = userId
            push(controller)
            
        }
        else {
        self.navigationController?.popViewController(animated: true)
        }
     
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        self.arrTableViewDatSource = []
        getmsghistory()
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    
  @IBAction func bckBtn(_ sender: Any)
    {
    
  
       
    self.navigationController?.popViewController(animated: true)
    
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.endEditing(true)
        return true
    }
    
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        
   }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            msgViewBottomConstraint.constant = keyboardSize.height
            print("Keyboard Size is: \(keyboardSize.height)")
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {(completed) in
                if self.arrTableViewDatSource.count > 0{
                    self.tblVw.scrollToBottom()
                }
              
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            msgViewBottomConstraint.constant = 0
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {(completed) in
                
                if self.arrTableViewDatSource.count > 0{
                    self.tblVw.scrollToBottom()
                }
                
            })
           
        }
    }
    
    
    @IBAction func sendMsg(_ sender: Any)
    {
        encodeStr = msgTW.text ?? ""
        encodeStr = encode(encodeStr)
        
        self.msgTW.resignFirstResponder()
        
        if msgTW.text.isEmpty{
            return
        }
           
        apisendMsg()
    }
    func encode(_ s: String) -> String {
        let data = encodeStr.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
    @IBAction func addImg(_ sender: Any)
    {
        showAlert()
    }
    private func showAlert()
    {
        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType)
    {
        if UIImagePickerController.isSourceTypeAvailable(sourceType)
        {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
   
    @IBAction func btnDoneSelect(_ sender: Any) {
        apisendMsg()
        imgVWSelect.isHidden = true
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        imgVWSelect.isHidden = true
    }
 
   
    func  numberOfSections(in tableView: UITableView) -> Int {
       return  arrTableViewDatSource.count
    
      }
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    let arr = self.arrTableViewDatSource[section]["chatData"] as? [[String:Any]]
    return  arr?.count ?? 0
    
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        24
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 30
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        let arr = self.arrTableViewDatSource[indexPath.section]["chatData"] as? [[String:Any]]
        
        let dict = arr?[indexPath.row]
        
        
        
        let imgURl = dict?["url"] as? String ?? ""
       
        
        
       let messageType = dict?["message_types"] as? String ?? ""
        
        
        if(messageType == "IMAGE")
        {
            return  110
        }
        else
        { return UITableView.automaticDimension
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let uId =  UserDetails.sharedInstance.userID
        
        let arr = self.arrTableViewDatSource[indexPath.section]["chatData"] as? [[String:Any]]
        let dict =  arr?[indexPath.row]
        
       
        let messageType = dict?["message_types"] as? String ?? ""


        if(messageType == "IMAGE")
        {
            let cell = tblVw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chatCell
         
            cell.selectionStyle = .none
            let senderdict = dict?["sender"] as?  [String :Any]
            let   receiverdict = dict?["receiver"] as?  [String :Any]
            
            
           
            let profile_pic =  receiverdict?["user_profile_pic"] as? Array<Any>
            let imgURl = profile_pic?.first as? String ?? ""
                
            cell.profileImg.sd_setImage(with: URL(string:imgURl ), placeholderImage: UIImage(named: "user_place"))
            
            let senderId = senderdict?["user_id"] as? String
            
            if(senderId == uId)
            {
                let imgURl = dict?["url"] as? String ?? ""
                let timeStampString = dict?["create_time"] as? String
                cell.delegate = self
                cell.updateCellForImage(isMeSender: true, imgUrl: imgURl, timeStamp: timeStampString ?? "")
            }
            else
            {
                
                let imgURl = dict?["url"] as? String ?? ""
               
                let timeStampString = dict?["create_time"] as? String ?? " "
                cell.delegate = self
                cell.updateCellForImage(isMeSender: false, imgUrl: imgURl, timeStamp: timeStampString ?? "")
            }
            return cell
            
        }
        else
        {
            let cell = tblVw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chatCell
           
            cell.selectionStyle = .none

            let msg = dict?["message_text"] as? String
            let d = decode(msg!) ?? ""
            let message = d
            var senderdict  = [String:Any]()
            var receiverdict  = [String:Any]()
            var recArr  = [String:String]()
            
            senderdict = dict?["sender"] as?  [String :Any] ?? [String:Any]()
            receiverdict = dict?["receiver"] as?  [String :Any] ?? [String:Any]()
            
            
            if let msgData = dict?["sender"]
            {
                recArr = msgData as? [String : String] ?? ["":"" ]
            }
            let senderId = senderdict["user_id"] as? String
            
            if(senderId == uId)
            {
                 
                let profile_pic =  receiverdict["user_profile_pic"] as? Array<Any>
                let imgURl = profile_pic?.first as? String ?? ""
                    
                cell.profileImg.sd_setImage(with: URL(string:imgURl ), placeholderImage: UIImage(named: "user_place"))
                
                
                    
                
              
                cell.onBtn.isHidden = true
                cell.profileImg.isHidden =  true
                let timeStampString = dict?["create_time"] as? String ?? ""
                
                cell.chatLbl.text = message
                cell.updateMessageCell(isMeSender: true, message: msg!, timeStamp: timeStampString)
            }
            else
            {
                
                let profile_pic =  receiverdict["user_profile_pic"] as? Array<Any>
                let imgURl = profile_pic?.first as? String ?? ""
                    
                cell.profileImg.sd_setImage(with: URL(string:imgURl ), placeholderImage: UIImage(named: "user_place"))
                cell.messageBackgroundView.isHidden = false
                cell.profileImg.isHidden = false
                cell.onBtn.isHidden = true
               
               
                cell.onBtn.isHidden = true
                 var timeStampString = dict?["create_time"] as? String ?? ""
                cell.chatLblOther.text = message
                cell.updateMessageCell(isMeSender: false,message: msg!, timeStamp: timeStampString)
              
            }
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let arr = self.arrTableViewDatSource[indexPath.section]["chatData"] as? [[String:Any]]
        let dict =  arr?[indexPath.row]
        
        let imgURl = dict?["url"] as? String ?? ""
        
          if  imgURl == ""
          {
            
          }
          
          else  {
            
            let urlString = imgURl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
            
            let images = [
                LightboxImage(imageURL: URL(string: urlString!)!)]
            let controller = LightboxController(images: images)

            
          
              controller.modalPresentationStyle = .fullScreen
                 controller.dynamicBackground = true
                   
                 present(controller, animated: true, completion: nil)
            
              
         // let completePath   =  url
             
        
            
            
            
            
            
          }
            
         /*
         
         
        imgUrlArr = self.arrTableViewDatSource[indexPath.row]["url"] as? String ?? ""
        if imgUrlArr != ""
        {
            
        }else{
            msgTW.endEditing(true)
        }
 */
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let headerCell = tblVw.dequeueReusableCell(withIdentifier: "DatetimeCell") as! DatetimeCell


       let dict = arrTableViewDatSource[section] as? [String:Any]
        
        let  date = dict?["date"] as? String
        
        headerCell.datetime?.text =  AppHelper.convertDateStringToFormattedDateString(dateE: date!)
        
     return headerCell
    
    
    }
   
    
    
    func readCheck()
    {
         
        
     let parameter: Parameters =
             [
                "user_id":UserDetails.sharedInstance.userID,
               "message_group_id": msgGrpId,
             
             ]
            
              Alamofire.request( kgetReadMsg, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
                        switch response.result {
                 case .success(let value):
                     if let JSON = value as? [String: Any]
                     {
                         let status = JSON["status"] as! String
                         print(status)
                        var messages = JSON["msg"] as? String
                         if(status == "200")
                         {
                             print(JSON)
                            
                           
                            
                         }
                         else
                         {
                              
                         }
                      }
                   case .failure(_):
                   print("failed")
                 
                   break
                                                  
                  }}
                    
         
    }
    func getmsghistory()
    {
       
       
        let msgId = "\(msgGrpId)"
        var parameter:Parameters = [:]
        
        if(msgId == "0")
        {
            msgGrpId = ""
        }
        
            parameter =
                [
                    "app_type":AppType,
                    "user_id":UserDetails.sharedInstance.userID,
                    "message_group_id":msgGrpId
                ]
        
        
        print(parameter)
        
        Alamofire.request(kgetChatHistory, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String: Any]
                {
                    let status = JSON["status"] as? Int
                    
                    print(status)
                    
                    var messages = JSON["msg"] as? String
                    
                    if(status == 200)
                    {
                        print(JSON)
                        
                        
                        if let userData = JSON["date"] as? [[String:Any]]
                        {
                            
                           self.arrTableViewDatSource =  userData
                            
                         
                        }
                        
                        self.indicator.stopAnimating()
                        self.indicator.hidesWhenStopped = true
                        
                       
                        
                       self.tblVw.reloadData()
                   
                        
                        if(self.arrTableViewDatSource.count > 1)
                        {
                           
                            DispatchQueue.main.async {
                            self.tblVw.scrollToBottom()
                            }
                            
                          
                        
                          }
                      
                        }
                    else
                    {
                        if self.arrTableViewDatSource.count == 0
                        {
                            
                            self.Message.isHidden = false
                            self.tblVw.isHidden = true
                            
                        }
                        else {
                            self.Message.isHidden = true
                            self.tblVw.isHidden = false
                        }
                        self.indicator.stopAnimating()
                        self.indicator.hidesWhenStopped = true
                        
                    }
                }
            case .failure(_):
                print("failed")
               self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                break
            }}
        
    }
    
    
func apisendMsg()
    {
    
    indicator.startAnimating()
    indicator.backgroundColor = .white
  var parameter:Parameters = [:]
        var firebasePrm : Parameters = [:]
        
        
    
        if(msgType == "IMAGE")
        {
          
            parameter =
                [
                    
                    "app_type" :"HANG",
                    "device_type": "ios",
                    "user_id":UserDetails.sharedInstance.userID,
                    "message_group_id": msgGrpId,
                    "message_text": "",
                    "receiver_user_id" : userId,
                    "message_types":"IMAGE",
                    "url": self.base64ImgString
                  
                    
                ]
            print(parameter)
            Alamofire.request(ksendmessage, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
                print(response.result)
                switch response.result
                {
                case .success(let value):
                    if let JSON = value as? [String: Any]
                    {
                        let status = JSON["status"] as! String
                        print(status)
                        self.msgType = ""
                        var messages = JSON["msg"] as? String
                        var url = JSON["url"] as? String
                        var time = JSON["created_time"] as? String
                        
                        
                        if(self.msgGrpId == "")
                        {
                            self.msgGrpId = "\(JSON["message_group_id"] as? Int ?? 0)"
                            
                           
                        }
                        let dateFormatter : DateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm:ss"
                        let date = Date()
                        let dateString = dateFormatter.string(from: date)
                        print("**",dateString)
                        let Aseconds = time?.numberOfSeconds()
                        let serverTimeStamp = ServerValue.timestamp() as! [String:Any]
                        firebasePrm =
                            [
                                "fromID":UserDetails.sharedInstance.userID,
                                "messageTime":serverTimeStamp ?? 00,
                                "messageType":"IMAGE",
                                "device_type": "ios",
                                "receiverName":self.userNme,
                                "receiverProfilePic":self.profileImg,
                                "senderName": UserDefaults.standard.value(forKey: "fname") as? String ?? "",
                                "image":self.base64ImgString,
                                "toID":self.userId
                            ]
                        let newRef = self.ref.child(self.msgGrpId).childByAutoId()
                        newRef.setValue(firebasePrm)
                        self.arrTableViewDatSource = []
                        self.getmsghistory()
                    }
                    else
                    {
                        AppHelper.sharedInstance.removeSpinner()

                    }
                case .failure(_):
                    print("failed")
                    AppHelper.sharedInstance.displaySpinner()

                    break
                }}
        }
        else
        {
            
            if(msgTW.text == "")
            {
                
            }
            else
            {
                parameter =
                    [
                        "app_type" :"HANG",
                        "user_id":UserDetails.sharedInstance.userID,
                        "message_group_id":msgGrpId ?? "",
                        "device_type": "ios",
                        "message_text": encodeStr ?? "",
                        "receiver_user_id" : userId,
                        "message_types":"TEXT",
                        "image_data" : ""
                        
                    ]
                
                print(parameter)
                Alamofire.request(ksendmessage, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
                    
                    print(response.result)
                    switch response.result
                    {
                    case .success(let value):
                        if let JSON = value as? [String: Any]
                        {
                          
                          
                          if(self.msgGrpId == "")
                            {
                            self.msgGrpId = "\(JSON["message_group_id"] as? Int ?? 0)"
                            
                           
                            }
                        
                            self.msgTW.text = ""
                            self.arrTableViewDatSource = []
                            self.getmsghistory()
                          
                        }
                    case .failure(_):
                        print("failed")
                        ///self.hideActivityLoader()
                        break
                    }}}
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        self.dismiss(animated: true) { [weak self] in
            guard let simage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            let imageData = simage.jpegData(compressionQuality: 0.8)
            self?.imgVWSelect.isHidden = false
            self?.imgVw.image = simage
            let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL
            {
                let fileName = url.lastPathComponent
                let fileType = url.pathExtension
                self?.selectedImgName = "\(fileName).\(fileType)"
            }
            self?.uploadFile(withImage: simage)
            self?.msgType = "IMAGE"
        }
    }
    
    
    func uploadFile(withImage image: UIImage) {
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.APSouth1,
          identityPoolId:"ap-south-1:db9ddd50-a5ee-4dfc-b0a3-5af599d735d9")
        
      let configuration = AWSServiceConfiguration(region:.APSouth1, credentialsProvider:credentialsProvider)
        
      AWSServiceManager.default().defaultServiceConfiguration = configuration
   
     //  let compressedImage = image//.resizedImage(newSize: CGSize(width: 80, height: 80))
       let data: Data = image.pngData()!
       let remoteName = generateRandomStringWithLength(length: 12)+"."+data.format
       print("REMOTE NAME : ",remoteName)

       let expression = AWSS3TransferUtilityUploadExpression()
       expression.progressBlock = { (task, progress) in
           DispatchQueue.main.async(execute: {
               // Update a progress bar
           })
       }

      var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
       completionHandler = { (task, error) -> Void in
           DispatchQueue.main.async(execute: {
            print("Transfer Complete")
           })
       }

       let transferUtility = AWSS3TransferUtility.default()
       transferUtility.uploadData(data, bucket: bucketName, key: remoteName, contentType: "image/"+data.format, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
           if let error = task.error {
               print("Error : \(error.localizedDescription)")
           }

           if task.result != nil {
               let url = AWSS3.default().configuration.endpoint.url
            let publicURL = url?.appendingPathComponent(self.bucketName).appendingPathComponent(remoteName)
               if let absoluteString = publicURL?.absoluteString {
                   // Set image with URL
                   print("Image URL : ",absoluteString)
                
                self.base64ImgString = absoluteString
                
               }
           }
           

           return nil
       }

   }
    
    func generateRandomStringWithLength(length: Int) -> String {
        let randomString: NSMutableString = NSMutableString(capacity: length)
        let letters: NSMutableString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var i: Int = 0

        while i < length {
            let randomIndex: Int = Int(arc4random_uniform(UInt32(letters.length)))
            randomString.append("\(Character( UnicodeScalar( letters.character(at: randomIndex))!))")
            i += 1
        }
        return String(randomString)
    }
    
    
    func uploadFile(with resource: String, type: String) {   //1
        let key = "\(resource).\(type)"
        let localImagePath = Bundle.main.path(forResource: resource, ofType: type)!  //2
        let localImageUrl = URL(fileURLWithPath: localImagePath)
        
        let request = AWSS3TransferManagerUploadRequest()!
        request.bucket = bucketName  //3
        request.key = key  //4
        request.body = localImageUrl
        request.acl = .publicReadWrite  //5
        
        //6
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(request).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in
            if let error = task.error {
                print(error)
            }
            if task.result != nil {   //7
                print("Uploaded \(key)")
                //do any task
            }
            
            return nil
        }
        
    }
    
    
}
extension String {
    func numberOfSeconds() -> Int {
        var components: Array = self.components(separatedBy: ":")
        if components.count == 1
        {
            let hours = Int(components[0]) ?? 0
            let minutes = 0
            let seconds = 0
            return (hours * 3600) + (minutes * 60) + seconds
        }
        if components.count == 2
        {
            let hours = Int(components[0]) ?? 0
            let minutes = Int(components[1]) ?? 0
            let seconds = 0
            return (hours * 3600) + (minutes * 60) + seconds
        }
        if components.count == 3
        {
            let hours = Int(components[0]) ?? 0
            let minutes = Int(components[1]) ?? 0
            let seconds = Int(components[2]) ?? 0
            return (hours * 3600) + (minutes * 60) + seconds
        }
        return 1
    }
    
}
@available(iOS 13.0, *)
extension ChatVC:ChatCellDelegate{
    func messageTableViewCellUpdate()
    {
        tblVw.beginUpdates()
        tblVw.endUpdates()
    }
}

extension UITableView {
    
    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
        
        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
}
extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}

extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
extension UITableView {
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        if y < 0 { return }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
}

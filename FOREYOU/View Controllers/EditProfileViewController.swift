//

//

import UIKit
import AWSS3
import AWSCognito
import CropViewController
import SwiftyJSON
import CoreLocation

protocol EditProfileViewControllerDelegage {
    func refreshData()
}

class EditProfileViewController: BaseViewControllerClass, AddDocumentCollectionViewCellDelegate {
    func crossAction(index: Int) {
        pickImage()
    }
    
   
    
    var locationManager = CLLocationManager()
    var currentAddress = ""
    var lat = ""
    var long = ""
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLocation: UITextField!
    @IBOutlet weak var txtFieldOccupation: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPhone: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var Gender: UITextField!
    @IBOutlet weak var lookingfor: UITextField!
    
    @IBOutlet var containerView: [UIView]!
    @IBOutlet weak var documentCollectionView: UICollectionView!
    
    let bucketName = "foreyouawsnewbucket"
    var photosData = [[String:String]]()

    var base64ImgString = ""
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var imageDataArray = Array<NSData>()
    var profileImage = UIImageView()
    let imagePicker = UIImagePickerController()
    var uploadedImageUrl = [String]()
    var Profileimg:[JSON] = []
    


    
    var delegate:EditProfileViewControllerDelegage?
    static var viewControllerId = "EditProfileViewController"
    static var storyBoard = "Main"

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
        Gender.isUserInteractionEnabled = true
        lookingfor.isUserInteractionEnabled = true

        setInitials()
    }
    
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
    }
    func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
      
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        if let pm = placemarks{
                                            if pm.count > 0 {
                                                let pm = placemarks![0]
                                                var addressString : String = ""
                                                
                                                if pm.subThoroughfare != nil {
                                                    addressString = addressString + pm.subThoroughfare! + " "
                                                }
                                                if pm.thoroughfare != nil {
                                                    addressString = addressString + pm.thoroughfare! + ", "
                                                }
                                                
                                                if pm.locality != nil {
                                                    addressString = addressString + pm.locality! + ", "
                                                }
                                                if pm.administrativeArea != nil {
                                                    addressString = addressString + pm.administrativeArea! + " "
                                                }
                                                if pm.postalCode != nil {
                                                    addressString = addressString + pm.postalCode! + ", "
                                                }
                                                if pm.country != nil {
                                                    addressString = addressString + pm.country!
                                                }
                                                self.currentAddress = addressString
                                                print(addressString)
                                                self.txtFieldLocation.text =  self.currentAddress
                                                if self.currentAddress.count > 0
                                                {
                                             self.updatelocationApi()
                                                }
                                               
                                                
                                            }
                                        }
                                    })
    }
    
    
    func setInitials()
    {
         documentCollectionView.register(UINib(nibName: "AddDocumentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddDocumentCollectionViewCell")
          documentCollectionView.delegate = self
          documentCollectionView.dataSource = self
         profileImageView.cornerRadius = Double(profileImageView.frame.height/2)
          notificationView.cornerRadius = Double(notificationView.frame.height/2)
          for everyView in containerView{
              everyView.borderColor = UIColor.black
              everyView.borderWidth = 1
          }
        let email = UserDetails.sharedInstance.user_email.components(separatedBy: "@")

        txtFieldFirstName.text = email[0]
        txtFieldLocation.text = UserDetails.sharedInstance.user_location
        Gender.text =  UserDetails.sharedInstance.user_gender
        lookingfor.text =  UserDetails.sharedInstance.user_interested_for
        txtFieldOccupation.text = UserDetails.sharedInstance.user_profession
        txtFieldEmail.text = UserDetails.sharedInstance.user_email
        txtFieldPhone.text = UserDetails.sharedInstance.user_mobile_code + UserDetails.sharedInstance.user_mobile
        txtFieldPassword.text = UserDetails.sharedInstance.user_password
        
        if UserDetails.sharedInstance.user_profile_pic != ""{
            let imageUrl = UserDetails.sharedInstance.user_profile_pic
            if let url = URL(string: imageUrl){
                self.profileImageView.setImage(with: url , placeholder: UIImage(named: "Placeholder"), progress: { received, total in
                    // Report progress
                }, completion: { [weak self] image in
                    if (image != nil){
                        self!.profileImageView.image = image
                    }
                    else{
                        self!.profileImageView.image = UIImage(named: "")
                    }
                })
            }
            else{
                self.profileImageView.image = UIImage(named: "")
            }
        }
      }
    
    func uploadFile(withImage image: UIImage) {
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.APSouth1,
          identityPoolId:"ap-south-1:db9ddd50-a5ee-4dfc-b0a3-5af599d735d9")
        
      let configuration = AWSServiceConfiguration(region:.APSouth1, credentialsProvider:credentialsProvider)
        
      AWSServiceManager.default().defaultServiceConfiguration = configuration
   
       ///let compressedImage = image.resizedImage(newSize: CGSize(width: 80, height: 80))
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
                self.uploadedImageUrl.append(absoluteString)
               }
           }
        self.setUpUploadedUrl()

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
    @IBAction func btnBackAction(_ sender: Any) {
        self.delegate?.refreshData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkValidation() -> Bool{
        if (txtFieldFirstName.text!.isEmpty) == true {
            showAlertWithMessage("Alert", "Please Enter Firstname")
            return false
        }
          
        else if (txtFieldOccupation.text!.isEmpty) == true {
            showAlertWithMessage("Alert", "Please Enter Occupation")
            return false
        }
        
        return true
    }

    @IBAction func btnSaveAction(_ sender: Any) {
        if checkValidation(){
           callSaveProfileApi()
        }
    }
    
    @IBAction func btnChangePAssword(_ sender: UIButton) {
        let jumpVC = (self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC)!
        self.navigationController?.pushViewController(jumpVC, animated: true)
    }
    @IBAction func Genderupdate(_ sender: UIButton) {
       
        if Gender.text == "" || Gender.text == nil
        {showAlertWithMessage("Alert", "Please Enter Gender")
            return
        
        }
        else  {
            self.updategenderApi()
        }
        
    }
    @IBAction func Forlookingupdate(_ sender: UIButton) {
        if lookingfor.text == "" ||  lookingfor.text == nil
        {
            showAlertWithMessage("Alert", "Please Enter Looking for..")
            return
           
        }
        else  {
            self.updategenderApi()
        }
    }
        @IBAction func locationupdate(_ sender: UIButton) {
            
            self.setupLocationManager()
         
    }
    private func pickImage(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        let profileAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.cameraCaptureMode = .photo
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(defaultAction)
        alertController.addAction(profileAction)
        alertController.addAction(cancelAction)
        alertController.modalPresentationStyle = .popover
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnChangeProfileAction(_ sender: Any) {
       // pickImage()
    }
    
    @IBAction func btnSettingsAction(_ sender: Any) {
        openSettings()
    }
    
    func openSettings(){
        let controller = SettingsViewController.instantiateFromStoryBoard()
        self.present(controller, animated: true, completion: nil)
    }
    
}
extension EditProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         if self.Profileimg.count == 3
        {
             return self.Profileimg.count
         }
        else {
            return  self.Profileimg.count + 1
        }
      
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = documentCollectionView.dequeueReusableCell(withReuseIdentifier: "AddDocumentCollectionViewCell", for: indexPath) as? AddDocumentCollectionViewCell
        
        
        
        if indexPath.row ==  self.Profileimg.count
        {
            
            cell?.containerView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
            cell?.containerView.layer.borderWidth = 0.5
            cell?.containerView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            image = UIImage(named: "addIcon")
            cell?.addicon.image = self.image
            cell?.documentImageView.isHidden = true
            cell?.addicon.isHidden = false
            cell?.RremoveBtn.isHidden = true
            return cell!
            
        }
        else  {
            if indexPath.row == 0 {
                cell?.documentImageView.isHidden = false
                cell?.addicon.isHidden = true
            cell?.containerView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
                cell?.containerView.layer.borderWidth = 0.5
                cell?.containerView.layer.borderColor = UIColor.red.cgColor
                
                 let dict = self.Profileimg[indexPath.row].dictionaryValue
                let object = dict["url"]?.stringValue
              
                cell?.documentImageView.sd_setImage(with: URL(string:object ?? ""), placeholderImage: UIImage(named: "user_place"))
                cell?.RremoveBtn.isHidden = false
                
                cell?.RremoveBtn.addTarget(self, action: #selector(deleteimage), for: .touchUpInside)
                 cell?.RremoveBtn.tag  = indexPath.row
                
            }
            
            else if indexPath.row == 1
            {
                cell?.documentImageView.isHidden = false
                cell?.addicon.isHidden = true
            cell?.containerView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
                cell?.containerView.layer.borderWidth = 0.5
                cell?.containerView.layer.borderColor = UIColor.black.cgColor
                
                 let dict = self.Profileimg[indexPath.row].dictionaryValue
                let object = dict["url"]?.stringValue
              
                cell?.documentImageView.sd_setImage(with: URL(string:object ?? ""), placeholderImage: UIImage(named: "user_place"))
                cell?.RremoveBtn.isHidden = false
                
                cell?.RremoveBtn.addTarget(self, action: #selector(deleteimage), for: .touchUpInside)
                 cell?.RremoveBtn.tag  = indexPath.row
                
            }
            else {
                cell?.documentImageView.isHidden = false
                cell?.addicon.isHidden = true
                cell?.RremoveBtn.isHidden =  false
                cell?.containerView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
                cell?.containerView.layer.borderWidth = 0.5
                    cell?.containerView.layer.borderColor = UIColor.white.cgColor
                cell?.containerView.layer.borderColor = UIColor.clear.cgColor
                
                 let dict = self.Profileimg[indexPath.row].dictionaryValue
                let object = dict["url"]?.stringValue
              
                cell?.documentImageView.sd_setImage(with: URL(string:object ?? ""), placeholderImage: UIImage(named: "user_place"))
                
                
                cell?.RremoveBtn.addTarget(self, action: #selector(deleteimage), for: .touchUpInside)
                 cell?.RremoveBtn.tag  = indexPath.row
                
           
            }
       
            return cell!
        }
        
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 101)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         if self.Profileimg.count  == 3
                
         {
             
         }
        else {
            
            let dict = self.Profileimg[indexPath.row].dictionaryValue
           let object = dict["url"]?.stringValue
            
             if object == "" || object ==  nil
             {
                 self.pickImage()
             }
            else {
                
            }
           
        }
      
      
    }
    
    @objc  func deleteimage(sender:UIButton)
    {
        
        let dict = self.Profileimg[sender.tag].dictionaryValue
        let id = dict["id"]?.stringValue
        
        let alert = UIAlertController(title: "Delete Picture!", message: "Do you want to delete photo?",
                                      
        preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            
            self.dismiss(animated: true, completion: nil)
            
          }))
            
                        
     alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        
        self.dismiss(animated: true, completion: nil)
        
        
        self.calldeleteProfileApi(id: id ?? "0")
         
      }))
        
       self.present(alert, animated: true, completion: nil)
        
       }
    
}
extension EditProfileViewController{
    
    
    
    func calldeleteProfileApi(id:String){
      
         
     
     let param = ["app_type": AppType,
                      "user_id": UserDetails.sharedInstance.userID,
                     "id": id,
                     ] as [String : Any]

        WebServiceHandler.performPOSTRequest(urlString: remove_profile_picture, params: param ) { (result, error) in

             if (result != nil){
                let statusCode = result!["status"]?.string
                 let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                
                    self.callGetProfileInfoApi()
                }
                 else{
                     
                 }
               
            }
            else{
              
            }
         }
     }

    
    
   func callSaveProfileApi(){
     
    
    let param = ["app_type": AppType,
                     "user_id": UserDetails.sharedInstance.userID,
                    "user_firstname": txtFieldFirstName.text!,
                    "user_lastname":  "",
                    "professiontion": txtFieldOccupation.text!
                    ] as [String : Any]

       WebServiceHandler.performPOSTRequest(urlString: updateprofile, params: param ) { (result, error) in

            if (result != nil){
               let statusCode = result!["status"]?.string
                let msg = result!["msg"]?.string
               if statusCode == "200"
               {
                self.txtFieldFirstName.text!  =    UserDetails.sharedInstance.user_firstname;                 self.txtFieldLocation.text! =   UserDetails.sharedInstance.user_location
                    self.txtFieldOccupation.text! =     UserDetails.sharedInstance.user_profession
                self.showAlertWithMessage("ALERT", msg!)
                   AppHelper.saveUserDetails()
               }
                else{
                    self.showAlertWithMessage("ALERT", msg!)
                }
              
           }
           else{
             
           }
        }
    }

    
    
    func callGetProfileInfoApi(){
        
             let param = ["app_type": AppType,
                         "user_id":UserDetails.sharedInstance.userID,
                ] as [String : Any]
            
          WebServiceHandler.performPOSTRequest(urlString: kGetProfileInfo, params: param ) { (result, error) in
                
                if (result != nil){
                    let statusCode = result!["status"]?.string
                    let msg = result!["msg"]?.string
                    if statusCode == "200"
                    {
                        
                        if let response = result!["user_data"]!.dictionary{
                            UserDetails.sharedInstance.user_religion = response["user_religion"]?.string ?? ""
                            UserDetails.sharedInstance.user_dob = response["user_dob"]?.string ?? ""
                            UserDetails.sharedInstance.user_aboutme = response["user_aboutme"]?.string ?? ""
                            UserDetails.sharedInstance.user_mobile_code = response["user_mobile_code"]?.string ?? ""
                            UserDetails.sharedInstance.user_email = response["user_email"]?.string ?? ""
                            UserDetails.sharedInstance.user_education = response["user_education"]?.string ?? ""
                            UserDetails.sharedInstance.user_firstname = response["user_firstname"]?.string ?? ""
                            UserDetails.sharedInstance.user_interested_for = response["user_interested_for"]?.string ?? ""
                            UserDetails.sharedInstance.user_profession = response["user_profession"]?.string ?? ""
                            UserDetails.sharedInstance.user_age = response["user_age"]?.string ?? ""
                            
                            UserDetails.sharedInstance.user_location = response["user_location"]?.string ?? ""
                             
                             let picarr = response["user_profile_image"]?.arrayValue
                            
                            self.Profileimg = picarr ?? []
                            
                         
                            print(self.Profileimg.count)
                            
                             let dict =  picarr?.first?.dictionaryValue
                            
                            
                            let user_profile_pic =   dict?["url"]?.stringValue
                        
                             UserDetails.sharedInstance.user_profile_pic = user_profile_pic ?? ""
                            
                            UserDetails.sharedInstance.user_lastname = response["user_lastname"]?.string ?? ""
                            UserDetails.sharedInstance.user_weight = response["user_weight"]?.string ?? ""
                            UserDetails.sharedInstance.user_relationship_status = response["user_relationship_status"]?.string ?? ""
                            UserDetails.sharedInstance.user_password = response["user_password"]?.string ?? ""
                            UserDetails.sharedInstance.user_height = response["user_height"]?.string ?? ""
                            UserDetails.sharedInstance.user_gender = response["user_gender"]?.string ?? ""
                            UserDetails.sharedInstance.user_mobile = response["user_mobile"]?.string ?? ""
                            self.lblUserName.text = UserDetails.sharedInstance.user_firstname   + " " + UserDetails.sharedInstance.user_lastname
                            
                              
                           if  self.Profileimg.count == 0
                            {
                            UserDetails.sharedInstance.user_profile_pic = ""
                            
                            self.profileImageView.image = UIImage(named: "")
                             NotificationCenter.default.post(name: Notification.Name("Updateimage"), object: nil)
                            }
                           else {
                       
                            if UserDetails.sharedInstance.user_profile_pic != ""{
                                let imageUrl = UserDetails.sharedInstance.user_profile_pic
                                if let url = URL(string: imageUrl){
                                    self.profileImageView.setImage(with: url , placeholder: UIImage(named: "Placeholder"), progress: { received, total in
                                        // Report progress
                                    }, completion: { [weak self] image in
                                        if (image != nil){
                                            self!.profileImageView.image = image
                                        }
                                        else{
                                            self!.profileImageView.image = UIImage(named: "")
                                        }
                                    })
                                }
                                else{
                                    self.profileImageView.image = UIImage(named: "")
                                }
                            }
                     
                           }
                            self.documentCollectionView.dataSource = self
                            self.documentCollectionView.delegate  = self
                            self.documentCollectionView.reloadData()
                            print(response)
                            
                        }
                    }
                    else{
                        
                    }
                    AppHelper.sharedInstance.removeSpinner()
                }
                else{
                    AppHelper.sharedInstance.removeSpinner()
                }
            }
            
        }
        
    
  func setUpUploadedUrl()
    {
       for i in uploadedImageUrl{
            
        let data = ["media_url":i]
            
         self.saveProfileDataApi(img: i)
           // photosData.append(data)
         }
     }
    
    func saveProfileDataApi(img:String){
           
         let param = ["app_type": AppType,
         "user_id":UserDetails.sharedInstance.userID,"image_data":img
        ]
         as [String : Any]
           
           WebServiceHandler.performPOSTRequest(urlString: kUpdateProfileURL, params: param ) { (result, error) in
                print(result)
                  if (result != nil){
                
                   let statusCode = result!["status"]?.string
                   let msg = result!["msg"]?.string
                   if statusCode == "200"
                   {
                    
                    self.callGetProfileInfoApi()
                    
                     
                   }
                   else{
                      
                   }
                  
               }
           }
       }
    
}
//MARK: - CropViewControllerDelegate
extension EditProfileViewController: CropViewControllerDelegate,UINavigationControllerDelegate {
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
       
        profileImageView.image = image
        self.image = image
       
       
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if cropViewController.croppingStyle != .circular {
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                        toView: profileImageView,
                    toFrame: CGRect.zero,
                    setup: {  },
                completion: nil)
            uploadFile(withImage: image)
        }
        else {
           
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
}

//MARK: - UIIMagePickerDelegate
extension EditProfileViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
       

     let imageData = image.jpegData(compressionQuality: 0.6)

      let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        
          self.base64ImgString = imageStr
        
       if croppingStyle == .circular {
            if picker.sourceType == .camera {
                picker.dismiss(animated: true, completion: {
                    self.present(cropController, animated: true, completion: nil)
                })
            } else {
                picker.pushViewController(cropController, animated: true)
            }
        }
        else {
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
            })
        }
    }
    
}
extension EditProfileViewController{
    
    
func updategenderApi()
  {
     
      let param = ["app_type": AppType,
                   "email": UserDetails.sharedInstance.user_email,
                   "mobile": self.txtFieldPhone.text ?? "",
                   "country_code":  UserDetails.sharedInstance.user_mobile_code,
                   "gender": self.Gender.text ?? "",
                   "looking_for": self.lookingfor.text ?? "",
                   "lat": lat,
                   "long": long,
                   "user_location": self.txtFieldLocation.text ?? ""
                  ] as [String : Any]
      
      WebServiceHandler.performPOSTRequest(urlString: kSignUp2URL, params: param ) { (result, error) in
          
           
          if (result != nil){
              let statusCode = result!["status"]?.string
              let msg = result!["msg"]?.string
              if statusCode == "200"
              {
                self.showAlertWithMessage("", msg!)
                  
                 
                }
              else{
                  self.showAlertWithMessage("ALERT", msg!)
              }
              
          }
          else{
              
          }
      }
      
  }
    
    func updatelocationApi()
      {
        
          let param = ["app_type": AppType,
                       "user_id": UserDetails.sharedInstance.userID,
                       "lat": lat,
                       "long": long,
                       "user_location": self.txtFieldLocation.text ?? ""
                      ] as [String : Any]
          
          WebServiceHandler.performPOSTRequest(urlString: kupdatelocation, params: param ) { (result, error) in
              
            AppHelper.sharedInstance.removeSpinner()
              if (result != nil){
                  let statusCode = result!["status"]?.string
                  let msg = result!["msg"]?.string
                  if statusCode == "200"
                  {
                    
                    self.showAlertWithMessage("", msg!)
                      
                     
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

  extension EditProfileViewController:CLLocationManagerDelegate{
    
    
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.last != nil{
            
        }else{
             return
        }
        
       print(locationManager.location)
    
        lat = "\(locationManager.location!.coordinate.latitude)"
    
        if(lat == nil)
        {
            lat = "28.704"
        }
    
        long = "\(locationManager.location!.coordinate.longitude)"
    
        if(long == nil)
        {
            long = "77.102"
        }
        getAddressFromLatLon(pdblLatitude: "\(locationManager.location!.coordinate.latitude)", pdblLongitude: "\(locationManager.location!.coordinate.longitude)")
        locationManager.stopUpdatingLocation()
    }
    
}

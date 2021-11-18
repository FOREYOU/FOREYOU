//
//  ProfileSettingsViewController.swift
//  Hang
//
//  Created by Vikas Kushwaha on 29/10/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
import CropViewController
import MapleBacon
import SwiftyJSON
import AWSS3
import AWSCognito
class ProfileSettingsViewController: BaseViewControllerClass,ProfileCollectionViewCellDelegate,EditProfileViewControllerDelegage , UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate, UITableViewDataSource {
    func changePassword() {
        let jumpVC = (self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC)!
        self.navigationController?.pushViewController(jumpVC, animated: true)
      
    }
    
    func deleletimage(index:Int)  {
        self.deleteimage(senderindex: index)
    }
    
    enum Category{
        case PersonalityMatrix
        case Profile
    }
    
     @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var tabelview: UITableView!

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var btnViewProfile: UIButton!
    @IBOutlet weak var notificationView: UIView!
     @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var imgViewwidthConstraint: NSLayoutConstraint!

    
    var base64ImgString = ""
    var getProfileImages:[JSON] = []
    
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var imageDataArray = Array<NSData>()
    var profileImage = UIImageView()
    let imagePicker = UIImagePickerController()
    
    static var viewControllerId = "ProfileSettingsViewController"
    static var storyBoard = "Main"
    var photosData = [[String:String]]()
    var uploadedImageUrl = [String]()
    var selecttag:Bool?
    var matrixlist = [matrixModel]()
    var segmnetarr : [Bool] = []
    
    var isExpanded = [Bool]()

    
    let bucketName = "foreyouawsnewbucket"
    var selecttab:Bool = false

    var selectedView = Category.PersonalityMatrix
    let imageList = ["1_edit_profile","2_Experience_summary","3_notifications","4_card","5_help","6_tnc","7_pp","8_logout"]
    let dataList = ["Edit Profile","Experience summary","Notifications","Payments and cards","Help","Terms and conditions","Privacy policy","Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
       
            backbtn.isHidden = true
        
        imgViewwidthConstraint.constant = 7
        tabelview.rowHeight = UITableView.automaticDimension
        tabelview.estimatedRowHeight = 75
       
        setInitials()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.segmnetarr = []
        self.matrixlist = []
        self.isExpanded = []
        callGetProfileInfoApi()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnChangeProfileAction(_ sender: Any) {
       /// pickImage()
    }
    
    func setInitials(){
      //  callGetProfileInfoApi()
       
        tabelview.registerCell("HorizontalCell")
        tabelview.registerCell("CircleCell")
        profileCollectionView.isHidden = true
        
    profileCollectionView.register(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCollectionViewCell")
     
        
        profileImageView.cornerRadius = Double(profileImageView.frame.height/2)
        notificationView.cornerRadius = Double(notificationView.frame.height/2)
        btnViewProfile.cornerRadius = Double(btnViewProfile.frame.height/2)
        
    }
    
    @IBAction func connectSocailAcc(_ sender: Any)
    {
        let jumpVC = (self.storyboard?.instantiateViewController(withIdentifier: "SocialAccountConnectVC") as? SocialAccountConnectVC)!
        jumpVC.email = UserDetails.sharedInstance.user_email
        self.navigationController?.pushViewController(jumpVC, animated: true)
    }
    
    
    func callPickImage() {
        
        pickImage()
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
    
    
    @IBAction func btnPersonalityMatrixAction(_ sender: Any) {
     
        UIView.animate(withDuration: 0.5, animations: {
            self.sliderView.frame = CGRect(x: 0, y: 58, width: self.sliderView.frame.width, height: self.sliderView.frame.height)
            
        })
        tabelview.isHidden = false
        profileCollectionView.isHidden = true
        tabelview.dataSource = self
        tabelview.delegate = self
         tabelview.reloadData()
    }
    
    @IBAction func btnProfileAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.sliderView.frame = CGRect(x:  self.sliderView.frame.width, y: 58, width: self.sliderView.frame.width, height: self.sliderView.frame.height)
            
        })
        tabelview.isHidden = true
        profileCollectionView.isHidden = false
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.reloadData()
    }
    
    
    @IBAction func btnSettingsAction(_ sender: Any) {
        openSettings()
    }
    
    func openSettings(){
        let controller = SettingsViewController.instantiateFromStoryBoard()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnEditProfileAction(_ sender: Any) {
        let controller = EditProfileViewController.instantiateFromStoryBoard()
        controller.Profileimg = self.getProfileImages
        controller.delegate = self
        push(controller)
        
    }
    func refreshData() {
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
        profileCollectionView.reloadData()
    }
    func setUpUploadedUrl()
    {
        for i in uploadedImageUrl{
            //let data = ["media_url":i]
            saveProfileDataApi(img: i)
          //  photosData.append(data)
        }
       
        //saveProfileDataApi()
       
    }

    @objc func inviteclicked(_ sender: UISwitch) {
        
    
      self.updatestueApi(index: sender.tag)
    
    }
   
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
    self.segmnetarr.count
     
      
    }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
        
        let value   =  self.matrixlist[indexPath.row].value
        
        let name   =  self.matrixlist[indexPath.row].name
        
        let desc   =  self.matrixlist[indexPath.row].desc
        
       let  value_desc  =  self.matrixlist[indexPath.row].value_desc
        
        
    if  segmnetarr[indexPath.row] == false
          {
     
              let cell = tabelview.dequeueReusableCell(withIdentifier: "HorizontalCell") as? HorizontalCell
             
         
              if value == "HIGH"
               {
                cell?.firstGradientProgress.setProgress(85/100, animated: false)
               }
            
              else if value == "LOW"
            {
                cell?.firstGradientProgress.setProgress(35/100, animated: false)
            }
            else {
                cell?.firstGradientProgress.setProgress(60/100, animated: false)
            }
           
            
            if matrixlist[indexPath.row].status == 1
            {
                cell?.status?.isOn = false
                cell?.tabstatus.text = "Private"
            }
            else {
                cell?.status?.isOn = true
                cell?.tabstatus.text = "Public"
            }
            
            
            cell?.name.text =  name
            cell?.value.text = value
            cell?.Descepition.attributedText = desc?.htmlToAttributedString
              cell?.status?.addTarget(self, action: #selector(inviteclicked), for: .valueChanged)
             cell?.status?.tag  = indexPath.row
        cell?.Dropdownbnt?.addTarget(self, action: #selector(dropdown), for: .touchUpInside)
        
        cell?.Dropdownbnt.tag = indexPath.row
      
       
        
        if  self.isExpanded[indexPath.row] == true
        {
            let compleltetext =  desc! +  value_desc!
            
            cell?.Descepition.attributedText =  compleltetext.htmlToAttributedString
          cell?.Dropdownbnt.setImage(UIImage (named: "up.png"), for: .normal)
        }
        else {
            cell?.Descepition.attributedText = desc?.htmlToAttributedString
          
            
             cell?.Dropdownbnt.setImage(UIImage (named: "down.png"), for: .normal)
            
            
     
        }
        cell?.selectionStyle = .none
            
         return cell!
              }
          
        else {
             
              let cell = tabelview.dequeueReusableCell(withIdentifier: "CircleCell") as? CircleCell
             
              if value == "HIGH"
            {
                cell?.circularProgressView.angle = 290
            }
            else  if value == "LOW"
            {
                cell?.circularProgressView.angle =  120
            }
            else  {
                cell?.circularProgressView.angle = 230
            } 
            
            if matrixlist[indexPath.row].status == 1
            {
                cell?.status?.isOn = false
                cell?.tabstatus.text = "Private"
            }
            else {
                cell?.status?.isOn = true
                cell?.tabstatus.text = "Public"
            }
            
            cell?.name.text =  name
            cell?.namevalue.text = value
            
            cell?.Descepition.attributedText = desc?.htmlToAttributedString
           
              cell?.selectionStyle = .none
            cell?.status?.addTarget(self, action: #selector(inviteclicked), for: .valueChanged)
             cell?.status?.tag  = indexPath.row
            
            
            cell?.Dropdownbnt?.addTarget(self, action: #selector(dropdown), for: .touchUpInside)
            
            cell?.Dropdownbnt.tag = indexPath.row
          
              
            
            if  self.isExpanded[indexPath.row] == true
            {
                let compleltetext =  desc! +  value_desc!
                
                cell?.Descepition.attributedText =  compleltetext.htmlToAttributedString
              cell?.Dropdownbnt.setImage(UIImage (named: "up.png"), for: .normal)
            }
            else {
                cell?.Descepition.attributedText = desc?.htmlToAttributedString
              
                
                 cell?.Dropdownbnt.setImage(UIImage (named: "down.png"), for: .normal)
                
                
         
            }
             return cell!
          }
          
          }
   
    
    @objc  func dropdown(sender: UIButton) {
        
        
       
        if self.isExpanded[sender.tag] == true
       {
            
            self.isExpanded.remove(at: sender.tag)
            self.isExpanded.insert( false, at: sender.tag)
            print(self.isExpanded)
          
        
         
          }
       else {
           self.isExpanded.remove(at: sender.tag)
           
           self.isExpanded.insert( true, at: sender.tag)
          
           print(self.isExpanded)
       }
       
       
            self.tabelview.reloadData()


    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
         
          return 1
        
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
                let  cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as? ProfileCollectionViewCell
            
                cell!.txtFieldFirstName.text = UserDetails.sharedInstance.user_firstname
                cell!.txtFieldLocation.text = UserDetails.sharedInstance.user_location
                cell!.txtFieldOccupation.text = UserDetails.sharedInstance.user_profession
                cell!.txtFieldEmail.text = UserDetails.sharedInstance.user_email
                cell!.txtFieldPhone.text = UserDetails.sharedInstance.user_mobile_code + UserDetails.sharedInstance.user_mobile
                cell!.txtFieldPassword.text = UserDetails.sharedInstance.user_password
                cell!.Gender.text =  UserDetails.sharedInstance.user_gender
                cell!.lookingfor.text =  UserDetails.sharedInstance.user_interested_for
                
                
                
                if(UserDefaults.standard.value(forKey: "account_status") as? Int == 1)
                {
                    
                }
                cell!.Profileimage = self.getProfileImages
            
            
                cell?.documentCollectionView.reloadData()
                cell?.delegate = self
                return cell!
            
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
             return CGSize(width: self.view.frame.size.width, height:870)
               
        }
        
    
    @objc  func deleteimage(senderindex:Int)
    {
        
        let dict = self.getProfileImages[senderindex].dictionaryValue
        
        let id =  dict["id"]?.stringValue
        
        
        
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


extension ProfileSettingsViewController{
    
    
    
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
                    self.segmnetarr = []
                    self.matrixlist = []
                
                    
                    self.selecttab = true
                   
                    
                    self.callGetProfileInfoApi()
                }
                 else{
                     
                 }
               
            }
            else{
              
            }
         }
     }

    func updatestueApi(index:Int){
         
        var status :Int?
      
         if matrixlist[index].status == 1
          {
            status  = 0
            
          }
            else {
                 status = 1
            }
         
        let param = ["app_type": AppType,
                     "user_id":UserDetails.sharedInstance.userID,"type": matrixlist[index].id!, "status" :status ?? 0
            ] as [String : Any]
        
        WebServiceHandler.performPOSTRequest(urlString: updatevisibility, params: param ) { (result, error) in
            
            if (result != nil){
                let statusCode = result!["status"]?.string
                let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                    
                    let matrixobj = self.matrixlist[index]
                    
                    if self.matrixlist[index].status ==  1
                     {
                        
                        matrixobj.status = 0
                        self.matrixlist.remove(at: index)
                        self.matrixlist.insert(matrixobj, at:index)
                        
            
                     }
                     else {
                        matrixobj.status = 1
                        self.matrixlist.remove(at: index)
                        self.matrixlist.insert(matrixobj, at:index)
                     }
                    
                   
                    self.tabelview.reloadData()
                     
                    }
                        
                    else{
                    DispatchQueue.main.async {
                        self.showAlertWithMessage("ALERT", msg ?? "")
                    }
                }
               
            }
        }
    }
}
    extension ProfileSettingsViewController{
        
        func saveProfileDataApi(img:String){
            
            let param = ["app_type": AppType,
                         "user_id":UserDetails.sharedInstance.userID,"image_data":img
                ] as [String : Any]
            
            WebServiceHandler.performPOSTRequest(urlString: kUpdateProfileURL, params: param ) { (result, error) in
                
                if (result != nil){
                    let statusCode = result!["status"]?.string
                    let msg = result!["msg"]?.string
                    if statusCode == "200"
                    {
                       
                      self.callGetProfileInfoApi()
                         
                        }
                            
                        else{
                        DispatchQueue.main.async {
                            self.showAlertWithMessage("ALERT", msg ?? "")
                        }
                    }
                   
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
                        
                        self.getProfileImages = picarr ?? []
                        
                      
                        
                        if picarr?.count == 0
                            
                        {
                            NotificationCenter.default.post(name: Notification.Name("Updateimage"), object: nil)

                             UserDetails.sharedInstance.user_profile_pic = ""
                            self.profileImageView.image = UIImage(named: "")
                        }
                    
                        else {
                            
                            
                        }
                       
                          
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
                        
                        let matrxiarr = response["matrix"]?.arrayValue
                        
                         
                       
                        for ApiJSON in  matrxiarr! {
                          
                           let  c =   matrixModel(json: ApiJSON)
                         
                         self.matrixlist.append(c)
                          
                       }
                        
                        var  vertical : Bool = false
                        
                           
                        for i in 0..<matrxiarr!.count   {
                            if (i != 0 && i % 4 == 0) {
                            vertical = !vertical
                            }
                            print(i)
                            self.segmnetarr.append(vertical)
                            self.isExpanded.append(false)
                        }
                         
                            print(self.segmnetarr.count)
                        print(self.isExpanded.description)
                        print(self.isExpanded.count)
                        print(self.matrixlist.count)
                        
                   
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
                 
                         if self.selecttab ==  true
                         {
                            self.tabelview.isHidden = true
                            self.profileCollectionView.isHidden = false
                            self.profileCollectionView.delegate = self
                            self.profileCollectionView.dataSource = self
                            self.profileCollectionView.reloadData()
                            
                            
                         }
                         else {
                            self.tabelview.dataSource = self
                            self.tabelview.delegate  = self
                            self.tabelview.reloadData()
                         }
                       
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
    
    
}
//MARK: - CropViewControllerDelegate
extension ProfileSettingsViewController: CropViewControllerDelegate,UINavigationControllerDelegate {
    
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
        
        self.profileCollectionView.reloadData()
        
        let param = ["app_type":AppType,"user_id":UserDetails.sharedInstance.userID]
      
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if cropViewController.croppingStyle != .circular {
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                toView: profileCollectionView,
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
extension ProfileSettingsViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        print(image.size.height)
        print(image.size.width)
         let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
       cropController.delegate = self
        self.image = image
        
        self.base64ImgString = convertImageToBase64(image: self.image!)
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

extension  ProfileSettingsViewController {
    
    func uploadFile(withImage image: UIImage) {
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.APSouth1,
        
        identityPoolId:"ap-south-1:db9ddd50-a5ee-4dfc-b0a3-5af599d735d9")
        
      let configuration = AWSServiceConfiguration(region:.APSouth1, credentialsProvider:credentialsProvider)
        
      AWSServiceManager.default().defaultServiceConfiguration = configuration
   
       
       let data: Data = image.pngData()!
       let remoteName = generateRandomStringWithLength(length: 12)+"."+data.format
       print("REMOTE NAME : ",remoteName)

       let expression = AWSS3TransferUtilityUploadExpression()
       expression.progressBlock = { (task, progress) in
           DispatchQueue.main.async(execute: {
            
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
            if  self.uploadedImageUrl.count > 0
            {
                self.setUpUploadedUrl()
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

extension ProfileSettingsViewController{
    
    
    func callSignUpApi(){
        
      
    let param = ["app_type": AppType,
                     "user_id":UserDetails.sharedInstance.userID,
                     "usage_data":[
                     "MEDIA_DATA":photosData
                        ]
        ] as [String : Any]
        
        
        WebServiceHandler.performPOSTRequest(urlString: kSignUp5URL, params: param ) { (result, error) in
            if (result != nil){
                
                let statusCode = result!["status"]?.string
                
                let msg = result!["msg"]?.string
                
                if statusCode == "200"
                {
                    let user_id = result!["user_id"]?.string
                    
                    UserDetails.sharedInstance.userID =  user_id!
                    
                    
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
    
    
    
    
}

func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString,
                             options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
    }



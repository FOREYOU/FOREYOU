//
//  PhotosViewController.swift
//  FOREYOU
//
//  Created by Vikas Kushwaha on 08/02/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import CropViewController
import AWSS3
import AWSCognito
import SwiftyJSON
import CoreBluetooth
import MediaPlayer
import SystemConfiguration.CaptiveNetwork
import StoreKit
import CoreLocation
import Contacts
import AVFoundation
import Alamofire
class PhotosViewController: BaseViewControllerClass {
    var country = "us"
  
    
    var email = ""
    var mobile = ""
    var photosData = [[String:String]]()
    

  

    //S3Bucket
    let bucketName = "foreyouawsnewbucket"
    
    var imageURL = NSURL()
    
    static var viewControllerId = "PhotosViewController"
    static var storyBoard = "Main"
    
    var base64ImgString = ""
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var imageDataArray = Array<NSData>()
    var profileImage = UIImageView()
    let imagePicker = UIImagePickerController()
    
    var imageArray = [UIImage]()
    
    var uploadedImageUrl = [String]()

    @IBOutlet weak var photosCollectionView: UICollectionView!
    var indicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: CGFloat(photosCollectionView.frame.width - 15)/3, height: 120.0)
        photosCollectionView.collectionViewLayout = layout
        
        photosCollectionView.register(UINib(nibName: "PhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotosCollectionViewCell")
       
       
       
        
      
    // Do any additional setup after loading the view.
    }
    
    
   override func viewDidAppear(_ animated: Bool) {
    
    
    }
    
    func setUpUploadedUrl()
    {
        for i in uploadedImageUrl{
            let data = ["media_url":i]
            photosData.append(data)
        }
         callSignUpApi()
    }
    
  
   

    
    @objc func batteryLevelDidChange(_ notification: Notification) {
        // self.infoLabel.text = "🔋:\(Int(batteryLevel*100))%"
    }
    
    func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
    func decodeToBase64(str:String) -> String{
        var normalStr = ""
        if let base64Decoded = Data(base64Encoded: str, options: Data.Base64DecodingOptions(rawValue: 0))
            .map({ String(data: $0, encoding: .utf8) }) {
            // Convert back to a string
            print("Decoded: \(base64Decoded ?? "")")
            normalStr = "\(base64Decoded!)"
        }
        return normalStr
    }
    
    func encodeToBase64(str:String) -> String{
        let utf8str = str.data(using: .utf8)
        var base64String = ""
        if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
            print("Encoded: \(base64Encoded)")
            base64String = "\(base64Encoded)"
            
        }else{
            
        }
        return base64String
    }
    
    
    @IBAction func btnCompleteSignUpAction(_ sender: Any) {
        
       
        callSignUpApi()
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
            }}
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(defaultAction)
        alertController.addAction(profileAction)
        alertController.addAction(cancelAction)
        alertController.modalPresentationStyle = .popover
            self.present(alertController, animated: true, completion: nil)
        }

    @IBAction func uploadPhotosAction(_ sender: Any) {
        
        
  self.pickImage()
        
        
    }
    @IBAction func Skipclicked(_ sender: Any) {
        
        
   
        callSignUpApi()
        
    }
    
    @IBAction func btnCompleteAction(_ sender: Any) {
        if imageArray.count < 1{
            showAlertWithMessage("ALERT", "Please upload at least 1 Photo")
            return
        }
        setUpUploadedUrl()
        
    
    
    }}
extension PhotosViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count == 0{
            return 1
        }else{
            return imageArray.count + 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as? PhotosCollectionViewCell
        if imageArray.count > 0{
            if indexPath.row ==  imageArray.count
            {
                 let   image = UIImage(named: "addIcon")
                cell?.profileImageViewCell.image = image
                cell?.deleteimge.isHidden = true
                
            }
            else  {
                 cell?.deleteimge.isHidden =  false
                
                cell?.profileImageViewCell.image = imageArray[indexPath.row]
                
                cell?.deleteimge.addTarget(self, action: #selector(deleteimage), for: .touchUpInside)
                 cell?.deleteimge.tag  = indexPath.row
            }
           }
        else {
            let   image = UIImage(named: "addIcon")
            cell?.deleteimge.isHidden = true
            
           cell?.profileImageViewCell.image = image
        }
        cell?.deleteimge.addTarget(self, action: #selector(deleteimage), for: .touchUpInside)
         cell?.deleteimge.tag  = indexPath.row
        cell?.layoutIfNeeded()
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      pickImage()
      
    }
      
    
    
    
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (photosCollectionView.frame.width - 15)/3, height: 120)
    }
    
    
    @objc  func deleteimage(sender:UIButton)
    {
        
       let alert = UIAlertController(title: "Delete Picture!", message: "Do you want to delete photo?",
        preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            
            self.dismiss(animated: true, completion: nil)
            
          }))
            
                        
     alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
       
        
          
        if  sender.tag == 0
        {
            
           let  index = 0
             print(index)
            self.imageArray.remove(at: index)
        }
        else {
            let  index =  sender.tag
            self.imageArray.remove(at: index)
             print(index)
        }
        
      
       self.photosCollectionView.reloadData()
     
       }))
        
       self.present(alert, animated: true, completion: nil)
        
       
        
    }
    
    
    
}
//MARK: - CropViewControllerDelegate
extension PhotosViewController: CropViewControllerDelegate,UINavigationControllerDelegate {
    
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
        let indexPath = IndexPath(row: 0, section: 0)
        
        
        self.image = image
        
        self.photosCollectionView.reloadData()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if cropViewController.croppingStyle != .circular {
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                   toView: photosCollectionView,
                                                   toFrame: CGRect.zero,
                                                   setup: {  },
                                                   completion: nil)
            
            uploadFile(withImage: image)
            
            self.imageArray.append(image)
            self.photosCollectionView.reloadData()
            
        }
        else {
            // self.profileImage.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
}

//MARK: - UIIMagePickerDelegate
extension PhotosViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        self.image = image
        
       
     
        
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

extension PhotosViewController{
    
    func uploadFile(withImage image: UIImage) {
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.APSouth1,
                                                                identityPoolId:"ap-south-1:db9ddd50-a5ee-4dfc-b0a3-5af599d735d9")
        
      let configuration = AWSServiceConfiguration(region:.APSouth1, credentialsProvider:credentialsProvider)
        
      AWSServiceManager.default().defaultServiceConfiguration = configuration
   
       let compressedImage = image.resizedImage(newSize: CGSize(width: 80, height: 80))
       let data: Data = compressedImage.pngData()!
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
extension UIImage {

  func resizedImage(newSize: CGSize) -> UIImage {
    guard self.size != newSize else { return self }

    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
   }

 }

extension Data {

  var format: String {
    let array = [UInt8](self)
    let ext: String
    switch (array[0]) {
    case 0xFF:
        ext = "jpg"
    case 0x89:
        ext = "png"
    case 0x47:
        ext = "gif"
    case 0x49, 0x4D :
        ext = "tiff"
    default:
        ext = "unknown"
    }
    return ext
   }

}
extension PhotosViewController{
    
    
    func callSignUpApi(){
        
      
       
let param = ["app_type": AppType,
                     "email":email,
                     "usage_data":[
                     "MEDIA_DATA":photosData
                        ]
        ] as [String : Any]
       
        
        WebServiceHandler.performPOSTRequest(urlString: kSignUp5URL, params: param ) { (result, error) in
            if (result != nil){
                DispatchQueue.main.async() {
               
             }
              
                let statusCode = result!["status"]?.string
                
                let msg = result!["msg"]?.string
                
                if statusCode == "200"
                {
                    let user_id = result!["user_id"]?.string
                    
                    UserDetails.sharedInstance.userID =  user_id!
                    
                    AppHelper.saveUserDetails()
                  
            
                    
                    let tabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpMatrixViewController") as! SignUpMatrixViewController
                    self.navigationController?.pushViewController(tabbarVC, animated: true)
                    
                 
                    if let reponse = result!["response"]?.array{
                        print(reponse)
                        
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

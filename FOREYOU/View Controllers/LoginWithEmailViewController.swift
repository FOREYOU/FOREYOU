//
//  LoginWithEmailViewController.swift
//  Vella
//
//  Created by Vikas Kushwaha on 26/10/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit

class LoginWithEmailViewController: BaseViewControllerClass {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    static var viewControllerId = "LoginWithEmailViewController"
    static var storyBoard = "Main"
    
    var countryCode = ""
    var iconClick = true

    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.text = ""
        txtFieldPassword.text = ""
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
      
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        if (txtEmail.text!.isEmpty) == true {
            showAlertWithMessage("ALERT", "Please Enter Email")
            return
        }else if (txtFieldPassword.text!.isEmpty) == true {
            showAlertWithMessage("ALERT", "Please Enter Password")
            return
        }else{
            view.endEditing(true)
            callLoginApi()
        }
        
    }
    
    
    @IBAction func btnForgotPasswordAction(_ sender: Any) {
        let controller = (self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController)!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnShowPasswordAction(_ sender: Any) {
       
        txtFieldPassword.isSecureTextEntry.toggle()
    }
    
}

extension LoginWithEmailViewController{
    
 
    func callLoginApi(){
     
   
        let param = ["app_type": AppType,
                     "email": txtEmail.text!,
                     "mobile": "",
                     "country_code": "",
                     "password": txtFieldPassword.text!,
                     "device_type":"ios",
                     "device_token":UserDetails.sharedInstance.pushnotificationtoken
                    ] as [String : Any]
        print(kLoginURL)
        WebServiceHandler.performPOSTRequest(urlString: kLoginURL, params: param ) { (result, error) in
            DispatchQueue.main.async() {
           
         }
            if (result != nil){
                let statusCode = result!["status"]?.string
                let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                    print(result)
                    let user_id = result!["user_id"]?.string
                   
                    
                    UserDetails.sharedInstance.user_interested_for =  result!["user_interested_for"]?.stringValue ?? ""
                    
                     
                    
                    let Picarr = result!["user_profile_image"]?.arrayValue
                    let  profiledict =  Picarr?.first?.dictionaryValue
                        
                        let user_profile_pic =   profiledict?["url"]?.stringValue
                    
                        
                       
                        UserDetails.sharedInstance.user_profile_pic = user_profile_pic ?? ""
                    
                    let infoStatus = result!["info_status"]?.int
                    
                    let account_status = result!["account_status"]?.int
                    UserDetails.sharedInstance.info_status = infoStatus!
                    let user_email = result!["user_email"]?.string
                    UserDetails.sharedInstance.userID = user_id!
                    UserDetails.sharedInstance.user_email = user_email ?? ""
                 
                    
                    AppHelper.saveUserDetails()

                    if infoStatus == 1
                    {
                        let controller = GenderViewController.instantiateFromStoryBoard()
                        controller.email =  user_email ?? ""
                        self.push(controller)
                    }
                    else if infoStatus == 2
                    {
                        let controller = ConnectViewController.instantiateFromStoryBoard()
                        controller.email =  user_email ?? ""
                        self.push(controller)
                    }
                    else if infoStatus == 3
                    {
                        

                        let controller = SignUpSocialsViewController.instantiateFromStoryBoard()
                        controller.email =  user_email ?? ""
                        self.push(controller)
                    }
                    else if infoStatus == 4
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "HangTabbarController") as! HangTabbarController
                        self.navigationController?.pushViewController(tabbarVC, animated: true)
                       // let controller = PhotosViewController.instantiateFromStoryBoard()
                       // controller.email = user_email ?? ""
                       // self.push(controller)
                    }
                    else if infoStatus == 5
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "HangTabbarController") as! HangTabbarController
                        self.navigationController?.pushViewController(tabbarVC, animated: true)
                    }
                    
                  
                  
                    
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

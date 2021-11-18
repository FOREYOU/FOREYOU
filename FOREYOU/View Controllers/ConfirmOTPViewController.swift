//
//  ConfirmOTPViewController.swift
//  Vella
//
//  Created by Vikas Kushwaha on 26/10/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit

class ConfirmOTPViewController: BaseViewControllerClass, UITextFieldDelegate {
    
    @IBOutlet weak var txtFieldOTP: UITextField!
    @IBOutlet weak var btnVerifyNumber: UIButton!
    static var viewControllerId = "ConfirmOTPViewController"
    static var storyBoard = "Main"
    
    var countryCode = ""
    var mobile = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        txtFieldOTP.delegate = self
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
      
    }
    

    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        // This is used to back the Action.
    }
    
    @IBAction func btnVerifyNumberAction(_ sender: Any) {
        if (txtFieldOTP.text!.isEmpty) == true {
            showAlertWithMessage("ALERT", "Please Enter OTP")
            return
        }else{
            view.endEditing(true)
            callVerifyOTPApi()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
        if newLength <= 4 {
            return true
        } else {
            return false
        }
    }
    
}
extension ConfirmOTPViewController{
    
 
    func callVerifyOTPApi(){
        
        let param = ["app_type": AppType,
                     "mobile": mobile,
                     "country_code": countryCode,
                     "otp": txtFieldOTP.text!
                    ] as [String : Any]
        
        WebServiceHandler.performPOSTRequest(urlString: kVerifyOTPURL, params: param ) { (result, error) in
            DispatchQueue.main.async() {
            
         }
            if (result != nil){
                let statusCode = result!["status"]?.string
                let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                    
                    let user_id = result!["user_id"]?.string
                    UserDetails.sharedInstance.user_interested_for =  result!["user_interested_for"]?.stringValue ?? ""
                  
                    let Picarr = result!["user_profile_image"]?.arrayValue
                    let  profiledict =  Picarr?.first?.dictionaryValue
                        
                        let user_profile_pic =   profiledict?["url"]?.stringValue
                    
                        
                       
                    UserDetails.sharedInstance.user_profile_pic = user_profile_pic ?? ""
                        
                    let infoStatus = result!["info_status"]?.int
                    print(infoStatus)
                    
                    let account_status = result!["account_status"]?.int
                  
                    let user_email = result!["user_email"]?.string
                    AppHelper.saveUserDetails()
                    UserDetails.sharedInstance.userID = user_id ?? "00"
                    UserDefaults.standard.setValue(account_status, forKey: "account_status")
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
                        UserDetails.sharedInstance.userID = user_id!
                         UserDetails.sharedInstance.user_profile_pic = user_profile_pic ?? ""
                          AppHelper.saveUserDetails()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "HangTabbarController") as! HangTabbarController
                        self.navigationController?.pushViewController(tabbarVC, animated: true)
                    }
                     else if infoStatus == 5
                     {
                        UserDetails.sharedInstance.userID = user_id!
                         UserDetails.sharedInstance.user_profile_pic = user_profile_pic ?? ""
                          AppHelper.saveUserDetails()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "HangTabbarController") as! HangTabbarController
                        self.navigationController?.pushViewController(tabbarVC, animated: true)
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

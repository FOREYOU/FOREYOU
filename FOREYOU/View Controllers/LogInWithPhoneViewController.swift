//
//  LogInWithPhoneViewController.swift
//  Vella
//
//  Created by Vikas Kushwaha on 26/10/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
import CountryPickerView

class LogInWithPhoneViewController: BaseViewControllerClass,UITextFieldDelegate{
    
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var btnSendOtp: UIButton!
    var countryCode = "+1"
    @IBOutlet weak var selectCountryView: CountryPickerView!
    
    static var viewControllerId = "LogInWithPhoneViewController"
    static var storyBoard = "Main"

    @IBOutlet weak var passwordTf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtMobileNumber.delegate = self
        
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
       // btnSendOtp.cornerRadius = Double(btnSendOtp.frame.height/2)
        selectCountryView.delegate = self
        selectCountryView.dataSource = self

        
    }
    func callLoginApi(){
        
        let param = ["app_type": AppType,
                     "email": "",
                     "mobile": txtMobileNumber.text!,
                     "country_code": countryCode,
                      "password": "",
                     "device_type":"ios",
                     "device_token": UserDetails.sharedInstance.pushnotificationtoken
                    ] as [String : Any]
        print(kLoginURL)
        WebServiceHandler.performPOSTRequest(urlString: kLoginURL, params: param ) { (result, error) in
            DispatchQueue.main.async() {
           
         }
            if (result != nil){
                let statusCode = result!["status"]?.intValue
                let msg = result!["msg"]?.string
                if statusCode ==  200
                {
                    let alert = UIAlertController(title: "Login", message: msg,
                    preferredStyle: UIAlertController.Style.alert)
                                    
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                   
                    let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOTPViewController") as! ConfirmOTPViewController
                  vc.mobile = self.txtMobileNumber.text!
                    vc.countryCode = self.countryCode
                    self.navigationController?.pushViewController(vc, animated: true)
                
                    }))
                    
                   self.present(alert, animated: true, completion: nil)
                    
                    print(result)
                    
                   
                }
                else{
                    
                   
                    
                }
               
            }
            else{
               
            }
        }
        
    }

    @IBAction func btnSendOTPAction(_ sender: Any) {
        
        if (txtMobileNumber.text!.isEmpty) == true {
            showAlertWithMessage("ALERT", "Please Enter Mobile Number")
            return 
        }
        else{
            view.endEditing(true)
            callLoginApi()
        }

    }
    @IBAction func btnShowPasswordAction(_ sender: Any) {
       
        passwordTf.isSecureTextEntry.toggle()
    }
    @IBAction func btnBackAction(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
       }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
        if newLength <= 10 {
            return true
        } else {
            return false
        }
    }

}
extension LogInWithPhoneViewController{
    
}
extension LogInWithPhoneViewController: CountryPickerViewDelegate,CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        countryCode = "\(country.phoneCode)"
        
    }
}

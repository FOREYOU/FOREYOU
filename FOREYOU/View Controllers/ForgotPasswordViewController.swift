//
//  ForgotPasswordViewController.swift
//  Hang
//
//  Created by Vikas Kushwaha on 03/11/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    @IBOutlet weak var btnResetPassword: UIButton!
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
        // Do any additional setup after loading the view.
    }
    
    func callChangePasswordApi()
    {
       
         
            let param = ["app_type": AppType,
                         
                         "email": txtFieldEmail.text ?? ""
                ] as [String : Any]
            
            WebServiceHandler.performPOSTRequest(urlString: kforgotpasswordURL, params: param ) { (result, error) in
                DispatchQueue.main.async() {
               
             }
                if (result != nil){
                    let statusCode = result!["status"]?.string
                    let msg = result!["msg"]?.string
                    if statusCode == "200"
                    {
                       
                        self.showAlertWithMessage("Alert", msg!)
                        
                        self.navigationController?.popViewController(animated: true)
                        
                        self.txtFieldEmail.text = ""
                    

                        }
                    else {
                        self.showAlertWithMessage("Alert", msg ?? "")
                       
                    }
                    }
                
                 else
                {
                    self.showAlertWithMessage("Alert", "")
                    
                }
            }
    }

    
    @IBAction func bckBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnResetPasswordAction(_ sender: Any) {
        if txtFieldEmail.text == ""  ||  txtFieldEmail.text == nil
        {
            self.showAlertWithMessage("Alert", "Please enter registerd email id")
             return
        }
        callChangePasswordApi()
    }
    

}

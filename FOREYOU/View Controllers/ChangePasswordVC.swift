//
//  EnterPasswordVC.swift
//  FOREYOU
//
//  Created by Apple on 09/04/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewControllerClass
{
    static var viewControllerId: String = "ChangePasswordVC"
    static var storyBoard: String = "Main"
    @IBOutlet weak var confirmNewPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var oldPasswordTF: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    @IBAction func resetBtn(_ sender: Any)
    {
        if oldPasswordTF.text == ""  ||  oldPasswordTF.text == nil
        {
            self.showAlertWithMessage("Alert", "Please enter oldpassword")
             return
        }
      else   if newPasswordTF.text == ""  ||  newPasswordTF.text == nil
        {
            self.showAlertWithMessage("Alert", "Please enter newpassword")
             return
        }
      else   if confirmNewPasswordTF.text == ""  ||  confirmNewPasswordTF.text == nil
        {
            self.showAlertWithMessage("Alert", "Please enter confirmpassword")
             return
        }
       else  if oldPasswordTF.text == ""  ||  oldPasswordTF.text == nil
        {
            self.showAlertWithMessage("Alert", "Please enter registerd email id")
             return
        }
         
        if(newPasswordTF.text == confirmNewPasswordTF.text)
        {
        callChangePasswordApi()
        }
        else
        {
            self.showAlertWithMessage("Alert", "Password don't match")
        }
    }
    func callChangePasswordApi()
    {
           
            let param = ["app_type": AppType,
                         "user_id":UserDetails.sharedInstance.userID,
                         "old_password": oldPasswordTF.text ?? "",
                         "new_password": newPasswordTF.text ?? ""
                ] as [String : Any]
            
            WebServiceHandler.performPOSTRequest(urlString: kchangePaswordProfileURL, params: param ) { (result, error) in
                
                if (result != nil){
                    let statusCode = result!["status"]?.string
                    let msg = result!["msg"]?.string
                    if statusCode == "200"
                    {
                       
                        self.showAlertWithMessage("Alert", msg!)
                        
                            
                        self.oldPasswordTF.text = ""
                        self.newPasswordTF.text = ""
                        self.confirmNewPasswordTF.text = ""

                       

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
    
    
    
}

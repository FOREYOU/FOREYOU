//
//  ConnectViewController.swift
//  FOREYOU
//
//  Created by Vikas Kushwaha on 18/12/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit

class ConnectViewController: BaseViewControllerClass {

    static var viewControllerId = "ConnectViewController"
    static var storyBoard = "Main"
    
    var countryCode = "+1"
    var email = ""
    var mobile = ""
    var RelationStatus = ""
    var password = ""
    var gender = ""
    var lookingFor = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
        setInitials()
        
    }
    func signupApiStep3()
    {
       
        let param = ["app_type": AppType,
                     "email": email
                    ] as [String : Any]
        
        WebServiceHandler.performPOSTRequest(urlString: kSignUp3URL, params: param ) { (result, error) in
            DispatchQueue.main.async() {
            
         }
            if (result != nil){
                let statusCode = result!["status"]?.string
                let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                    let controller = SignUpSocialsViewController.instantiateFromStoryBoard()
                    controller.countryCode = self.countryCode
                    controller.email = self.email
                    controller.password = self.password
                    controller.mobile = self.mobile
                    controller.RelationStatus = self.RelationStatus
                    controller.gender = self.gender
                    controller.lookingFor = self.lookingFor
                    self.push(controller)
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
    
    func setInitials(){
       
    }
    
    @IBAction func btnLetsGoAction(_ sender: Any) {
       signupApiStep3()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   

}

//
//  TermsAndConditionViewController.swift
//  Hang
//
//  Created by Vikas Kushwaha on 29/10/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
class TermsAndConditionViewController: BaseViewControllerClass,WKNavigationDelegate {
 @IBOutlet weak   var webView : WKWebView!

    @IBOutlet weak var navTitle: UILabel!
    
    static var viewControllerId = "TermsAndConditionViewController"
    static var storyBoard = "Main"
    var selectcontroller:Bool?
    var btnTag = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
        if btnTag == 2{
            navTitle.text = "Privacy Policy"
        }else{
            navTitle.text = "Terms and Conditions"
        }
        self.callSignUpApi()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBackAction(_ sender: Any) {
        
         if selectcontroller == true
         {
            self.navigationController?.popViewController(animated: true)
            
         }
         else {
            self.dismiss(animated: true, completion: nil)

         }
    }
    func webView( webView: WKWebView, _didFailProvisionalNavigation navigation: WKNavigation!, _withError error: NSError) {
         print(error.localizedDescription)
         }

         func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
           
         print("Strat to load")
             }

         func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
         }
        
    
    func callSignUpApi(){
        
      
       
      
        
        let param = ["app_type": AppType,
                     "user_id":UserDetails.sharedInstance.userID]
                    
                    as [String : Any]
        
        
        WebServiceHandler.performPOSTRequest(urlString: Ksupportsurl, params: param ) { (result, error) in
            DispatchQueue.main.async {
            AppHelper.sharedInstance.removeSpinner()
            }
            if (result != nil){
                
                let statusCode = result!["status"]?.string
                
                let msg = result!["msg"]?.string
                
                if statusCode == "200"
                {
                    DispatchQueue.main.async {
                     
                   
                        
                        let terms_condition =     result?["terms_condition"]?.stringValue
                        let privacy_policy =     result?["privacy_policy"]?.stringValue
                   
                      
                        if self.btnTag == 1
                        {
                        let url = NSURL(string: terms_condition ?? "")
                          let request = NSURLRequest(url: url! as URL)
                            self.webView.navigationDelegate = self
                            self.webView.load(request as URLRequest)
                        }
                        else {
                            let url = NSURL(string: privacy_policy ?? "")
                              let request = NSURLRequest(url: url! as URL)
                            self.webView.navigationDelegate = self
                            self.webView.load(request as URLRequest)
                        }
                         
                     
                     
                     
                     
                                                         
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

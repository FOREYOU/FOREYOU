//
//  PrivacyPolicyVC.swift
//  FOREYOU
//
//  Created by Dj on 16/03/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import WebKit
class PrivacyPolicyVC: UIViewController , WKNavigationDelegate {
  @IBOutlet weak  var webView : WKWebView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        if #available(iOS 13.0, *) {
                         
        overrideUserInterfaceStyle = .light

        }
        else {
                         // Fallback on earlier versions
            }
          self.navigationController?.navigationBar.isHidden = false
          let customButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped)) //
              self.navigationItem.leftBarButtonItem  = customButton
              self.title = "Privacy Policy"
        
let url = NSURL(string: "https://www.digi-neo.com/privacypolicy.php")
        let request = NSURLRequest(url: url! as URL)
        
        
       
        self.webView.navigationDelegate = self
        self.webView.load(request as URLRequest)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.isNavigationBarHidden = true

        self.navigationController?.popViewController(animated: true)
    
    }
    func webView( webView: WKWebView, _didFailProvisionalNavigation navigation: WKNavigation!, _withError error: NSError) {
           print(error.localizedDescription)
           }


           func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
           print("Strat to load")
               }

           func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
          

             
           }
    

}

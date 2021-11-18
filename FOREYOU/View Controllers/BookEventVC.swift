//
//  BookEventVC.swift
//  FOREYOU
//
//  Created by Mac MIni on 19/08/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import WebKit
class BookEventVC: UIViewController, WKNavigationDelegate {
    @IBOutlet weak  var webView : WKWebView!
    var eventUrl:String?
    var indicator = UIActivityIndicatorView()
 override func viewDidLoad() {
        super.viewDidLoad()
    activityIndicator()
    indicator.startAnimating()
    indicator.backgroundColor = .white
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
                                 self.title = "Book"
    let eventurl =  eventUrl?.replacingOccurrences(of: "//", with: "/", options: .literal, range: nil)
                
    let url = NSURL(string:eventurl ?? "")
                           let request = NSURLRequest(url: url! as URL)
                           
                           
                          
                           self.webView.navigationDelegate = self
                           self.webView.load(request as URLRequest)
                           
                     

                           // Do any additional setup after loading the view.
                       }
                       
                       @objc func backButtonTapped() {
                           self.navigationController?.isNavigationBarHidden = true

                           self.navigationController?.popViewController(animated: true)
                       
                       }
                       func webView( webView: WKWebView, _didFailProvisionalNavigation navigation: WKNavigation!, _withError error: NSError) {    self.indicator.stopAnimating()
                           self.indicator.hidesWhenStopped = true
                              print(error.localizedDescription)
                              }


                              func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
                              print("Strat to load")
                                  }

                              func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                         
                                self.indicator.stopAnimating()
                                self.indicator.hidesWhenStopped = true
                                
                              }

    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
}

//
//  InstraViewController.swift
//  Hang
//
//  Created by Vikas Kushwaha on 09/11/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
import WebKit

class InstraViewController: UIViewController {
 
    @IBOutlet weak var webView :UIWebView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE])
        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
        webView.delegate = self
        webView.loadRequest(urlRequest)
    }
 
    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }
 
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    func handleAuth(authToken: String) {
        INSTAGRAM_IDS.INSTAGRAM_ACCESS_TOKEN = authToken
        print("Instagram authentication token ==", authToken)
        getUserInfo(){(data) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
           
        }
    }
    func getUserInfo(completion: @escaping ((_ data: Bool) -> Void)){
        let url = String(format: "%@%@", arguments: [INSTAGRAM_IDS.INSTAGRAM_USER_INFO,INSTAGRAM_IDS.INSTAGRAM_ACCESS_TOKEN])
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard error == nil else {
                 completion(false)
                //failure
                return
            }
            // make sure we got data
            guard let responseData = data else {
                completion(false)
                 //Error: did not receive data
                return
            }
            do {
                guard let dataResponse = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: AnyObject] else {
                        completion(false)
                        //Error: did not receive data
                        return
                }
                completion(true)
                // success (dataResponse) dataResponse: contains the Instagram data
            } catch let err {
                completion(false)
                //failure
            }
        })
        task.resume()
    }
}
 
extension InstraViewController: UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
}
extension InstraViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if checkRequestForCallbackURL(request: navigationAction.request){
            decisionHandler(.allow)
        }else{
            decisionHandler(.cancel)
        }
    }
}

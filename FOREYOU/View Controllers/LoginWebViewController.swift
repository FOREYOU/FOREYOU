//
//  LoginWebViewController.swift
//  Hang
//
//  Created by Vikas Kushwaha on 03/11/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
protocol LoginWebViewControllerDelegate {
    func refreshData()
}

class LoginWebViewController: BaseViewControllerClass,WKNavigationDelegate {

    @IBOutlet weak var loginIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loginWebView: WKWebView!
    
    var instagramApi: InstagramApi?
    
    var testUserData: InstagramTestUser?
    
    var isBack = false
    
    static var viewControllerId = "LoginWebViewController"
    static var storyBoard = "Main"
    var delegate:LoginWebViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
        loginWebView.navigationDelegate = self
       // unSignedRequest()
        
        /*
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
        let cookieStore = loginWebView.configuration.websiteDataStore.httpCookieStore
        

        cookieStore.getAllCookies {
            cookies in

            for cookie in cookies {
                cookieStore.delete(cookie)
            }
        }
       */
        instagramApi?.authorizeApp { (url) in
            DispatchQueue.main.async {
                self.loginWebView.load(URLRequest(url: url!))
            }
        
    }

    func unSignedRequest () {
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&DEBUG=True", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE ])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        let googleRequest = URLRequest(url: URL(string: "https://www.google.com")!)
        loginWebView.load(urlRequest)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loginIndicatorView.isHidden = true
        loginIndicatorView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loginIndicatorView.isHidden = false
        loginIndicatorView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if checkRequestForCallbackURL(request: navigationAction.request){
            decisionHandler(.allow)
        }else{
            decisionHandler(.cancel)
        }
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
            var requestURl = requestURLString.replacingOccurrences(of: "#_", with: "")
            let range: Range<String.Index> = requestURl.range(of: "code=")!
            handleAuth(authToken: requestURl.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    
   
    
    func handleAuth(authToken: String) {
        INSTAGRAM_IDS.INSTAGRAM_ACCESS_TOKEN = authToken
        print("Instagram authentication token ==", authToken)
        /*
        getUserInfo(){(data) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
           
        }
        */
        
        getTokenFromCode(){(data) in
         //  self.getUserInfo()
           
        }
       
    }
    
    func getTokenFromCode(completion: @escaping ((_ data: Bool) -> Void)){
      var semaphore = DispatchSemaphore (value: 0)

      let parameters = [
        [
          "key": "client_id",
          "value": "643121156356735",
          "type": "text"
        ],
        [
          "key": "client_secret",
          "value": "a7c0f5af20167ceb21eedb30a633996a",
          "type": "text"
        ],
        [
          "key": "grant_type",
          "value": "authorization_code",
          "type": "text"
        ],
        [
          "key": "redirect_uri",
          "value": "https://www.digi-neo.com/",
          "type": "text"
        ],
        [
          "key": "code",
          "value": INSTAGRAM_IDS.INSTAGRAM_ACCESS_TOKEN,
          "type": "text"
        ]] as [[String : Any]]

      let boundary = "Boundary-\(UUID().uuidString)"
      var body = ""
      var error: Error? = nil
      for param in parameters {
        if param["disabled"] == nil {
          let paramName = param["key"]!
          body += "--\(boundary)\r\n"
          body += "Content-Disposition:form-data; name=\"\(paramName)\""
          let paramType = param["type"] as! String
          if paramType == "text" {
            let paramValue = param["value"] as! String
            body += "\r\n\r\n\(paramValue)\r\n"
          } else {
            let paramSrc = param["src"] as! String
            do{
            let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
            let fileContent = String(data: fileData, encoding: .utf8)!
                         body += "; filename=\"\(paramSrc)\"\r\n"
                           + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }catch{
                
            }
         
          }
        }
      }
      body += "--\(boundary)--\r\n";
      let postData = body.data(using: .utf8)

      var request = URLRequest(url: URL(string: "https://api.instagram.com/oauth/access_token")!,timeoutInterval: Double.infinity)
      request.addValue("ig_did=83914213-4A24-4651-B89F-68C8516F0241; mid=X6JmMwAEAAFkayA15Lualn1n7iMR; ig_nrcb=1; csrftoken=cWBBoOSWpFzYUGi8MT7hvrKhNGj78m1L", forHTTPHeaderField: "Cookie")
      request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

      request.httpMethod = "POST"
      request.httpBody = postData

      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
          print(String(describing: error))
          return
        }
        print(String(data: data, encoding: .utf8)!)
        guard error == nil else {
            completion(false)
            //failure
            return
        }
        // make sure we got data
        print(data)
     
        do {
            guard let dataResponse = try JSONSerialization.jsonObject(with: data, options: [])
                as? [String: AnyObject] else {
                    completion(false)
                    //Error: did not receive data
                    return
            }
            
            // success (dataResponse) dataResponse: contains the Instagram data
            INSTAGRAM_IDS.INSTAGRAM_ACCESS_TOKEN = dataResponse["access_token"] as! String
            INSTAGRAM_IDS.INSTAGRAM_USERID = String(dataResponse["user_id"] as! Int)
            
            
            completion(true)
        
            print(dataResponse)
        } catch let err {
            completion(false)
            //failure
        }
        semaphore.signal()
      }

      task.resume()
      semaphore.wait()

       }
    
    
    func getUserData(){
        var semaphore = DispatchSemaphore (value: 0)
        let url =  "https://graph.instagram.com/\(INSTAGRAM_IDS.INSTAGRAM_USERID)?fields=username&access_token=\(INSTAGRAM_IDS.INSTAGRAM_ACCESS_TOKEN)"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue("ig_did=83914213-4A24-4651-B89F-68C8516F0241; mid=X6JmMwAEAAFkayA15Lualn1n7iMR; ig_nrcb=1; csrftoken=cWBBoOSWpFzYUGi8MT7hvrKhNGj78m1L", forHTTPHeaderField: "Cookie")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    
    
    func getUserInfo(){
        var headers = [
            "Content-Type":"application/json"
            //"":""
        ]
        WebServiceHandler.performGETRequest(withURL:  "https://graph.instagram.com/\(INSTAGRAM_IDS.INSTAGRAM_USERID)?fields=username&access_token=\(INSTAGRAM_IDS.INSTAGRAM_ACCESS_TOKEN)", header: headers ) {(result,error) in
            if result == nil{return}
            let data = ["data":JSON(result!)]
            if (result != nil){
                print(result!)
                self.isBack = true
                UserDetails.sharedInstance.instagramLoginID = result!["id"].string!
                AppHelper.saveUserDetails()
                if self.isBack {
                    DispatchQueue.main.async {
                        self.delegate?.refreshData()
                        self.dismiss(animated: true, completion: nil)
                    }
                    self.isBack = false
                    return
                }
                
            }
            else{
                
                
            }
        }
        
        
    }
    
    
    /*
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
            print(data)
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
                print(dataResponse)
            } catch let err {
                completion(false)
                //failure
            }
        })
        task.resume()
    }
    */

}
}

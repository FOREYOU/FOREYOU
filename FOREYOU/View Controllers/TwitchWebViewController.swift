//
//  ViewController.swift


import UIKit
import WebKit
import SwiftyJSON
protocol TwitchWebViewControllerDelegate {
    func gotToken(token:String)
}
class TwitchWebViewController: UIViewController, WKNavigationDelegate  {
    @IBOutlet var webView: WKWebView!
    let client_id = "y47rvrma2t6pp1t7hglw55dtosjqlw"
    
    var access_code = ""
    var access_Token = ""
    
    var delegate:TwitchWebViewControllerDelegate?
    let authorizationEndPoint = "https://id.twitch.tv/oauth2/authorize?"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startAuthorization()
        
        // Do any additional setup after loading the view.
    }
    
    func startAuthorization() {
        
        let CompleteUrl  =  "https://www.reddit.com/api/v1/authorize.compact?client_id=pb0vcyLn-aEvdw&response_type=code&state=c3ab8aa609ea11e793ae92361f002671&redirect_uri=https://www.digi-neo.com&scope=identity,read,subscribe,mysubreddits"
        
        let url = URL(string: CompleteUrl)
        let request = URLRequest(url: url!)
        webView.navigationDelegate = self
        webView.load(request)
    }
    
    // delegatemethod
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        
        print(webView.url)
        
        let url =   webView.url
        
        if  url?.host == "www.digi-neo.com" {
            
            self.webView.isHidden = true
            
            if url?.absoluteString.range(of: "code") != nil {
                
                let urlParts = url?.absoluteString.components(separatedBy: "&")
                
                var access_token = urlParts?[1].components(separatedBy: "=")[1]
                
                var code = access_token?.replacingOccurrences(of: "#_", with: "")
                print(code)
                self.access_code = code!
                getAccessToken()
                self.dismissViewController()
                // Fetch Access Token:- Using
            }
            
        }
        
    }
    
    func getAccessToken(){
        
        let uri = "https://www.digi-neo.com"
        var client_id = "pb0vcyLn-aEvdw"
        
        var request = URLRequest(url: URL(string: "https://www.reddit.com/api/v1/access_token?grant_type=authorization_code&code=\(access_code)&redirect_uri=\(uri)&client_id=\(client_id)")!,timeoutInterval: Double.infinity)
        request.addValue("Basic cGIwdmN5TG4tYUV2ZHc6RE1ZLUZlM1ZYSkIyYmUyS3A2S0NfOHdTaEtVbktB", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            let jsonData = JSON(data)
            let token = jsonData["access_token"].stringValue
            self.access_Token = token
            print(String(data: data, encoding: .utf8)!)
            self.dismissViewController()
         
        }
        
        task.resume()

        
    }
    
    func dismissViewController() {
        
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.delegate!.gotToken(token:self.access_Token)
            }
        }
    }
    //
    
    let url  = "https://id.twitch.tv/oauth2/validate"
    // get user id
    //  var request = URLRequest(url: URL(string: "https://id.twitch.tv/oauth2/validate")!,timeoutInterval: Double.infinity)
    ///  request.addValue(" OAuth fbzke69kzf1jun1biooyh6bwhaxt6", forHTTPHeaderField: "Authorization")
    
    
    // user info
    let url2   = "https://api.twitch.tv/kraken/users/656269496"
    
    ///ar request = URLRequest(url: URL(string:
    /// "https://api.twitch.tv/kraken/users/656269496")!,timeoutInterval: Double.infinity)
    // request.addValue("y47rvrma2t6pp1t7hglw55dtosjqlw", forHTTPHeaderField: "Client-ID")
    // request.addValue("application/vnd.twitchtv.v5+json", forHTTPHeaderField: "Accept")
    //  request.addValue("Bearer xntckx51ro0hdc3l8boew5ok4qsk8i", forHTTPHeaderField: "Authorization")
    
    // request.httpMethod = "GET"
}


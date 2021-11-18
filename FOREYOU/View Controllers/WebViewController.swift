
import UIKit
import WebKit
import SwiftyJSON
protocol WebViewControllerDelegate
{
    func refreshData(data:InstagramTestUser,instaData:InstaData)
    
    func getTwitchData(twitchArray:[TwitchData],token:String)
}
class WebViewController: UIViewController, WKNavigationDelegate  {
    @IBOutlet var webView: WKWebView!
    let client_id = "y47rvrma2t6pp1t7hglw55dtosjqlw"
    var delegate : WebViewControllerDelegate?
    var TwitchDataList = [TwitchData]()
    var access_Token = ""
    let authorizationEndPoint = "https://id.twitch.tv/oauth2/authorize?"
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.startAuthorization()
        
        // Do any additional setup after loading the view.
    }
    
    func startAuthorization() {
        
        let CompleteUrl  =  "https://id.twitch.tv/oauth2/authorize?response_type=token&client_id=y47rvrma2t6pp1t7hglw55dtosjqlw&redirect_uri=https://www.digi-neo.com&scope=user:edit%20user:read:email%20user_blocks_read"
        
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
            
            if url?.absoluteString.range(of: "/#") != nil {
                
                let urlParts = url?.absoluteString.components(separatedBy: "access_token")
                
                let access_token = urlParts?[1].components(separatedBy: "=")
                print(access_token)
                let aToken =  access_token?[1].components(separatedBy: "&")[0]
                print("$$",aToken)
                access_Token = aToken!
                getUserId(accessToken : aToken!)
            }
            
        }
        
    }
    
    func dismissViewController() {
        
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.delegate?.getTwitchData(twitchArray: self.TwitchDataList, token: self.access_Token)
            }
        }
    }
    func getUserId(accessToken : String)
    {
        var headers = [
            "Content-Type":"application/json",
            "Authorization": "OAuth \(accessToken)"
            //"":""
        ]
        WebServiceHandler.performGETRequest(withURL:  "https://id.twitch.tv/oauth2/validate", header: headers) {(result,error) in
            
            if result == nil{return}
            let data = ["data": JSON(result!)]
            if (result != nil)
            {
                print(result!)
                let user_id = result!["user_id"].string
                self.getUserInfo(accessToken: accessToken, userId: user_id!)
                
            }
        }
        //
        
        //let url  = "https://id.twitch.tv/oauth2/validate"
        // get user id
        //  var request = URLRequest(url: URL(string: "https://id.twitch.tv/oauth2/validate")!,timeoutInterval: Double.infinity)
        
        // user info
        // let url2   = "https://api.twitch.tv/kraken/users/656269496"
        
        ///ar request = URLRequest(url: URL(string:
        /// "https://api.twitch.tv/kraken/users/656269496")!,timeoutInterval: Double.infinity)
        
    }
  
    func getUserInfo(accessToken: String,userId: String)
    {
        var headers = [
            "Accept":"application/vnd.twitchtv.v5+json",
            "Authorization": "OAuth \(accessToken)",
            "Client-ID":"y47rvrma2t6pp1t7hglw55dtosjqlw"
            //"":""
        ]
        WebServiceHandler.performGETRequest(withURL:  "https://api.twitch.tv/kraken/users/\(userId)", header: headers) {(result,error) in
            
            if result == nil{return}
            let data = ["data": JSON(result!)]
            
            if (result != nil)
            {
                
                
                let responseJson = JSON(result!)
                print(result!)
                let displayName = responseJson["display_name"].stringValue
                let Id = responseJson["_id"].stringValue
                let name = responseJson["name"].stringValue
                let type = responseJson["type"].stringValue
                let bio = responseJson["bio"].stringValue
                let logo = responseJson["logo"].stringValue
                
                let data = TwitchData(dict: ["id":Id])
                data.bio = bio
                data.name = name
                data.userId = Id
                data.logo = logo
                self.TwitchDataList.append(data)
                self.dismissViewController()
            }
        }
    }
    
    
}

//
//  AppHelper.swift
//  Hang
//
//  Created by Vikas Kushwaha on 03/11/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit

class AppHelper: NSObject {
    
    var spinnerView: UIView?
    static let sharedInstance = AppHelper()
    
    
    
    class func btnEnabled(btn:UIButton) {
        btn.backgroundColor = UIColor.black
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.isEnabled = true
        
    }
    
    class func btnDisabled(btn:UIButton) {
        btn.backgroundColor = UIColor.lightGray
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.isEnabled = false
        
    }
    
    func displaySpinner(/*loaderMessage: String*/) {
        if (spinnerView != nil) {
            removeSpinner()
        }
        
        spinnerView = UIView.init(frame: UIScreen.main.bounds)
        spinnerView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.7)
        //   spinnerView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = (spinnerView?.center)!
        ai.color = UIColor.white
      //  let label = UILabel(frame: CGRect(x: 20, y: ai.center.y + 20, width: UIScreen.main.bounds.width - 40, height: 40))
      //  label.textAlignment = .center
      //  label.text = loaderMessage
        //        label.text = "Processing payment... please wait."
      //  label.textColor = UIColor(red: 45/255, green: 150/255, blue: 134/255, alpha: 1)
      //  label.font = UIFont(name: "MuseoSansCyrl-700", size: 15)
      //  spinnerView?.addSubview(label)
        DispatchQueue.main.async {
            self.spinnerView?.addSubview(ai)
            APPDELEGATE.window?.addSubview(self.spinnerView!)
        }
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.spinnerView?.removeFromSuperview()
        }
    }
    
    
    class func makeLoginViewControllerAsRootViewController() {
         
         let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
         let startVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
         let navigationVC = UINavigationController(rootViewController: startVC)
         navigationVC.navigationBar.isHidden = true
         APPDELEGATE.window?.rootViewController = navigationVC
         
     }
    
    class func setHorizontalGradientColor(views: UIView) {
        let gradientLayer = CAGradientLayer()
        var updatedFrame = views.bounds
   
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = [Colors.ORANGE_COLOR.cgColor, Colors.PINK_COLOR.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.9, y: 0.5)
        views.layer.insertSublayer(gradientLayer, at: 0)
    }
    

    
    class func getUserDetails(){
        let userdefaults = UserDefaults.standard
        
        if let user_id = userdefaults.value(forKey: "user_id"){
            UserDetails.sharedInstance.userID  = user_id as! String
        }
        if let user_interested_for = userdefaults.value(forKey: "user_interested_for")
        {
            UserDetails.sharedInstance.user_interested_for = user_interested_for as! String
        }
        if let pushnotificationtoken = userdefaults.value(forKey: "pushnotificationtoken")
        {
            UserDetails.sharedInstance.pushnotificationtoken = pushnotificationtoken as! String
        }
        if let user_profile_pic = userdefaults.value(forKey: "user_profile_pic")
        {
            UserDetails.sharedInstance.user_profile_pic = user_profile_pic as! String
        }
        
        
        if let user_location = userdefaults.value(forKey: "user_location"){
            UserDetails.sharedInstance.user_location = user_location as! String
        }
        
        
        if let appleLoginID = userdefaults.value(forKey: "appleLoginID"){
            UserDetails.sharedInstance.appleLoginID = appleLoginID as! String
        }
        
        if let googleLoginID = userdefaults.value(forKey: "googleLoginID"){
            UserDetails.sharedInstance.googleLoginID = googleLoginID as! String
        }
        
        if let spotifyLoginID = userdefaults.value(forKey: "spotifyLoginID"){
            UserDetails.sharedInstance.googleLoginID = spotifyLoginID as! String
        }
        
        if let facebookLoginID = userdefaults.value(forKey: "facebookLoginID"){
            UserDetails.sharedInstance.facebookLoginID = facebookLoginID as! String
        }
        
        if let instagramLoginID = userdefaults.value(forKey: "instagramLoginID"){
            UserDetails.sharedInstance.instagramLoginID = instagramLoginID as! String
        }
        
        if let linkedinLoginID = userdefaults.value(forKey: "linkedinLoginID"){
            UserDetails.sharedInstance.linkedinLoginID = linkedinLoginID as! String
        }
        
        if let twitterLoginID = userdefaults.value(forKey: "twitterLoginID"){
            UserDetails.sharedInstance.twitterLoginID = twitterLoginID as! String
        }
        
        if let pinterestLoginID = userdefaults.value(forKey: "pinterestLoginID"){
            UserDetails.sharedInstance.pinterestLoginID = pinterestLoginID as! String
        }
        if let message_group_id = userdefaults.value(forKey: "message_group_id"){
            UserDetails.sharedInstance.message_group_id = message_group_id as! Int
        }
        if let partner_name = userdefaults.value(forKey: "partner_name"){
            UserDetails.sharedInstance.partner_name = partner_name as! String
        }
        if let partner_id = userdefaults.value(forKey: "partner_id"){
            UserDetails.sharedInstance.partner_id = partner_id as! String
        }
        
    }
    
    class func convertDateStringToFormattedDateTimeString(dateE: String) -> String
    {
        var dateString = ""
        var timeString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: dateE){
            dateFormatter.dateFormat = "d MMM "
            dateString = dateFormatter.string(from: date)
        }
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        if let time = timeFormatter.date(from: dateE){
            timeFormatter.dateFormat = "h:mm a"
            timeString = timeFormatter.string(from: time)
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM "
        let result = formatter.string(from: date)
        if dateString == result
        {
            return "Today \(timeString)"
        }
        else
        {
        return "\(dateString) \(timeString)"
        }
        
    }

    class func convertDateStringToFormattedDateString(dateE: String) -> String
    {
        var dateString = ""
        var timeString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateE){
            dateFormatter.dateFormat = "E, MMM d"
            dateString = dateFormatter.string(from: date)
        }
       
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        let result = formatter.string(from: date)
        if dateString == result
        {
            return "Today \(timeString)"
        }
        else
        {
        return "\(dateString) \(timeString)"
        }
        
    }
    
    class func saveUserDetails(){
        /*
        if EmpDetails.sharedInstance.empID.count > 0{
            UserDefaults.standard.set(EmpDetails.sharedInstance.empID, forKey: "empID")
        }
        */
        
        UserDefaults.standard.set(UserDetails.sharedInstance.userID, forKey: "user_id")
        UserDefaults.standard.set(UserDetails.sharedInstance.pushnotificationtoken, forKey: "pushnotificationtoken")
        UserDefaults.standard.set(UserDetails.sharedInstance.user_interested_for, forKey: "user_interested_for")
        UserDefaults.standard.set(UserDetails.sharedInstance.info_status, forKey: "info_status")
        UserDefaults.standard.set(UserDetails.sharedInstance.user_profile_pic, forKey: "user_profile_pic")
        UserDefaults.standard.set(UserDetails.sharedInstance.spotifyLoginID, forKey: "appleLoginID")
        UserDefaults.standard.set(UserDetails.sharedInstance.spotifyLoginID, forKey: "spotifyLoginID")
        UserDefaults.standard.set(UserDetails.sharedInstance.googleLoginID, forKey: "googleLoginID")
        UserDefaults.standard.set(UserDetails.sharedInstance.facebookLoginID, forKey: "facebookLoginID")
        UserDefaults.standard.set(UserDetails.sharedInstance.instagramLoginID, forKey: "instagramLoginID")
        UserDefaults.standard.set(UserDetails.sharedInstance.linkedinLoginID, forKey: "linkedinLoginID")
        UserDefaults.standard.set(UserDetails.sharedInstance.twitterLoginID, forKey: "twitterLoginID")
        UserDefaults.standard.set(UserDetails.sharedInstance.pinterestLoginID, forKey: "pinterestLoginID")
        UserDefaults.standard.set(UserDetails.sharedInstance.user_email, forKey: "user_email")
        UserDefaults.standard.set(UserDetails.sharedInstance.partner_id, forKey: "partner_id")
        UserDefaults.standard.set(UserDetails.sharedInstance.partner_name, forKey: "partner_name")
        UserDefaults.standard.set(UserDetails.sharedInstance.partner_email, forKey: "partner_email")
        UserDefaults.standard.set(UserDetails.sharedInstance.message_group_id, forKey: "message_group_id")


       }

}
struct INSTAGRAM_IDS {
    
    static var INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    
    
    static var INSTAGEAM_ACCESSURL = "https://api.instagram.com/oauth/access_token"
    
    static var INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
    
    static var INSTAGRAM_CLIENT_ID  = "643121156356735"
    static var GRANT_TYPE = "authorization_code"
    
    static var INSTAGRAM_CLIENTSERCRET = "a7c0f5af20167ceb21eedb30a633996a"
    
    static var INSTAGRAM_REDIRECT_URI = "https://www.digi-neo.com/"
    static var INSTAGRAM_USERID = ""
    
    static var INSTAGRAM_ACCESS_TOKEN =  "IGQVJWTkM0U2RmcXdnd0xOSXlLaW5MNXc0NFVRTFRPb08yZAXIxaHlqY3lXN25reTJZANDBQWXNqSEtvQUtZAUWdhR25nZAjNBUXgweXozNmVmUXpacGg0enk2cS1jLTNKZA3JxUXVqeG1R"
    
    static let INSTAGRAM_SCOPE = "instagram_graph_user_profile,instagram_graph_user_media"
    
    static let INSTAGRAM_USER_INFO = "https://api.instagram.com/v1/users/self/?access_token="
    
    // App Id:- 643121156356735
   // a7c0f5af20167ceb21eedb30a633996a
    
}
struct SpotifyConstants {
    
    static let CLIENT_ID = "2e469b15503a47cf8f416e5dc5ef5fd3"
    static let SESSION_KEY = "767fab1d9d1442a4b9103906569de768"
    static let REDIRECT_URI = "https://www.digi-neo.com/"
    static let SCOPE = "user-read-email,playlist-modify-public,playlist-modify-private,user-follow-modify,user-follow-read,playlist-modify-private,playlist-read-private,playlist-read-collaborative,user-read-private,user-read-recently-played,user-top-read"
}

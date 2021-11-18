//
//  AppDelegate.swift
//  Hang
//
//  Created by Vikas Kushwaha on 26/10/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//





import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKCoreKit
import AWSS3
import AWSCognito
import SCSDKLoginKit
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import SwiftyJSON
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var selecttap:Bool?
    var userdict:[String : JSON]?
    var removemsg:Bool?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppHelper.getUserDetails()
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = "452669675710-o4kh4n83252mlbs7f0vasu7ui0fqqvnp.apps.googleusercontent.com"
       ///GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/youtube")

        self.setupPushNotification(application: application, launchOptions: launchOptions)
        
        if  UserDetails.sharedInstance.userID == "" {
            
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbarVC = storyboard.instantiateViewController(withIdentifier: "HangTabbarController") as! HangTabbarController
            
             window = UIWindow(frame: UIScreen.main.bounds)
         
         let aObjNavi = UINavigationController(rootViewController: tabbarVC)
         
            
            aObjNavi.navigationBar.isHidden = true
            window?.rootViewController = aObjNavi
            window?.backgroundColor = UIColor.white
            
            window?.makeKeyAndVisible()
 
            
        }
     
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        self.initializeS3()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        //let twitterDidHandle = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        let snapHandle = SCSDKLoginClient.application(app, open: url, options: options)
        return snapHandle
        
    }
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if (extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard) {
            return false
        }
        return true
    }
    
    
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var handle: Bool = true
        
        
        let options: [String: AnyObject] = [UIApplication.OpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject, UIApplication.OpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
        
      return  true
    }
    
    
    //Make sure it isn't already declared in the app delegate (possible redefinition of func error)
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }
    
    func initializeS3() {
       
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.APSouth1,
        identityPoolId:"ap-south-1:db9ddd50-a5ee-4dfc-b0a3-5af599d735d9")
        
        
        //us-east-2:642346fd-82de-4e86-b50f-fc8e72f8bc81
        
        let configuration = AWSServiceConfiguration(region:.APSouth1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
      
    }
    
 }

extension AppDelegate {
    
    func setupPushNotification(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        //Push
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.tokenRefreshNotification),
            name: Notification.Name.MessagingRegistrationTokenRefreshed,
            object: nil)
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            //FirebaseApp.configure()
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        ///if UserDefaults.standard.object(forKey: "Notification") == nil{
            application.registerForRemoteNotifications()
         //   UserDefaults.standard.set(true, forKey: "Notification")
          //  UserDefaults.standard.synchronize()
      ///  }
        


    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var tokenq = ""
        for i in 0..<deviceToken.count {
            tokenq = tokenq + String(format: "%02.2hhx", arguments: [deviceToken[i]])
            
          }
           
        Messaging.messaging().apnsToken = deviceToken as Data
        if Messaging.messaging().fcmToken != nil{
        
        }
        
       InstanceID.instanceID().instanceID { (result, error) in
           if let error = error {
               print("Error fetching remote instance ID: \(error)")
           }
           else if let result = result {
               
            print("Remote instance ID token: \(result.token)")
            
          UserDetails.sharedInstance.pushnotificationtoken = "\(result.token)"
         
          AppHelper.saveUserDetails()
               
            
           }
       }
    }
    
    
    ///Topic
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
        connectToFcm()
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                debugPrint("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                UserDetails.sharedInstance.pushnotificationtoken = "\(result.token)"
               
                AppHelper.saveUserDetails()
                debugPrint("Remote instance ID token: \(result.token)")
            }
            
           
        }
        
        connectToFcm()
    }
    
    func connectToFcm() {
        // Disconnect previous FCM connection if it exists.
       ///Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        debugPrint(userInfo)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil, userInfo: nil)
        
        }
    
   }
    

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    

// tap clicked
    func userNotificationCenter(_ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let data = userInfo["message"] as? [AnyHashable:Any]
       {
        print(data)
        }
        
    
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil, userInfo: userInfo)
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping(UIBackgroundFetchResult) -> Void) {
        
      
          NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        completionHandler(UIBackgroundFetchResult.newData)
            
     }

    }

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
      connectToFcm()
        
    }
    
   
}

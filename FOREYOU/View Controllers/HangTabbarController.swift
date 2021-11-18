//
//  HangTabbarController.swift
//  Hang
//
//  Created by Vikas Kushwaha on 29/10/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit

class HangTabbarController: UITabBarController, UITabBarControllerDelegate  {
    var Profileurl :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
        
        if UserDetails.sharedInstance.user_profile_pic != ""{
            
            
            let imageUrl = UserDetails.sharedInstance.user_profile_pic
            
            
            
              DispatchQueue.global(qos: .background).async {
                       do
                        {
                             let data = try Data.init(contentsOf: URL.init(string: imageUrl)!)
                              DispatchQueue.main.async {
                                let image: UIImage = UIImage(data: data)!
                                
                                let barImage: UIImage = image.squareMyImage().resizeMyImage(newWidth: 40).roundMyImage.withRenderingMode(.alwaysOriginal)

                                self.tabBar.items?[3].image = barImage
                          

                              }
                        }
                       catch {
                              // error
                             }
                }
                
            
             }
         else  {
            
            let barImage: UIImage = UIImage(named: "user_place")!.squareMyImage().resizeMyImage(newWidth: 40).roundMyImage.withRenderingMode(.alwaysOriginal)

            self.tabBar.items?[3].image = barImage


        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("Updateimage"), object: nil)
       
        
        self.delegate = self

        
        // Do any additional setup after loading the view.
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        let barImage: UIImage = UIImage(named: "user_place")!.squareMyImage().resizeMyImage(newWidth: 40).roundMyImage.withRenderingMode(.alwaysOriginal)

        self.tabBar.items?[3].image = barImage

       
    }
    /// called whenever a tab button is tapped
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            
            
            APPDELEGATE.selecttap = false

        }
    

}

extension UIImage{

    var roundMyImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    func resizeMyImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))

        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    func squareMyImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: self.size.width, height: self.size.width))

        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.width))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

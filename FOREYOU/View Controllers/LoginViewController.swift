//
//  LoginViewController.swift
//  Vella
//
//  Created by Vikas Kushwaha on 26/10/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewControllerClass {
    
    @IBOutlet weak var btnTermsConditions: UIButton!
    @IBOutlet weak var craouselCollectionView: UICollectionView!
    
    @IBOutlet weak var btnLoginWithPhoneNumber: UIButton!
    @IBOutlet weak var btnLoginWithEmail: UIButton!
    @IBOutlet weak var btnback: UIButton!

    
    @IBOutlet weak var btnPrivacyPolicy: UIView!
    static var viewControllerId = "LoginViewController"
    static var storyBoard = "Main"
    var status:Bool?
    var timer = Timer()
    var counter = 0
    
    var imgArr = [  UIImage(named:"slide1"),
                    UIImage(named:"slide2") ,
                    UIImage(named:"slide3")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
        if self.status == true
        {
           
            self.btnback.isHidden = true
        }
        else {
            self.btnback.isHidden = false
            
            
        }
        setInitials()
    }
    
    func setInitials(){
        
       
        
     self.navigationController?.navigationBar.isHidden = true
       
    }
    
    
   @IBAction func btnLoginWithPhoneAction(_ sender: Any) {
        let controller = LogInWithPhoneViewController.instantiateFromStoryBoard()
        push(controller)
    }
    
    @IBAction func btnLoginWithEmailAction(_ sender: Any) {
        let controller = LoginWithEmailViewController.instantiateFromStoryBoard()
        push(controller)
    }
    
    @IBAction func btnSignupAction(_ sender: Any) {
      //  let controller = SignUpViewController.instantiateFromStoryBoard()
      //  push(controller)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTermsConditionsAction(_ sender: Any) {
        let controller = TermsAndConditionViewController.instantiateFromStoryBoard()
        controller.btnTag = 1
        controller.selectcontroller = true
        push(controller)
    }
    
    @IBAction func btnPrivacyPolicyAction(_ sender: Any) {
        let controller = TermsAndConditionViewController.instantiateFromStoryBoard()
        controller.btnTag = 2
        controller.selectcontroller = true

        push(controller)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension LoginViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
           if let vc = cell.viewWithTag(111) as? UIImageView {
               vc.image = imgArr[indexPath.row]
           }
        cell.layoutIfNeeded()
           return cell
       }
}


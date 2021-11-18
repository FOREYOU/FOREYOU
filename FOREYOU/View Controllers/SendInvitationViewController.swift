//
//  SendInvitationViewController.swift
//  Hang
//
//  Created by Vikas Kushwaha on 05/11/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit

class SendInvitationViewController: BaseViewControllerClass {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var btnSend: UIButton!
    var expobjct:ExprienceModel?
    static var viewControllerId = "SendInvitationViewController"
    static var storyBoard = "Main"

    override func viewDidLoad() {
        super.viewDidLoad()
            
            if #available(iOS 13.0, *) {
                      
                     overrideUserInterfaceStyle = .light

                  } else {
                      // Fallback on earlier versions
                  }
            
        btnSend.cornerRadius = Double(btnSend.frame.height/2)
        textContainerView.cornerRadius = 15
        profileImageView.cornerRadius = Double(profileImageView.frame.height/2)

        // Do any additional setup after loading the view.
    }
    

  
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

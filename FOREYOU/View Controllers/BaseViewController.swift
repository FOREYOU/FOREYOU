//
//  BaseViewController.swift
//  
//
//  Created by Suraj on 6/15/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

protocol Instantiable{
    static var viewControllerId:String{get}
    static var storyBoard:String{get}
    static func instantiateFromStoryBoard()->Self
}

extension Instantiable{
    static func instantiateFromStoryBoard()->Self{
        let storyboard = UIStoryboard(name: Self.storyBoard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Self.viewControllerId)
        return controller as! Self
    }
}

typealias BaseViewControllerClass = BaseViewController & Instantiable

class BaseViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        
    }
    
    func push(_ controller:UIViewController){
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //    MARK:- Show Alert With Message
    func showAlertWithMessage(_ title : String, _ message : String) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction.init(title: ConstantStrings.OK_STRING, style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
}

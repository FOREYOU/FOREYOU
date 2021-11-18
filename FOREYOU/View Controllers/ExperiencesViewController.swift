//
//  ExperiencesViewController.swift
//  Hang
//
//  Created by Vikas Kushwaha on 29/10/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import TTTAttributedLabel
class ExperiencesViewController: BaseViewControllerClass,  TTTAttributedLabelDelegate {
    
    
    private lazy var productcategory: VirtualVC = {
     
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "VirtualVC") as! VirtualVC

  
        self.add(asChildViewController: viewController)
        
        return viewController
    }()

    private lazy var ServiceViewController:  RealVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "RealVC") as! RealVC

           viewController.view.frame = containerView.bounds
             
             ///containerView.addSubview(viewController.view)
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()
    
    @IBOutlet weak var containerView :UIView!

    @IBOutlet weak var imgViewwidthConstraint: NSLayoutConstraint!

    static var viewControllerId = "ExperiencesViewController"
    static var storyBoard = "Main"
    @IBOutlet weak var Virtulview: UIView!
    @IBOutlet weak var  Realview: UIView!
    @IBOutlet weak var  backbtn: UIButton!

    var selecttab:Bool = false
    var userid:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
     
        
        guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "VirtualVC") as? VirtualVC else {
                    return
                  }
           addChild(childVC)
                //Or, you could add auto layout constraint instead of relying on AutoResizing contraints
            childVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
           childVC.view.frame = containerView.bounds
                       
            containerView.addSubview(childVC.view)
            childVC.didMove(toParent: self)
          imgViewwidthConstraint.constant = -7
          Virtulview.layer.borderWidth = 1
          Virtulview.layer.borderColor = Colors.ORANGE_COLOR.cgColor
     
       
     
        }
    
    
    private func add(asChildViewController viewController: UIViewController) {
           // Add Child View Controller
           addChild(viewController)

           // Add Child View as Subview
           containerView.addSubview(viewController.view)

           // Configure Child View
           viewController.view.frame = containerView.bounds
           viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

           // Notify Child View Controller
           viewController.didMove(toParent: self)
       }
       

       private func remove(asChildViewController viewController: UIViewController) {
           // Notify Child View Controller
           viewController.willMove(toParent: nil)

           // Remove Child View From Superview
         

         // Remove Child View From Superview
         viewController.view.removeFromSuperview()

         // Notify Child View Controller
           
           // Notify Child View Controller
           viewController.removeFromParent()
        
        
     
       }
    
    override func viewWillAppear(_ animated: Bool) {
        if selecttab ==  true
        {
            self.backbtn.isHidden = false
        }
        else {
            self.backbtn.isHidden = true
        }
    }
    @IBAction func backaction(sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func selecttap(sender:UIButton)
    {
        if  sender.tag == 11
        {
            remove(asChildViewController: ServiceViewController)
         
             imgViewwidthConstraint.constant = 7
            Virtulview.layer.borderWidth = 1
            Virtulview.layer.borderColor = Colors.ORANGE_COLOR.cgColor
            Realview.layer.borderWidth = 1
            Realview.layer.borderColor = UIColor.clear.cgColor
        
           }
        else {
            
            remove(asChildViewController: productcategory)
            add(asChildViewController: ServiceViewController)
            imgViewwidthConstraint.constant = 7
            Virtulview.layer.borderWidth = 1
            Virtulview.layer.borderColor  =  UIColor.clear.cgColor
           
            Realview.layer.borderWidth = 1
            Realview.layer.borderColor = Colors.ORANGE_COLOR.cgColor

        
           
         
        }
    }
    
    }



extension String {
        var htmlToAttributedString: NSAttributedString? {
            guard let data = data(using: .utf8) else { return nil }
            do {
                return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            } catch {
                return nil
            }
        }
        var htmlToString: String {
            return htmlToAttributedString?.string ?? ""
        }
    }


extension String {
   func maxLength(length: Int) -> String {
       var str = self
       let nsString = str as NSString
       if nsString.length >= length {
           str = nsString.substring(with:
               NSRange(
                location: 0,
                length: nsString.length > length ? length : nsString.length)
           )
       }
       return  str
   }
}

extension TTTAttributedLabel {
     func showTextOnTTTAttributeLable(str: String, readMoreText: String, readLessText: String, font: UIFont?, charatersBeforeReadMore: Int, activeLinkColor: UIColor, isReadMoreTapped: Bool, isReadLessTapped: Bool) {

       let text = str + readLessText
       let attributedFullText = NSMutableAttributedString.init(string: text)
       let rangeLess = NSString(string: text).range(of: readLessText, options: String.CompareOptions.caseInsensitive)
//Swift 5
      // attributedFullText.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], range: rangeLess)
       attributedFullText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], range: rangeLess)

       var subStringWithReadMore = ""
       if text.count > charatersBeforeReadMore {
         let start = String.Index(encodedOffset: 0)
         let end = String.Index(encodedOffset: charatersBeforeReadMore)
         subStringWithReadMore = String(text[start..<end]) + readMoreText
       }

       let attributedLessText = NSMutableAttributedString.init(string: subStringWithReadMore)
       let nsRange = NSString(string: subStringWithReadMore).range(of: readMoreText, options: String.CompareOptions.caseInsensitive)
       //Swift 5
      // attributedLessText.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], range: nsRange)
       attributedLessText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], range: nsRange)
     //  if let _ = font {// set font to attributes
     //   self.font = font
     //  }
       self.attributedText = attributedLessText
       self.activeLinkAttributes = [NSAttributedString.Key.foregroundColor : UIColor.blue]
       //Swift 5
      // self.linkAttributes = [NSAttributedStringKey.foregroundColor : UIColor.blue]
       self.linkAttributes = [NSAttributedString.Key.foregroundColor : UIColor.blue]
       self.addLink(toTransitInformation: ["ReadMore":"1"], with: nsRange)

       if isReadMoreTapped {
         self.numberOfLines = 0
         self.attributedText = attributedFullText
         self.addLink(toTransitInformation: ["ReadLess": "1"], with: rangeLess)
       }
       if isReadLessTapped {
         self.numberOfLines = 3
         self.attributedText = attributedLessText
       }
     }
   }


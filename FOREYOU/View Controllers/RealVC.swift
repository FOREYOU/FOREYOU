//
//  RealVC.swift
//  FOREYOU
//
//  Created by Mac MIni on 25/08/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import TTTAttributedLabel
class RealVC: BaseViewControllerClass ,TTTAttributedLabelDelegate {
    var page: Int = 1
    var offset:Int = 10
    var totalpage:Int?
    var isPageRefreshing:Bool = false
    
    var RealList = [ExprienceModel]()
  
   @IBOutlet weak var Exptable: UITableView!
    
  
static var viewControllerId = "ExperiencesViewController"
    static var storyBoard = "Main"
   
    var change_week: Int  = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    

    if #available(iOS 13.0, *) {
              
             overrideUserInterfaceStyle = .light

          } else {
              // Fallback on earlier versions
          }
 
   
    self.ExpApi(exptype: "REAL", page: page, perpage: offset)
    // Do any additional setup after loading the view.
}
    
    @IBAction func selecttap(sender:UIButton)
    {
        isPageRefreshing = false
        
       if sender.isSelected ==  true
        {
            change_week = 0
            sender.isSelected = false
        }
        else {
            change_week = 1
            sender.isSelected = true
        }
        page = 1
        offset = 10
        self.RealList  = []
        self.ExpApi(exptype: "REAL", page: page, perpage: offset)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

            print("scrollViewWillBeginDragging")
            isPageRefreshing = false
        }



        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            print("scrollViewDidEndDecelerating")
        }
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    change_week = 0
    if(self.Exptable.contentOffset.y >= (self.Exptable.contentSize.height - self.Exptable.bounds.size.height)) {
        if self.page <= self.totalpage! - 1   {
        if !isPageRefreshing {
                 isPageRefreshing = true
                 offset =  10
                 page = page + 1
                self.ExpApi(exptype: "REAL", page: page, perpage: offset)
        }
           }
    }
    }
    @objc func yesClicked(_ sender: UIButton) {
        isPageRefreshing = false
        
       if sender.isSelected ==  true
        {
            change_week = 0
            sender.isSelected = false
        }
        else {
            change_week = 1
            sender.isSelected = true
        }
        page = 1
        offset = 10
        self.RealList  = []
        self.ExpApi(exptype: "REAL", page: page, perpage: offset)
    }
}

extension RealVC:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
          
    return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          if section == 0
          {
              return 1
          }
          else {
            
            return  RealList.count
          }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell =  Exptable.dequeueReusableCell(withIdentifier: "MesssagExpCell") as! MesssagExpCell
            cell.yesbtn?.addTarget(self, action: #selector(yesClicked), for: .touchUpInside)
       
            cell.yesbtn?.tag  = indexPath.row
            cell.selectionStyle =  .none
             return cell
            
        }
        else {
        let cell =  Exptable.dequeueReusableCell(withIdentifier: "cell") as! ExperienceCell
        
       cell.exname?.text = RealList[indexPath.row].event_name
        
        cell.exptitle?.text =   RealList[indexPath.row].venue_name! 
        cell.expdate?.text =  RealList[indexPath.row].event_date
       cell.exptime?.text =  RealList[indexPath.row].event_time
        let  desc   =        RealList[indexPath.row].event_desc
        
        cell.expdesc?.text   =  (desc?.htmlToString.maxLength(length: 200))!
         
       // if (desc?.htmlToString.count)! > 200
       // {
         ///   cell.expdesc?.text = desc?.htmlToString
           // cell.expdesc?.showTextOnTTTAttributeLable(str: desc?.htmlToString ?? "", readMoreText: " ReadMore", readLessText: "ReadLess", font: UIFont.init(name: "Helvetica-Bold", size: 24.0)!, charatersBeforeReadMore: 200, activeLinkColor: UIColor.blue, isReadMoreTapped: false, isReadLessTapped: false)
        
       // }
       // else {
          //  cell.expdesc?.text = desc?.htmlToString
        
        //}
      
        cell.expdesc?.delegate = self
      
        
   let profilpic =  RealList[indexPath.row].event_image?.replacingOccurrences(of: "//", with: "/", options: .literal, range: nil)
       
       cell.expimg?.sd_setShowActivityIndicatorView(true)
        cell.expimg?.sd_setIndicatorStyle(.gray)

    cell.expimg?.sd_setImage(with: URL(string:profilpic ?? ""), placeholderImage: UIImage(named: "event_img"))
        
        
        cell.Bookeventbtn?.addTarget(self, action: #selector(Bookeventclicked), for: .touchUpInside)
        cell.Bookeventbtn?.tag  = indexPath.row
        cell.shareBtn?.addTarget(self, action: #selector(shareclicked), for: .touchUpInside)
        cell.shareBtn?.tag  = indexPath.row
        cell.selectionStyle =  .none
        
        return cell
        }
    }
    
func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat  {
   
    
    if indexPath.section == 0
    {
      
        return  180.0
    
    }
    else {
    let  desc   =    RealList[indexPath.row].event_desc

   if  desc == ""
    {
        return  460.0
    }
    else {
        
        if (desc?.htmlToString.count)! > 100
        {
            return  540.0
        }
        else {
            return  460.0
        }
        
      }
    }
    
    
    }
    func readMore(readMore: Bool) {
        
         
        }
          func readLess(readLess: Bool) {
           
          }
    
    @objc func Bookeventclicked(_ sender: UIButton) {
       
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "BookEventVC") as? BookEventVC
        vc?.eventUrl =   RealList[sender.tag].event_url
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @objc func shareclicked(_ sender: UIButton) {
        
        let object = RealList[sender.tag]
        let controller = InviteExperienceViewController.instantiateFromStoryBoard()
        controller.expobjct =  object
        push(controller)
        
    }

    func  ExpApi(exptype:String, page:Int, perpage:Int)
     {
        
         let param = ["app_type": AppType,
                      "type":  exptype,
                      "user_id":UserDetails.sharedInstance.userID,
                      "page":page,
                      "per_page": perpage, "change_week": change_week
                 ] as [String : Any]
         
         WebServiceHandler.performPOSTRequest(urlString: Expurl, params: param ) { (result, error) in
            DispatchQueue.main.async() {
                
            }
             if (result != nil){
                 let statusCode = result!["status"]?.string
                 let msg = result!["msg"]?.string
                self.totalpage  = result!["last_page"]?.int
                 if statusCode == "200"
                 {
                   
                    
                 if let reponse = result!["experience_list"]?.array{
                    
                    for item in reponse
                     {
                                     
                              let dataDic = item.dictionaryValue
                              let api =  ExprienceModel.init(dict: dataDic)
                                                         
                             self.RealList.append(api)

                         }
                    
                         
                     }
                     
                    
                 
                    if self.RealList.count > 0
                    {
                        
                  
                   self.Exptable.dataSource = self
                    self.Exptable.delegate = self
                     

                   self.Exptable.reloadData()
                    }
                    else
                    {
                        self.Exptable.dataSource = self
                         self.Exptable.delegate = self
                          

                        self.Exptable.reloadData()
                        
                    }
                   
                 }
                 else{
                     self.showAlertWithMessage("ALERT", msg!)
                 }
               
             }
             else{
            
             }
         }
         
     }

    

}


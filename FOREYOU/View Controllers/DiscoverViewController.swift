//
//  DiscoverViewController.swift
//  Hang
//
//  Created by Vikas Kushwaha on 05/11/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Lightbox

class DiscoverViewController: BaseViewControllerClass ,UITableViewDelegate, UITableViewDataSource, DetailCellDelegate{
   
    
   
  
    var messgae_id :Int = 0
   
    var profileimge:String?
    var name:String = ""
    var userdict:[String : JSON]?
    
    var thisWidth:CGFloat = 0
   var matchlist = [MatchData]()

    static var viewControllerId = "DiscoverViewController"
    static var storyBoard = "Main"
 
    var userId = ""
    
    @IBOutlet weak var   profiledetailtbl: UITableView!
    @IBOutlet weak var   yourname: UILabel!
    
    var matrixlist = [matrixModel]()
    var segmnetarr : [Bool] = []

    var arrimagData : [JSON] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
          setInitials()
        profiledetailtbl.rowHeight = UITableView.automaticDimension
        profiledetailtbl.estimatedRowHeight = 75
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.segmnetarr = []
        self.matrixlist =  []
        
        self.callProfileApi()
        }
    
   
   func setInitials(){
        
        
        
        self.profiledetailtbl?.registerCell("detailhrCell")
        self.profiledetailtbl?.registerCell("destilcrCell")
        self.profiledetailtbl?.registerCell("DetailCell")
   
    }
    
    func  numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
    if section == 0
    {
    
         return 1
    }
    else{
      return  self.segmnetarr.count
    }
    
 
   }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section  == 0
        {
            
        
       
     let cell = self.profiledetailtbl?.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailCell
        
        self.arrimagData =  self.userdict?["user_profile_pic"]?.arrayValue ?? []
      
        cell.loadimage(images: self.arrimagData)
        
        
     
        let name =  self.userdict?["user_firstname"]?.stringValue
              
                self.name = name ?? ""
       
      
                cell.lblNamw.text =   name?.capitalized
                
                self.yourname.text = name?.capitalized
                
                 cell.about.text =   "More About" + " " +  self.name
                
                cell.match_percentage.text = self.userdict?["match_percentage"]?.stringValue
                let dis = self.userdict?["user_distance"]?.stringValue
           
              let location   =  self.userdict?["user_location"]?.stringValue
               
            let fulladdress =  location
                let fulladdressArr = fulladdress?.components(separatedBy: ",")
                let firstAddress = fulladdressArr?[0]
                let secondAddress = fulladdressArr?[1]
                
                //First.
                let finaladdress =  firstAddress!  + "," +  secondAddress!
                
              
                 let firstline =  finaladdress.capitalized
                 let secondline   =    dis!
                
                
              cell.lblAdd.text   =  firstline
       
              cell.distance.text =   secondline + " Miles"  + " away"

            
           
                self.messgae_id = self.userdict?["message_group_id"]?.intValue ?? 0
           
           
             
             print((self.userdict?["match_desc"]?.stringValue)!)
            if  Int((self.userdict?["match_percentage"]?.string)!) ?? 0 >=  50
             {
                cell.messagename.text =  "That's a pretty high match! You and "  + self.name.uppercased()  +   " will have a lot to talk"
              
             }
            else
             {
                cell.messagename.text = self.userdict?["match_desc"]?.stringValue
             }
                
          
                
                
        let gender =  self.userdict?["user_gender"]?.stringValue
         if gender == "MALE"
         {
            cell.aboutgender.text =  "Why not send him a message?"
            
         }
         else {
            cell.aboutgender.text =   "Why not send her a message?"
         }
            cell.specailname.text = self.userdict?["user_profession"]?.stringValue
        
        if #available(iOS 13.0, *) {
            cell.meesagebtn?.addTarget(self, action: #selector(messageclicked), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        cell.meesagebtn?.tag  = indexPath.row
            
            if #available(iOS 13.0, *) {
                cell.invitetn?.addTarget(self, action: #selector(InviteToExperienceAction), for: .touchUpInside)
            } else {
                // Fallback on earlier versions
            }
            cell.invitetn?.tag  = indexPath.row


         cell.selectionStyle = .none
          cell.delegate = self
           
            return cell
        }
        else {
            let value   =  self.matrixlist[indexPath.row].value
            
            let name   =  self.matrixlist[indexPath.row].name
             
            if  segmnetarr[indexPath.row] == false
              {
         
                  let cell = profiledetailtbl?.dequeueReusableCell(withIdentifier: "detailhrCell") as? detailhrCell
                 
                
                  if value == "HIGH"
                   {
                    cell?.firstGradientProgress.setProgress(85/100, animated: false)
                   }
                
                  else if value == "LOW"
                {
                    cell?.firstGradientProgress.setProgress(35/100, animated: false)
                }
                else {
                    cell?.firstGradientProgress.setProgress(60/100, animated: false)
                }
             
               
                
                cell?.name.text =  name
                cell?.value.text = value
                    cell?.selectionStyle = .none
                      return cell!
                  }
              
              else {
                 
                  let cell = profiledetailtbl.dequeueReusableCell(withIdentifier: "destilcrCell") as? destilcrCell
               
                  if value == "HIGH"
                {
                    cell?.circularProgressView.angle = 290
                }
                else  if value == "LOW"
                {
                    cell?.circularProgressView.angle =  120
                }
                else  {
                    cell?.circularProgressView.angle = 230
                }
                
                
                cell?.name.text =  name
                cell?.value.text = value
                  cell?.selectionStyle = .none
                  return cell!
              }
            
            }

    }
    
    
    
    
    
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.section == 0
        {
            return 960
        }
        else {
        if  segmnetarr[indexPath.row] == false
              {
                   return 66
              }
              else  {
                   return  140
              }
          
          }
       
    }
    
@objc func submitClicked(_ sender: UIButton) {
  
   // let vc   = self.storyboard?.instantiateViewController(withIdentifier: "OtpVerifyVC") as! OtpVerifyVC
      ///  self.navigationController?.pushViewController(vc, animated: true)
}
    
@objc func backClicked(_ sender: UIButton) {
  
    self.navigationController?.popViewController(animated: true)
}
    
func callProfileApi()
    {
        
   
     
    let param = [
                         
            "user_id": UserDetails.sharedInstance.userID ,
                "app_type": AppType,
                "other_user_id": userId
                
            ] as [String : Any]
            
            WebServiceHandler.performPOSTRequest(urlString: kDetailsURL, params: param ) { (result, error) in
                DispatchQueue.main.async() {
                   
                }
                
                if (result != nil){
                    let statusCode = result!["status"]?.string
                    let msg = result!["msg"]?.string
                    
                    if statusCode == "200"
                    {
                        
                     
                       
                     
                     if msg  == "Data not found."
                     {
                        return
                     }
                         
                        
                        print(result ?? "")
                        
                        let usersDic = result!["user_profile"]?.dictionaryValue
                        
                        let matrxiarr = usersDic?["matrix"]?.arrayValue
                          
                         
                        for ApiJSON in  matrxiarr! {
                          
                           let  c =   matrixModel(json: ApiJSON)
                         
                         self.matrixlist.append(c)
                          
                       }
                        
                        self.matrixlist =  self.matrixlist.filter { $0.status == 0 }
                        
                        
                        var  vertical : Bool = false
                        
                           
                        for i in 0..<self.matrixlist.count   {
                            if (i != 0 && i % 4 == 0) {
                            vertical = !vertical
                            }
                            print(i)
                                self.segmnetarr.append(vertical)
                        }
                         
                        print(self.segmnetarr.count)
                       
                        
                         self.userdict = usersDic
                         
                      
                        self.profiledetailtbl.dataSource = self
                        self.profiledetailtbl.delegate = self
                        self.profiledetailtbl.reloadData()
                        
                        self.arrimagData =  self.userdict?["user_profile_pic"]?.arrayValue ?? []
                        
                        
                        if self.arrimagData.count > 0
                        {
                            let img = self.arrimagData.first?.stringValue
                            
                            self.profileimge = img
                        }
                        else  {
                            
                        }
            
                   

                    }
                    }
                   
                else
                {
                   
                  
                }
             

            }
    }

    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @available(iOS 13.0, *)
    
    @objc  func messageclicked(_ sender: UIButton) {
        
        if #available(iOS 13.0, *) {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC
            controller?.userNme = name
            controller?.userId = self.userId
            
            
            controller?.msgGrpId =  "\(self.messgae_id)"
            controller?.profileImg = self.profileimge ?? ""
            controller?.selecttag = false
           
            self.navigationController?.pushViewController(controller!, animated: true)
        } else {
            // Fallback on earlier versions
        }
      //  controller?.msgGrpId =  self.messgae_id!
        
        }
    @available(iOS 13.0, *)
    
    @objc  func InviteToExperienceAction(_ sender: UIButton) {
        
        if #available(iOS 13.0, *) {
          
            let controller = ExperiencesViewController.instantiateFromStoryBoard()
            controller.selecttab = true
            controller.userid = self.userId
            APPDELEGATE.userdict = self.userdict
            APPDELEGATE.selecttap = true
            
            self.push(controller)
        }

          
         else {
            // Fallback on earlier versions
        }
      //  controller?.msgGrpId =  self.messgae_id!
        
        }
    /*
    @IBAction func InviteToExperienceAction(_ sender: Any) {
        let controller = InviteExperienceViewController.instantiateFromStoryBoard()
        self.push(controller)
    }
 */
   
    // delegate method
    func detaiimage(urlimg: [JSON], Start: Int) {
        
        var images = [LightboxImage]()
         
        for image in urlimg
      {
        
            let img =  image.stringValue
        
       
       let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        images.append(LightboxImage(imageURL: URL(string: urlString!)!))

       }
       
         
    // let completePath   =  url
        
      let controller = LightboxController(images: images, startIndex: Start)  // LightboxController(images: images)
       controller.modalPresentationStyle = .fullScreen
          controller.dynamicBackground = true
            
          present(controller, animated: true, completion: nil)
        
     }
 
}



//
//  SignUpMatrixViewController.swift
//  Hang
//
//  Created by Vikas Kushwaha on 18/11/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts
import AVFoundation
import MediaPlayer
import CoreBluetooth
import SystemConfiguration.CaptiveNetwork
import StoreKit
import SwiftyJSON
import Alamofire

class SignUpMatrixViewController: BaseViewControllerClass,UITableViewDelegate, UITableViewDataSource {
    
    
//MARK: - Variables
    static var viewControllerId = "SignUpMatrixViewController"
    static var storyBoard = "Main"
  
    @IBOutlet weak var profileCollectionView: UICollectionView!
    var getmatrixarr:[JSON] = []
    @IBOutlet weak var tabelview: UITableView!
    var matrixlist = [matrixModel]()
    var segmnetarr : [Bool] = []
    var isExpanded = [Bool]()
    
    var indicator = UIActivityIndicatorView()

override func viewDidLoad() {
        super.viewDidLoad()
        
       
    
        if #available(iOS 13.0, *) {
            
            overrideUserInterfaceStyle = .light
            
        } else {
            // Fallback on earlier versions
        }
        
     
    tabelview.rowHeight = UITableView.automaticDimension
    tabelview.estimatedRowHeight = 75
        setInitials()
   
       
    }
  
override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setInitials(){
        
        tabelview.registerCell("HorizontalCell")
        tabelview.registerCell("CircleCell")
        tabelview.registerCell("MatrixdetailCell")
        tabelview.registerCell("FinishbtnCell")
       
       self.callGetProfileInfoApi()
      
        //  linearProgressBar.progressValue = 30
    }
    @available(iOS 13.0, *)
 func btnCompleteSignUpAction() {
        
        let alert = UIAlertController(title: "Congratulations!", message: "You have joined ForeYou",
        preferredStyle: UIAlertController.Style.alert)
                        
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        
        let jumpVC = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController
      jumpVC?.status = true
    
      self.navigationController!.pushViewController(jumpVC!, animated: true)
        }))
        
       self.present(alert, animated: true, completion: nil)
    }
        
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @available(iOS 13.0, *)
    @objc func detailclicked(_ sender: UIButton) {
        
        self.btnCompleteSignUpAction()
        
    }
    @objc func inviteclicked(_ sender: UISwitch) {
        
    
      self.updatestueApi(index: sender.tag)
    
    }

    func  numberOfSections(in tableView: UITableView) -> Int {
        
    return 3
    }

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
    if section == 0
    {
    
         return 1
    }
    else  if section == 1 {
      return  self.segmnetarr.count
    }
    else {
         return 1
    }
 
   }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        if indexPath.section  == 0
        {
            let cell = tabelview.dequeueReusableCell(withIdentifier: "MatrixdetailCell") as? MatrixdetailCell
             
            cell?.selectionStyle = .none
            
            return cell!
        }
        else if indexPath.section == 1 {
     
            
            let value   =  self.matrixlist[indexPath.row].value
            
            let name   =  self.matrixlist[indexPath.row].name
            
            let desc   =  self.matrixlist[indexPath.row].desc
            
           let  value_desc  =  self.matrixlist[indexPath.row].value_desc
            
            
        if  segmnetarr[indexPath.row] == false
              {
         
                  let cell = tabelview.dequeueReusableCell(withIdentifier: "HorizontalCell") as? HorizontalCell
                 
             
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
               
                
                if matrixlist[indexPath.row].status == 1
                {
                    cell?.status?.isOn = false
                    cell?.tabstatus.text = "Private"
                }
                else {
                    cell?.status?.isOn = true
                    cell?.tabstatus.text = "Public"
                }
                
                
                cell?.name.text =  name
                cell?.value.text = value
                cell?.Descepition.attributedText = desc?.htmlToAttributedString
                  cell?.status?.addTarget(self, action: #selector(inviteclicked), for: .valueChanged)
                 cell?.status?.tag  = indexPath.row
            cell?.Dropdownbnt?.addTarget(self, action: #selector(dropdown), for: .touchUpInside)
            
            cell?.Dropdownbnt.tag = indexPath.row
          
           
            
            if  self.isExpanded[indexPath.row] == true
            {
                let compleltetext =  desc! +  value_desc!
                
                cell?.Descepition.attributedText =  compleltetext.htmlToAttributedString
              cell?.Dropdownbnt.setImage(UIImage (named: "up.png"), for: .normal)
            }
            else {
                cell?.Descepition.attributedText = desc?.htmlToAttributedString
              
                
                 cell?.Dropdownbnt.setImage(UIImage (named: "down.png"), for: .normal)
                
                
         
            }
            cell?.selectionStyle = .none
                
             return cell!
                  }
              
            else {
                 
                  let cell = tabelview.dequeueReusableCell(withIdentifier: "CircleCell") as? CircleCell
                 
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
                
                if matrixlist[indexPath.row].status == 1
                {
                    cell?.status?.isOn = false
                    cell?.tabstatus.text = "Private"
                }
                else {
                    cell?.status?.isOn = true
                    cell?.tabstatus.text = "Public"
                }
                
                cell?.name.text =  name
                cell?.namevalue.text = value
                
                cell?.Descepition.attributedText = desc?.htmlToAttributedString
               
                  cell?.selectionStyle = .none
                cell?.status?.addTarget(self, action: #selector(inviteclicked), for: .valueChanged)
                 cell?.status?.tag  = indexPath.row
                
                
                cell?.Dropdownbnt?.addTarget(self, action: #selector(dropdown), for: .touchUpInside)
                
                cell?.Dropdownbnt.tag = indexPath.row
              
                  
                
                if  self.isExpanded[indexPath.row] == true
                {
                    let compleltetext =  desc! +  value_desc!
                    
                    cell?.Descepition.attributedText =  compleltetext.htmlToAttributedString
                  cell?.Dropdownbnt.setImage(UIImage (named: "up.png"), for: .normal)
                }
                else {
                    cell?.Descepition.attributedText = desc?.htmlToAttributedString
                  
                    
                     cell?.Dropdownbnt.setImage(UIImage (named: "down.png"), for: .normal)
                    
                    
             
                }
                 return cell!
              }
              
        }
        else {
            let cell = tabelview.dequeueReusableCell(withIdentifier: "FinishbtnCell") as? FinishbtnCell
           
            if #available(iOS 13.0, *) {
                cell?.fininsh.addTarget(self, action: #selector(detailclicked), for: .touchUpInside)
            } else {
                // Fallback on earlier versions
            }
           
             cell?.fininsh.tag  = indexPath.row
            cell?.selectionStyle = .none
            return cell!
        }
        }
        
  
   
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    
    if indexPath.section == 0
    {
        return 121.0
    }
    else  if indexPath.section == 1{
  if  segmnetarr[indexPath.row] == false
        {
            return  UITableView.automaticDimension
        }
        else  {
            return  UITableView.automaticDimension
        }
    }
    else {
         return 72
    }
    }
    
    
    @objc  func dropdown(sender: UIButton) {
        
        
       
        if self.isExpanded[sender.tag] == true
       {
            
            self.isExpanded.remove(at: sender.tag)
            self.isExpanded.insert( false, at: sender.tag)
            print(self.isExpanded)
          
        
         
          }
       else {
           self.isExpanded.remove(at: sender.tag)
           
           self.isExpanded.insert( true, at: sender.tag)
          
           print(self.isExpanded)
       }
       
       
            self.tabelview.reloadData()


    }
    func callGetProfileInfoApi(){
       
  


        let param = ["app_type": AppType,
                         "user_id":UserDetails.sharedInstance.userID,
                ] as [String : Any]
            
            WebServiceHandler.performPOSTRequest(urlString: kGetProfileInfo, params: param ) { (result, error) in
         
                DispatchQueue.main.async() {
                
             }
                
                if (result != nil){
                    let statusCode = result!["status"]?.string
                  
                    if statusCode == "200"
                    {
                        
                
                    
                        if let response = result!["user_data"]!.dictionary{
                           
                            
                            let matrxiarr = response["matrix"]?.arrayValue
                            
                            
                            if matrxiarr!.count > 0 {
                           
                            for ApiJSON in  matrxiarr! {
                              
                               let  c =   matrixModel(json: ApiJSON)
                             
                             self.matrixlist.append(c)
                               

                              
                           }
                            
                            var  vertical : Bool = false
                            
                               
                            for i in 0..<matrxiarr!.count   {
                                if (i != 0 && i % 4 == 0) {
                                vertical = !vertical
                                }
                                print(i)
                                    self.segmnetarr.append(vertical)
                                    self.isExpanded.append(false)
                            }
                             
                                
                                   print(self.segmnetarr.count)
                            }
                            
                            
                            self.tabelview.delegate = self
                            self.tabelview.dataSource = self
                            self.tabelview.reloadData()
                            print(response)
                            
                        }
                    }
                    else{
                        
                    }
               
            
                    
                }
                else{
                  
            
                    
                }
            }
            
        }
        
}

extension SignUpMatrixViewController{
    
    func updatestueApi(index:Int){
         
        var status :Int?
      
         if matrixlist[index].status == 1
          {
            status  = 0
            
          }
            else {
                 status = 1
            }
         
        let param = ["app_type": AppType,
                     "user_id":UserDetails.sharedInstance.userID,"type": matrixlist[index].id!, "status" :status ?? 0
            ] as [String : Any]
        
        WebServiceHandler.performPOSTRequest(urlString: updatevisibility, params: param ) { (result, error) in
            
            if (result != nil){
                let statusCode = result!["status"]?.string
                let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                    
                    let matrixobj = self.matrixlist[index]
                    
                    if self.matrixlist[index].status ==  1
                     {
                        
                        matrixobj.status = 0
                        self.matrixlist.remove(at: index)
                        self.matrixlist.insert(matrixobj, at:index)
                        
            
                     }
                     else {
                        matrixobj.status = 1
                        self.matrixlist.remove(at: index)
                        self.matrixlist.insert(matrixobj, at:index)
                     }
                    
                   
                    self.tabelview.reloadSections([1], with: .none)

                  
                     }
                        
                    else{
                    DispatchQueue.main.async {
                        self.showAlertWithMessage("ALERT", msg ?? "")
                    }
                }
               
            }
        }
    }
}

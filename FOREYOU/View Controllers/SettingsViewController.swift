//
//  SettingsViewController.swift
//

import UIKit

class SettingsViewController: BaseViewControllerClass,PrefrencesCollectionViewCellDelegate
{
    func btnHideAccTapped() {
        
       
        callHideAccApi()
    }
    
    func btnDeleteAcc() {
        
        callDeleteAccApi()
    }
    
    func btntermconditionAcc()
    {
    let controller = TermsAndConditionViewController.instantiateFromStoryBoard()
        
        controller.modalPresentationStyle = .fullScreen
        controller.btnTag = 1
        controller.selectcontroller = false
        self.present(controller, animated: true, completion: nil)
     }
    
    enum Category{
        case Prefrences
        case PaymentInfo
    }
    
    @IBOutlet weak var settingsCollectionView: UICollectionView!
    @IBOutlet weak var sliderView: UIView!
    
    
    static var viewControllerId = "SettingsViewController"
    static var storyBoard = "Main"
    var selectedView = Category.Prefrences

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
       
        setInitials()
    }
    
    func setInitials(){
        settingsCollectionView.register(UINib(nibName: "PrefrencesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PrefrencesCollectionViewCell")
        settingsCollectionView.register(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        settingsCollectionView.delegate = self
        settingsCollectionView.dataSource = self
        
    }
    

    func callDeleteAccApi()
    {
        AppHelper.sharedInstance.displaySpinner()
        let param = ["app_type": AppType,
                     "user_id":UserDetails.sharedInstance.userID,
            ] as [String : Any]
        
        WebServiceHandler.performPOSTRequest(urlString: kdeleteProfileURL, params: param ) { (result, error) in
            
            if (result != nil){
                let statusCode = result!["status"]?.string
                let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                    
                    AppHelper.makeLoginViewControllerAsRootViewController()
                    AppHelper.sharedInstance.removeSpinner()

                        print(result)
                        
                    }
                }
               
            else
            {
                self.showAlertWithMessage("ALERT", "")
                AppHelper.sharedInstance.removeSpinner()
            }
        }
    }
    func callHideAccApi()
    {
      
        var account_status = 0
        if(UserDefaults.standard.value(forKey: "account_status") as? Int == 0)
            {
            account_status = 1
        }
        else
        {
            account_status = 0
        }
        let param = ["app_type": AppType,
                     "user_id":UserDetails.sharedInstance.userID,
                     "account_status":account_status
            ] as [String : Any]
        
        WebServiceHandler.performPOSTRequest(urlString: khideProfileURL, params: param ) { (result, error) in
            
            if (result != nil){
                let statusCode = result!["status"]?.string
                let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                    let account_status = result!["account_status"]?.int
                    UserDefaults.standard.setValue(account_status, forKey: "account_status")
                    self.showAlertWithMessage("ALERT", msg!)
                    AppHelper.sharedInstance.removeSpinner()
                    self.settingsCollectionView.reloadData()
                    print(result)
                        
                    }
                }
               
            else
            {
                self.showAlertWithMessage("ALERT", "")
               
            }
        }
    }
    
    @IBAction func btnCrossAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func btnLogOutTapped() {
        logoutApi()
        
    }
    func logoutApi()
    {
       
        let param = ["app_type": AppType,
                     "email":UserDetails.sharedInstance.user_email,
            ] as [String : Any]
        
        WebServiceHandler.performPOSTRequest(urlString: kLogoutURL, params: param ) { (result, error) in
            
            if (result != nil){
                let statusCode = result!["status"]?.string
                let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                    
                    self.showAlertWithMessage("ALERT", msg!)
                    UserDetails.sharedInstance.info_status = 0
                    AppHelper.saveUserDetails()
                    AppHelper.sharedInstance.removeSpinner()
                    self.settingsCollectionView.reloadData()
                   
                    AppHelper.makeLoginViewControllerAsRootViewController()
                    }
                }
               
            else
            {
                self.showAlertWithMessage("ALERT", "")
                
            }
        }
    }
    
}
extension SettingsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selectedView {
        case .Prefrences:
            return 1
        case .PaymentInfo:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch selectedView {
        case .Prefrences:
            let  cell = settingsCollectionView.dequeueReusableCell(withReuseIdentifier: "PrefrencesCollectionViewCell", for: indexPath) as? PrefrencesCollectionViewCell
            cell!.delegate = self
            if(UserDefaults.standard.value(forKey: "account_status") as? Int == 0)
            {
            cell?.hideAcc.setTitle("Hide Account", for: .normal)
            }
            else
            {
                cell?.hideAcc.setTitle("Unhide Account", for: .normal)
            }
            return cell!
        case .PaymentInfo:
            let  cell = settingsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as? ProfileCollectionViewCell
            
            return cell!
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch selectedView {
        case .Prefrences:
            return CGSize(width: self.view.frame.size.width, height:905)
        case .PaymentInfo:
            return CGSize(width: self.view.frame.size.width, height: 700)
        }
        
    }
    
}

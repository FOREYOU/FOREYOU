import UIKit
import GoogleSignIn
import FBSDKLoginKit
import CoreBluetooth
import Contacts

class SignUpViewController: BaseViewControllerClass, UITextFieldDelegate {
   
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldMobile: UITextField!
    @IBOutlet weak var txtFieldRelation: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    @IBOutlet weak var name: UITextField!

    var iconClick = false

    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var btnNext: UIButton!
    static var viewControllerId = "SignUpViewController"
    static var storyBoard = "Main"
    var counter = 0
    var pPolicy = 0
    var totalSteps = 3
    
    var countryCode = "+1"
    var email = ""
    var mobile = ""
    var RelationStatus = ""
    var password = ""
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
        txtFieldEmail.text = ""
        name.text = ""
        txtFieldMobile.text = ""
        txtFieldPassword.text = ""
        txtFieldConfirmPassword.text = ""
        txtFieldMobile.delegate = self
        if #available(iOS 13.0, *)
        {
                  
         overrideUserInterfaceStyle = .light

        }
        else
        {
                  // Fallback on earlier versions
        }
        
     
        // Do any additional setup after loading the view.
        setInitials()
   
    }
    //
    //Privacyaction
    @IBAction func iconAction(sender: UIButton) {
       
       
        if(sender.isSelected == true) {
           pPolicy = 0
            sender.isSelected  = false
             
        } else {
            pPolicy = 1
             sender.isSelected  = true
        }

        iconClick = !iconClick
        
    }
    
    @IBAction func termAction(sender: UIButton) {
        
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as? PrivacyPolicyVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    
   func setInitials(){
        txtFieldPassword.isSecureTextEntry = true
        txtFieldConfirmPassword.isSecureTextEntry = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
     override func viewWillAppear(_ animated: Bool) {
    }
    
    
    func checkValidation() -> Bool{
        
        if (name.text!.isEmpty) == true {
            self.txtFieldEmail.becomeFirstResponder()
            showAlertWithMessage(ConstantStrings.ALERT, "Please Enter Name")
            return false
        }
        if (txtFieldEmail.text!.isEmpty) == true {
            self.txtFieldEmail.becomeFirstResponder()
            showAlertWithMessage(ConstantStrings.ALERT, "Please Enter Email")
            return false
        }
        if !RegularExpression.validateEmail(self.txtFieldEmail.text!) {
            self.txtFieldEmail.becomeFirstResponder()
            showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.PLEASE_ENTER_VALID_EMAIL)
            return false
        }
        
        if (txtFieldMobile.text!.isEmpty) == true {
            showAlertWithMessage("ALERT", "Please Enter Mobile Number")
            return false
        }
        
        if  txtFieldMobile.text!.isPhone()
        {
            
        }
        else {
            showAlertWithMessage("ALERT", "Please Enter valid Mobile Number")
            return false
        }
        
        if txtFieldMobile.text!.count < 8 || txtFieldMobile.text!.count > 15  {
            self.txtFieldMobile.becomeFirstResponder()
            showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.PLEASE_ENTER_VALID_MOBILE)
            return false
        }
        
        if (txtFieldPassword.text!.isEmpty) == true {
            showAlertWithMessage("ALERT", "Please Enter Password")
            return false
        }
        
        if (txtFieldPassword.text!.count < 6) == true {
            showAlertWithMessage("ALERT", "Password should be of minimum 6 character")
            return false
        }
        if txtFieldPassword.text != txtFieldConfirmPassword.text{
            showAlertWithMessage("ALERT", "Password and Confirm Password Should be same")
            return false
        }
        
        
       email =  txtFieldEmail.text! as! String
        mobile = txtFieldMobile.text! as! String
        RelationStatus = "Single"
        password = txtFieldPassword.text! as! String
        
        return true
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        view.endEditing(true)
        if checkValidation(){
            if pPolicy == 0
            {
                self.showAlertWithMessage("Alert", "Please agree with privacy Policy")
            }
            else
            {
                signupApiStep1()
            }
            }
        }
 
   func signupApiStep1()
    {
   
    
      

    
        let param = ["app_type": AppType,
                     "email": txtFieldEmail.text!,
                     "mobile": txtFieldMobile.text!,
                     "country_code": countryCode,
                     "password": txtFieldPassword.text!,
                     "device_type":"ios",
                     "device_token":UserDetails.sharedInstance.pushnotificationtoken,
                     "relationship_status": "SINGLE",
                     "user_firstname" : name.text!

                    ] as [String : Any]
        
        WebServiceHandler.performPOSTRequest(urlString: kSignUpStep1, params: param ) { (result, error) in
            DispatchQueue.main.async() {
           
         }
            if (result != nil){
                let statusCode = result!["status"]?.string
                let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                    let controller = GenderViewController.instantiateFromStoryBoard()
                    controller.countryCode = self.countryCode
                    controller.email = self.email
                    controller.password = self.password
                    controller.mobile = self.mobile
                    controller.RelationStatus = self.RelationStatus
                    
                    let user_id = result!["user_id"]?.string
                    UserDetails.sharedInstance.userID = user_id!
                    AppHelper.saveUserDetails()
                    self.push(controller)
                   
                    if let reponse = result!["response"]?.array{
                        print(reponse)
                        
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
    
    @IBAction func btnSignInAction(_ sender: Any) {
      
        let controller = LoginViewController.instantiateFromStoryBoard()
        self.push(controller)
    }
    
    @IBAction func btnShowPassword(_ sender: Any) {
        txtFieldPassword.isSecureTextEntry.toggle()
    }
    
    @IBAction func btnShowConfirmPassword(_ sender: Any) {
        txtFieldConfirmPassword.isSecureTextEntry.toggle()
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
      
        self.navigationController?.popViewController(animated: true)
        
    }
    
 func setCountryCode(countryPhoneCode: String) {
        countryCode = countryPhoneCode
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
          
           if newLength <= 10 {
                return true
            }
            
           else {
            
             return false
            }
        
       }
      
}


extension String {
    
    public func isPhone()->Bool {
        if self.isAllDigits() == true {
            let phoneRegex = "[235689][0-9]{6}([0-9]{3})?"
            let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return  predicate.evaluate(with: self)
        }else {
            return false
        }
    }
    
    private func isAllDigits()->Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
}

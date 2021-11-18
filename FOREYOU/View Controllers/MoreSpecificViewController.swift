

import UIKit
protocol MoreSpecificViewControllerDelegate {
    func selectedGender(myGender:String,showGenderOnProfile:Int )

}
class MoreSpecificViewController: BaseViewControllerClass {
    
    
    @IBOutlet weak var btnCisWoman: UIButton!
    @IBOutlet weak var btnTransWoman: UIButton!
    @IBOutlet weak var btnWoman: UIButton!
    @IBOutlet weak var btnCisMan: UIButton!
    @IBOutlet weak var btnTransMan: UIButton!
    @IBOutlet weak var btnMan: UIButton!
    @IBOutlet weak var btnNonBinary: UIButton!
    @IBOutlet weak var txtFieldGender: UITextField!
    var  showGenderOnProfile:Int = 0

    var isNonBinarySelected = false
    var delegate:MoreSpecificViewControllerDelegate?
    var selectedGender = ""
    static var viewControllerId = "MoreSpecificViewController"
    static var storyBoard = "Main"
    
    var countryCode = "+1"
    var email = ""
    var mobile = ""
    var RelationStatus = ""
    var password = ""

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
        txtFieldGender.isEnabled = false
    }
    
    @IBAction func iconAction(sender: UIButton) {
       
       
         if isNonBinarySelected == true
         {
            
         if(sender.isSelected == true) {
         
            sender.isSelected  = false
            
            showGenderOnProfile = 0
            
             
        } else {
           
             sender.isSelected  = true
            showGenderOnProfile = 1
        }
         }
         else {
            
         }
      
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
       // self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnDoneAction(_ sender: Any) {
        if isNonBinarySelected == true{
            if txtFieldGender.text!.count == 0{
                showAlertWithMessage("ALERT", "Please Enter your Gender")
                return
            }else{
                selectedGender = txtFieldGender.text!
            }
        }
      
        self.delegate?.selectedGender(myGender: selectedGender, showGenderOnProfile: showGenderOnProfile)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnCisWomanAction(_ sender: Any) {
        setSelected(btn: btnCisWoman)
        setDeselected(btn: btnTransWoman)
        setDeselected(btn: btnWoman)
        setDeselected(btn: btnCisMan)
        setDeselected(btn: btnTransMan)
        setDeselected(btn: btnMan)
        setDeselected(btn: btnNonBinary)
        selectedGender = btnCisWoman.title(for: .normal)!
        isNonBinarySelected = false
        txtFieldGender.isEnabled = false
    }
    
    @IBAction func btnTransWomanAction(_ sender: Any) {
        setSelected(btn: btnTransWoman)
        setDeselected(btn: btnCisWoman)
        setDeselected(btn: btnWoman)
        setDeselected(btn: btnCisMan)
        setDeselected(btn: btnTransMan)
        setDeselected(btn: btnMan)
        setDeselected(btn: btnNonBinary)
        selectedGender = btnTransWoman.title(for: .normal)!
        isNonBinarySelected = false
        txtFieldGender.isEnabled = false
    }
    @IBAction func btnWomanAction(_ sender: Any) {
        setSelected(btn: btnWoman)
        setDeselected(btn: btnCisWoman)
        setDeselected(btn: btnTransWoman)
        setDeselected(btn: btnCisMan)
        setDeselected(btn: btnTransMan)
        setDeselected(btn: btnMan)
        setDeselected(btn: btnNonBinary)
        selectedGender = btnWoman.title(for: .normal)!
        isNonBinarySelected = false
        txtFieldGender.isEnabled = false
    }
    @IBAction func btnCisManAction(_ sender: Any) {
        setSelected(btn: btnCisMan)
        setDeselected(btn: btnCisWoman)
        setDeselected(btn: btnTransWoman)
        setDeselected(btn: btnWoman)
        setDeselected(btn: btnTransMan)
        setDeselected(btn: btnMan)
        setDeselected(btn: btnNonBinary)
        selectedGender = btnCisMan.title(for: .normal)!
        isNonBinarySelected = false
        txtFieldGender.isEnabled = false
    }
    
    @IBAction func btnTransManAction(_ sender: Any) {
        setSelected(btn: btnTransMan)
        setDeselected(btn: btnCisWoman)
        setDeselected(btn: btnTransWoman)
        setDeselected(btn: btnWoman)
        setDeselected(btn: btnCisMan)
        setDeselected(btn: btnMan)
        setDeselected(btn: btnNonBinary)
        selectedGender = btnTransMan.title(for: .normal)!
        isNonBinarySelected = false
        txtFieldGender.isEnabled = false
    }
    
    @IBAction func btnManAction(_ sender: Any) {
        setSelected(btn: btnMan)
        setDeselected(btn: btnCisWoman)
        setDeselected(btn: btnTransWoman)
        setDeselected(btn: btnWoman)
        setDeselected(btn: btnCisMan)
        setDeselected(btn: btnTransMan)
        setDeselected(btn: btnNonBinary)
        selectedGender = btnMan.title(for: .normal)!
        isNonBinarySelected = false
        txtFieldGender.isEnabled = false
    }
    
    @IBAction func btnNonBinaryAction(_ sender: Any) {
        setSelected(btn: btnNonBinary)
        setDeselected(btn: btnCisWoman)
        setDeselected(btn: btnTransWoman)
        setDeselected(btn: btnWoman)
        setDeselected(btn: btnCisMan)
        setDeselected(btn: btnTransMan)
        setDeselected(btn: btnMan)
        isNonBinarySelected = true
        txtFieldGender.isEnabled = true
    }
    
}
extension MoreSpecificViewController{
    func setDeselected(btn:UIButton) {
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.borderColor = UIColor.white
        btn.backgroundColor = UIColor.clear
    }
    
    func setSelected(btn:UIButton) {
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.borderColor = UIColor.white
        btn.backgroundColor = Colors.ORANGE_COLOR
    }
}

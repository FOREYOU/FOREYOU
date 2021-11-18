//
//  GenderViewController.swift
//  FOREYOU
//
//  Created by Vikas Kushwaha on 18/12/20.
//  Copyright © 2020 Digi Neo. All rights reserved.
//

import UIKit
import CoreLocation

class GenderViewController: BaseViewControllerClass,MoreSpecificViewControllerDelegate {
   
    
    
    var locationManager = CLLocationManager()
    var currentAddress = ""
    var lat = ""
    var long = ""
    
    
    @IBOutlet weak var btnLookingForEveryone: UIButton!
    @IBOutlet weak var btnLookingForShe: UIButton!
    @IBOutlet weak var btnLookingForHe: UIButton!
    @IBOutlet weak var btnMyGenderHe: UIButton!
    @IBOutlet weak var btnMyGenderShe: UIButton!
    @IBOutlet weak var btnMoreSpecific: UIButton!
    
    static var viewControllerId = "GenderViewController"
    static var storyBoard = "Main"
    
    var countryCode = "+1"
    var email = ""
    var mobile = ""
    var RelationStatus = ""
    var password = ""
    var gender = ""
    var lookingFor = ""
    
    var myGender = 0
    var otherGender = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
        setupLocationManager()

        setInitials()
   
    }
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
    }
    func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
      
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        if let pm = placemarks{
                                            if pm.count > 0 {
                                                let pm = placemarks![0]
                                                var addressString : String = ""
                                                
                                                if pm.subThoroughfare != nil {
                                                    addressString = addressString + pm.subThoroughfare! + " "
                                                }
                                                if pm.thoroughfare != nil {
                                                    addressString = addressString + pm.thoroughfare! + ", "
                                                }
                                                
                                                if pm.locality != nil {
                                                    addressString = addressString + pm.locality! + ", "
                                                }
                                                if pm.administrativeArea != nil {
                                                    addressString = addressString + pm.administrativeArea! + " "
                                                }
                                                if pm.postalCode != nil {
                                                    addressString = addressString + pm.postalCode! + ", "
                                                }
                                                if pm.country != nil {
                                                    addressString = addressString + pm.country!
                                                }
                                                self.currentAddress = addressString
                                                print(addressString)
                                                
                                            }
                                        }
                                    })
    }
    
    
    func setInitials(){
        
    }
    @IBAction func btnMyGenderHeAction(_ sender: Any) {
        setDeselected(btn: btnMyGenderShe)
        setSelected(btn: btnMyGenderHe)
        setDeselected(btn: btnMoreSpecific)
        gender = btnMyGenderHe.title(for: .normal)!
        myGender = 1
        
    }
    @IBAction func btnMyGenderSheAction(_ sender: Any) {
        setDeselected(btn: btnMyGenderHe)
        setSelected(btn: btnMyGenderShe)
        setDeselected(btn: btnMoreSpecific)
        gender = btnMyGenderShe.title(for: .normal)!
        myGender = 1
    }
    @IBAction func btnMoreSpecificAction(_ sender: Any) {
        setDeselected(btn: btnMyGenderHe)
        setDeselected(btn: btnMyGenderShe)
        let controller = MoreSpecificViewController.instantiateFromStoryBoard()
        controller.delegate = self
        controller.countryCode = countryCode
        controller.email = email
        controller.password = password
        controller.mobile = mobile
        controller.RelationStatus = RelationStatus
       // push(controller)
        present(controller, animated: true, completion: nil)
        myGender = 1
    }
    
    
    @IBAction func btnLookingForHeAction(_ sender: Any) {
        setDeselected(btn: btnLookingForEveryone)
        setDeselected(btn: btnLookingForShe)
        setSelected(btn: btnLookingForHe)
        lookingFor = btnLookingForHe.title(for: .normal)!
        otherGender = 1
    }
    @IBAction func btnLookingForSheAction(_ sender: Any) {
        setDeselected(btn: btnLookingForEveryone)
        setDeselected(btn: btnLookingForHe)
        setSelected(btn: btnLookingForShe)
        lookingFor = btnLookingForShe.title(for: .normal)!
        otherGender = 1
    }
    
    @IBAction func btnLookingForEveryoneAction(_ sender: Any) {
        setDeselected(btn: btnLookingForShe)
        setDeselected(btn: btnLookingForHe)
        setSelected(btn: btnLookingForEveryone)
        lookingFor = btnLookingForEveryone.title(for: .normal)!
        otherGender = 1
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        if otherGender == 1 && myGender == 1{
            signupApiStep2()
        }else{
            self.showAlertWithMessage("ALERT", "Please Select Gender First")
            return
        }
      
    }
  func signupApiStep2()
    {
       let param = ["app_type": AppType,
                     "email": email,
                     "mobile": mobile,
                     "country_code": countryCode,
                     "gender": gender,
                     "looking_for": lookingFor,
                     "lat": lat,
                     "long": long,
                     "user_location": currentAddress
                    ] as [String : Any]
        
        WebServiceHandler.performPOSTRequest(urlString: kSignUp2URL, params: param ) { (result, error) in
            DispatchQueue.main.async() {
            
         }
            if (result != nil){
                let statusCode = result!["status"]?.string
                let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                    let controller = ConnectViewController.instantiateFromStoryBoard()
                    controller.countryCode = self.countryCode
                    controller.email = self.email
                    controller.password = self.password
                    controller.mobile = self.mobile
                    controller.RelationStatus = self.RelationStatus
                    controller.gender = self.gender
                    controller.lookingFor = self.lookingFor
                    
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
    
    //MoreSpecificDelegate
    
    func selectedGender(myGender: String, showGenderOnProfile: Int) {
        gender = myGender
        btnMoreSpecific.setTitle(myGender, for: .normal)
        setSelected(btn: btnMoreSpecific)
    }
  
    
    
}
extension GenderViewController{
    func setDeselected(btn:UIButton) {
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.borderColor = UIColor.black
        btn.backgroundColor = UIColor.white
    }
    
    func setSelected(btn:UIButton) {
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.borderColor = UIColor.black
        btn.backgroundColor = Colors.ORANGE_COLOR
    }
}
extension GenderViewController:CLLocationManagerDelegate{
    
    
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.last != nil{
            
        }else{
            return
        }
        
       print(locationManager.location)
    
        lat = "\(locationManager.location!.coordinate.latitude)"
    
        if(lat == nil)
        {
            lat = "28.704"
        }
    
        long = "\(locationManager.location!.coordinate.longitude)"
    
        if(long == nil)
        {
            long = "77.102"
        }
        getAddressFromLatLon(pdblLatitude: "\(locationManager.location!.coordinate.latitude)", pdblLongitude: "\(locationManager.location!.coordinate.longitude)")
        locationManager.stopUpdatingLocation()
    }
    
}

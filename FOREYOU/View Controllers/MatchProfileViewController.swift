

import UIKit
import CoreBluetooth
import SystemConfiguration.CaptiveNetwork
import SwiftyJSON
import Lightbox

class MatchProfileViewController: BaseViewControllerClass,UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, matchCellDelegate {
    
    //delegatemethod
    func fetchimage(urlimg: [JSON], Start: Int) {
        
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
    
    @IBOutlet weak var itemList: UITableView!
    @IBOutlet weak var  Message : UILabel!
    @IBOutlet weak var matchcontact : UILabel!


    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var imgViewwidthConstraint: NSLayoutConstraint!


    var batteryLevel: Float { UIDevice.current.batteryLevel }
    var batteryState: UIDevice.BatteryState { UIDevice.current.batteryState }
    var batteryPercent = 0.0
    var batteryStatus = ""
    var bluetoothState = ""
    var NetworkStrength = ""
    var signal = -1
    var wifiStatus = ""
    var wifiName = ""
    var signalStrengthIndi = SignalStrengthIndicator()
    var matchlist = [MatchData]()
    var lockedlist = [MatchData]()


    var bluetoothPeripheralManager: CBPeripheralManager?
    let options = [CBCentralManagerOptionShowPowerAlertKey:0]
    
    @IBOutlet weak var gotVwheight: NSLayoutConstraint!
    var indicator = UIActivityIndicatorView()
    static var viewControllerId = "MatchProfileViewController"
    static var storyBoard = "Main"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
                  
                 overrideUserInterfaceStyle = .light

              } else {
                  // Fallback on earlier versions
              }
       
        imgViewwidthConstraint.constant = -7
//        itemList.frame.height = itemList.contentSize.height
        
        self.itemList.isHidden = true
         Message.isHidden  = true
        matchcontact.isHidden = true

         setInitials()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        Timer.scheduledTimer(timeInterval: 600.0, target: self, selector: #selector(fetchBluetoothAndBatteryStatus), userInfo: nil, repeats: true)
        //fetchBluetoothAndBatteryStatus()
    }
    override func viewDidAppear(_ animated: Bool) {
        
         Timer.scheduledTimer(timeInterval: 600.0, target: self, selector: #selector(getSignalStrength), userInfo: nil, repeats: true)
        
       signal =  getSignalStrength()
        if signal == 1{
            NetworkStrength = "Very Low"
        }else if signal == 2{
            NetworkStrength = "Low"
        }else if signal == 3{
            NetworkStrength = "Good"
        }else if signal == 4{
            NetworkStrength = "Excellent"
        }else{
            NetworkStrength = "Unknown"
        }
    }
    
  
    
    
    
    func setInitials(){
        itemList.registerCell("MatchedProfileTableViewCell")
        itemList.registerCell("InviteFriends")
        itemList.registerCell("InviteMessageCell")
       
     
       
        callListingApi()
        
        notificationView.cornerRadius = Double(notificationView.frame.height/2)
        
        Timer.scheduledTimer(timeInterval: 600.0, target: self, selector: #selector(fetchstatus), userInfo: nil, repeats: true)
        
    }
    @objc func fetchstatus() {
      
    let currentWifiStatus = fetchSSIDInfo()
               if currentWifiStatus != ""{
                   wifiStatus = "Wifi Status: On"
                   wifiName = currentWifiStatus
                   
            NotificationCenter.default.addObserver(self, selector: #selector(WifiConnected), name: NSNotification.Name(rawValue: "notifyWifiState"), object: nil)
               }else{
                   wifiStatus = "Wifi Status: Off"
                   wifiStatus = currentWifiStatus
               }
    }
    
    @objc func WifiConnected(_ notification: Notification) {
        callUpdateApi()
    }
    func getSignalStrenght(){
       print(signalStrengthIndi.level)
    }
    @objc func getSignalStrength() -> Int {

        if #available(iOS 13.0, *){
                if let statusBarManager = UIApplication.shared.keyWindow?.windowScene?.statusBarManager,
                    let localStatusBar = statusBarManager.value(forKey: "createLocalStatusBar") as? NSObject,
                    let statusBar = localStatusBar.value(forKey: "statusBar") as? NSObject,
                    let _statusBar = statusBar.value(forKey: "_statusBar") as? UIView,
                    let currentData = _statusBar.value(forKey: "currentData")  as? NSObject,
                    let celluar = currentData.value(forKey: "cellularEntry") as? NSObject,
                    let signalStrength = celluar.value(forKey: "displayValue") as? Int {
                    NotificationCenter.default.addObserver(self, selector: #selector(signalChanged), name: NSNotification.Name(rawValue: "notifySignalCHange"), object: nil)
                    return signalStrength
                } else {
                    return -1
                }
            } else {
                var signalStrength = -1
                let application = UIApplication.shared
                let statusBarView = application.value(forKey: "statusBar") as! UIView
                let foregroundView = statusBarView.value(forKey: "foregroundView") as! UIView
                let foregroundViewSubviews = foregroundView.subviews
                var dataNetworkItemView: UIView!
                for subview in foregroundViewSubviews {
                    if subview.isKind(of: NSClassFromString("UIStatusBarSignalStrengthItemView")!) {
                        dataNetworkItemView = subview
                        break
                    } else {
                        signalStrength = -1
                    }
                }
                signalStrength = dataNetworkItemView.value(forKey: "signalStrengthBars") as! Int
                if signalStrength == -1 {
                    return -1
                } else {
                    NotificationCenter.default.addObserver(self, selector: #selector(signalChanged), name: NSNotification.Name(rawValue: "notifySignalCHange"), object: nil)
                    return signalStrength
                }
            }

    }
    
    @objc func signalChanged()
    {
        callUpdateApi()
    }
  @objc  func fetchBluetoothAndBatteryStatus(){
        UIDevice.current.isBatteryMonitoringEnabled = true
        print(batteryLevel)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        batteryPercent = Double(batteryLevel * 100)
        print(batteryState)
        switch batteryState {
        case .unplugged:
                batteryStatus = "Not Charging"
        case .unknown:
                batteryStatus = "Unknown"
        case .charging:
                batteryStatus = "Charging"
        case .full:
                batteryStatus = "Full"
           }
       
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
    }
    
    @objc func batteryLevelDidChange(_ notification: Notification) {
      
        callUpdateApi()
    }
    
    func callListingApi()
    {
        
       
        
        let param = ["device_type":"ios","device_token":UserDetails.sharedInstance.pushnotificationtoken,"app_type": AppType,
            "user_id":  UserDetails.sharedInstance.userID ,
            "user_interested_for":UserDetails.sharedInstance.user_interested_for,
            "limit": 3] as [String : Any]
            print(param)
            WebServiceHandler.performPOSTRequest(urlString: klistingURL, params: param ) { (result, error) in
            
                DispatchQueue.main.async() {
                  
                }
                
                if (result != nil){
                    let statusCode = result!["status"]?.string
                    let msg = result!["msg"]?.string
                    if statusCode == "200"
                    {
                       
                        print(result ?? "")
                        let usersDic = result!["users"]?.array
                       
                         
                        if msg ==  "Data not found."
                        {
                          
                            self.itemList.isHidden = true
                            self.Message.isHidden  = false
                            self.matchcontact.isHidden = true
                         
                         
                            return
                        }
                          for ApiJSON in usersDic! {
                            
                            let api = MatchData.init()
                            
                            api.setJson(json: ApiJSON)
                            
                            self.matchlist .append(api)
                            
                            self.lockedlist.append(api)
                            
                        }
                      
                       
                        self.matchlist = self.matchlist.filter { $0.is_locked == "0"
                            
                        }
    
                        self.lockedlist = self.lockedlist.filter { $0.is_locked == "1"
                        
                        }
                       
                        DispatchQueue.main.async { [self] in
                            
                            if self.matchlist.count == 0
                            {
                                self.itemList.isHidden = true
                                self.Message.isHidden  = false
                                self.matchcontact.isHidden = true
                             
                               return
                                
                            }
                            self.itemList.isHidden = false
                         
                            self.Message.isHidden  =   true
                            self.matchcontact.isHidden = false
                            self.matchcontact.text =  String((self.matchlist.count)) + "  Matches"
                     
                        self.itemList.dataSource = self
                        self.itemList.delegate = self
                        self.itemList.reloadData()
                        }
                        
                      
                       
                    }
                }
                   
                else
                {
                    self.showAlertWithMessage("ALERT", "")
                  
                  
                }
               

            }
    }

func fetchSSIDInfo() ->  String {
    
        var currentSSID = ""
        if let interfaces:CFArray = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as Dictionary?
                    for dictData in interfaceData! {
                        if dictData.key as! String == "SSID" {
                            currentSSID = dictData.value as! String
                        }
                    }
                }
            }
        }
        return currentSSID
    }
    
    @IBAction func gotIt(_ sender: Any) {
        gotVwheight.constant = 0
    }
    @IBAction func btnSettingsAction(_ sender: Any) {
        openSettings()
    }
    
    func openSettings(){
        let controller = SettingsViewController.instantiateFromStoryBoard()
        
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func  numberOfSections(in tableView: UITableView) -> Int {
       
      if  self.lockedlist.count > 0 && self.matchlist.count > 0
      {
         return 3
      }
     
     
     else {
          return 2
     }
     
    
   }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
          if  self.lockedlist.count > 0 && self.matchlist.count > 0
          {
      if  section == 0
      {
         return matchlist.count
      }
  
    else  if section == 1
      {
          return 1
      }
      else {
          
          return  lockedlist.count
      }
          }
          else {
              if  section == 0
            {
               return matchlist.count
            }
        
          else
            {
                return 1
            }
          }
     
      
    }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          if  indexPath.section == 0
          {
     
              let cell = itemList.dequeueReusableCell(withIdentifier: "MatchedProfileTableViewCell") as? MatchedProfileTableViewCell
                  
              let object = matchlist[indexPath.row]
                  let email = object.emailId
                  let splits = email?.components(separatedBy: "@")
       
                    
              
               cell?.loadimage(images: object.profile_image ?? [])
                 
                  
            let name = object.firstName
          
            
          cell?.userName.text =   name.capitalized
           
         
                  cell?.matchPercent.text =  object.match_percentage!
            
            let fulladdress =  object.address!
         //   let fulladdressArr = fulladdress.components(separatedBy: ",")
         //   let firstAddress = fulladdressArr[0]
         //   let secondAddress = fulladdressArr[1]
            
            //First.
        ///    let finaladdress =  firstAddress + "," +  secondAddress
            
            cell?.address.text =   fulladdress.capitalized
            cell?.distance.text =   (object.user_distance!)   + " Miles"  + " away"
               
                 cell?.detailbtn.addTarget(self, action: #selector(detailclicked), for: .touchUpInside)
                  cell?.detailbtn.tag  = indexPath.row

            if indexPath.row == 0
            {
               // cell?.matchView1.borderWidth = 1
                cell?.matchView1.borderColor = UIColor.black
                cell?.matchView1.backgroundColor = UIColor.black
                cell?.matchView1.cornerRadius = Double((cell?.matchView1.frame.height)!/2)
                cell?.matchlabel.text = "1/1 Matches"
                cell?.matchView2.borderWidth = 1
                cell?.matchView2.borderColor = UIColor.black
                cell?.matchView2.backgroundColor = UIColor.white
                cell?.matchView2.cornerRadius = Double((cell?.matchView2.frame.height)!/2)
               
            }
            
            else {
              ///  cell?.matchView1.borderWidth = 1
                //?.matchView1.borderColor = UIColor.ba
                cell?.matchView1.backgroundColor = UIColor.black
                cell?.matchView1.cornerRadius = Double((cell?.matchView1.frame.height)!/2)
               // cell?.matchView2.borderWidth = 1
               // cell?.matchView2.borderColor = UIColor.white
                cell?.matchView2.backgroundColor = UIColor.black
                cell?.matchView2.cornerRadius = Double((cell?.matchView2.frame.height)!/2)
                cell?.matchlabel.text = "2/2 Matches"
            }
            
            
              cell?.selectionStyle = .none
              cell?.delete = self
            
                  return cell!
              }
          
         else  if indexPath.section == 1
          {
              let cell = itemList.dequeueReusableCell(withIdentifier: "InviteMessageCell") as? InviteMessageCell
            
            cell?.Intivebtn?.addTarget(self, action: #selector(inviteclicked), for: .touchUpInside)
             cell?.Intivebtn?.tag  = indexPath.row
            
            cell?.crossgotbtn?.addTarget(self, action: #selector(crossclicked), for: .touchUpInside)
             cell?.crossgotbtn?.tag  = indexPath.row
            
            if APPDELEGATE.removemsg == true
            {
                cell?.Heighrconstant?.constant = 20
                
            }
            else {
               
            }

            cell?.selectionStyle = .none
              
               return cell!
              
          }
          
          else {
             
              let cell = (itemList.dequeueReusableCell(withIdentifier: "InviteFriends") as? InviteFriends)
              cell?.alpha = 0.5
              let object = self.lockedlist[indexPath.row]
              
              let name = object.firstName
            
              
            cell?.userName.text = name.capitalized
              cell?.matchPercent.text =  object.match_percentage!
            
            
            
            let fulladdress =  object.address!
         //   let fulladdressArr = fulladdress.components(separatedBy: ",")
         //   let firstAddress = fulladdressArr[0]
          /////  let secondAddress = fulladdressArr[1]
            
            //First.
          ///  let finaladdress =  firstAddress + "," +  secondAddress
            
            cell?.address.text =   fulladdress.capitalized
              
            cell?.distance.text =  (object.user_distance!) +  " Miles"  + " away"
           
             cell?.loadlockedimage(images: object.profile_image ?? [])
            cell?.selectionStyle = .none
              return cell!
          }
          
          }
    
    @objc func crossclicked(_ sender: UIButton) {
        
       
        itemList.reloadSections(IndexSet(integer: 1), with: .none)

        APPDELEGATE.removemsg = true
       
        
    }
          
    @objc func detailclicked(_ sender: UIButton) {
        
        let object = matchlist[sender.tag]
        let controller = DiscoverViewController.instantiateFromStoryBoard()
        controller.userId = object.userId ?? ""
        push(controller)
    }
    
    @objc func inviteclicked(_ sender: UIButton) {
        
        let items = [URL(string: "https://testflight.apple.com/join/95jdheYV")!]
        
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        present(ac, animated: true)
        
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
      if self.lockedlist.count > 0
      {
          if  indexPath.section == 0
      {
          return 440.0
      }
      
       if indexPath.section == 1
      {
        if APPDELEGATE.removemsg == true
        {
            return 180.0
        }
        else {
            return 285.0
        }
        
          
      }
      else {
          return 440.0
      }
      }
      else {
          if indexPath.section ==  0
          {
              return 440.0
          }
          else  {
              return 285.0
          }
      }
      
  }
   
}

   
extension MatchProfileViewController{
    
    func callUpdateApi(){
     //   AppHelper.sharedInstance.displaySpinner()
        let param = ["app_type": AppType,
                     "user_id": UserDetails.sharedInstance.userID,
                     "contact_list":[
                     ],
                    /*"contact_list":contact_listArray,*/"usage_data":[/*"MEDIA_DATA":photosData, "INSTAGRAM_DATA":instaArray,"SPOTIFY_DATA":spotifyRecentSongArray,"TWITTER_DATA":twitterDataArray,"APPLE_MUSIC_DATA":recentSongArray,*/"BATTERY_CHARGING_STATUS":["state":"\(batteryStatus)","percent":"\(batteryPercent)"],"BLUETOOTH_CONNECTIVITY_STATUS":["state":bluetoothState],"WIFI_CONNECTIVITY_STATUS":["status":wifiStatus,"name":wifiName],"POTENTIALLY_SIGNAL_STRENGTH_CONNECTIVITY_STATUS":["status":"\(NetworkStrength)","value":"\(signal)"]
            ]
        ] as [String : Any]
        
        WebServiceHandler.performPOSTRequest(urlString: kUpdateURL, params: param ) { (result, error) in
            
            if (result != nil){
                let statusCode = result!["status"]?.string
                 let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                  
                
                }
                else{
                   // self.showAlertWithMessage("ALERT", msg!)
                }
                AppHelper.sharedInstance.removeSpinner()
            }
            else{
                AppHelper.sharedInstance.removeSpinner()
            }
        }
    }
        
}
extension MatchProfileViewController:CBPeripheralManagerDelegate{
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager!) {

        var statusMessage = ""

        switch peripheral.state {
        case .poweredOn:
            statusMessage = "Bluetooth Status: Turned On"

        case .poweredOff:
            statusMessage = "Bluetooth Status: Turned Off"

        case .resetting:
            statusMessage = "Bluetooth Status: Resetting"

        case .unauthorized:
            statusMessage = "Bluetooth Status: Not Authorized"

        case .unsupported:
            statusMessage = "Bluetooth Status: Not Supported"

        case .unknown:
            statusMessage = "Bluetooth Status: Unknown"
        }
        
        bluetoothState = statusMessage

        print(statusMessage)
        callUpdateApi()

        if peripheral.state == .poweredOff {
            //TODO: Update this property in an App Manager class
        }
    }
}

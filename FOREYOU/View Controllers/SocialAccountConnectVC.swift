//
//  SocialAccountConnectVC.swift
//  FOREYOU

import UIKit
import GoogleSignIn
import FBSDKLoginKit

import AuthenticationServices
import SwiftyJSON
import Alamofire
import AWSS3
import AWSCognito
import SCSDKCoreKit
import SCSDKLoginKit
import Firebase
import FirebaseUI
import HealthKit
import Alamofire
import CoreBluetooth
import Contacts

class SocialAccountConnectVC: BaseViewControllerClass,LoginWebViewControllerDelegate,WebViewControllerDelegate, TwitchWebViewControllerDelegate {
    
    
    func refreshData() {
        
    }
    var UserToken = "..."

    var stepData = NSMutableDictionary()
    var weightData = ""
    var heartBeat = 0.0
    var AppleId = ""
    var distanceData = 0.0
    var energyData = 0.0
    var twitch_AccessToken = ""
    var HealthDataList = [HealthData]()
    var TwitchVideoList = [TwichVideos]()
    var twitchId = ""
    var twitchName = ""
    var twitchLogo = ""
    var RedditAccessToken = ""
    var TwitchDataList = [TwitchData]()
    var RedditDataList = [RedditData]()
    var TwitchBlocklist = [TwitchBlockList]()
    var TwitchFollowedlist = [TwitchFollewedVideo]()
    var twitterFollowingDataArray = [[String:Any]]()
    var batteryLevel: Float { UIDevice.current.batteryLevel }
    var batteryState: UIDevice.BatteryState { UIDevice.current.batteryState }
    var batteryPercent = 0.0
    var RedditCommunitiesList = [RedditCommunities]()

    let healthStore = HKHealthStore()
    //MARK: - IBOutlets
    var backgroundTask: UIBackgroundTaskIdentifier?
    var  countdownTimer :Timer?
    
    let dispatchGroup = DispatchGroup()
    var redditDict:NSDictionary?
    var redditDataDict:NSDictionary?
    var contactData = [ContactData]()

    
    //MARK: - IBOutlets
    var twitchArray = [TwitchModel]()
    let options = [CBCentralManagerOptionShowPowerAlertKey:0] //<-this is the magic bit!

    //MARK: - Variables
    let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    var bluetoothPeripheralManager: CBPeripheralManager!
    //MARK: - Variables
    static var viewControllerId = "SignUpSocialsViewController"
    static var storyBoard = "Main"
    var webView = WKWebView()
    var songs = [Song]()
    var youtubeData = [YoutubeData]()
    var signalStrengthIndi = SignalStrengthIndicator()

    var developerToken = "eyJhbGciOiJFUzI1NiIsImtpZCI6IkJOUTdQUVc5OUMifQ.eyJpc3MiOiJRWTY4MzhCVzkzIiwiZXhwIjoxNjE2MjM5MDIyLCJpYXQiOjE2MTI0NTMyMDZ9.38L6g90FnPUJ-hQjCTFpqzGAMGlGHU3wHhABoHc5z-soVr57LFEN5ORjpLIoOCRlYCYlmw-GfHby_-SdB8-FAw"
    
    var musicToken = "Ah27iRoA/B2o+hEAk3jymohMjYujudl7Gk8JpTxQfuKVc9ahDGMrtGRgTpE3LYLvbfqxT/FkzkUvCiFGtuWaQWejQpHtg6Es3eWSByDF1sm2RQngND1DidRzZ2s2gtJ/xrS9TLsIFt66F6Adom/c2kFM5sDNIPdMCo2FrxFDLocJ7l9pnfxl49H3tvihKgX16j+jEdSPlYFLDgWOA04IJZsBsQw+dD8cm4fs7oGQPNJc9kvQyg=="
    var twittdata :JSON?
    var statusCount = 0
    var facebookData:SocialData!
    var googleData:SocialData!
    var twitterData:SocialData!
    var linkedinData:SocialData!
    var instagramData:SocialData!
    var spotifyData:SocialData!
    var appleData:SocialData!
    var bluetoothState = ""
    var wifiStatus = ""
    var wifiName = ""
    var batteryStatus = ""
    var NetworkStrength = ""
    //var tweetarr = [TwiitertwistData]()
    var twittertwistDataList = [TwiitertwistData]()
    var twitchModelDataList = [TwitchModel]()

    var TWitter_listArray = [[String:Any]]()
    var provider = OAuthProvider(providerID: "twitter.com")
    var TwitchModelDataList = [TwitchModel]()
    var twitchVideoListArray = [[String:Any]]()
    var TwichDataList = [TwichVideos]()
    var contact_listArray = [[String:Any]]()
    var photosData = [[String:String]]()
    var recentSongArray = [[String:Any]]()
    var instaArray = [[String:Any]]()
    var TwistterArray = [[String:Any]]()
    var youtubeDataArray = [[String:Any]]()
    var redditDataArray = [[String:Any]]()
    var spotifyRecentSongArray = [[String:Any]]()
    var twitterDataArray = [[String:Any]]()
    var twittsDataArray = [[String:Any]]()
    var twitchDataArray = [[String:Any]]()
    var twitchModelDataArray = [[String:Any]]()
    var twitchBlockListArray = [[String:Any]]()
    var redditCommunitiesListArray = [[String:Any]]()
    let tweetIDs = ["34","20","21","22","23","25","26","29","30","31","32","33"]
    var twitterFollowingDataList = [TwitterData]()
    var TwitchFollowedvideoListArray = [[String:Any]]()
    var limit =  10
    var offset = 1
    var spotifyRecentList = [SpotifyData]()
    var youtubeDataList = [YoutubeData]()
    
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnLinkedin: UIButton!
    @IBOutlet weak var btnInstagram: UIButton!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var btnSpotify: UIButton!
    @IBOutlet weak var btntwitch: UIButton!

    
    var radditId = ""
    var radditName = ""
    var radditLogo = ""
    @IBOutlet weak var btnAppleLogin: UIButton!
    
    var testUserData: InstagramTestUser?
    var instaData:InstaData?
    var isTwitterLogin = false
    var twitterAccessToken = "AAAAAAAAAAAAAAAAAAAAANFGJgEAAAAA0weHtfrlyS5jMtjxecofGnC3C7w%3D7WY3a1eRpNj7uHI6NjtYMm7JDjsEkrPGq77EZqO5TSc34uILfu"
    
    var twitterDataList = [TwitterData]()
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    var deselectTitle1String = "Deselect any accounts you don't want us to access We won't take it personally!"
    var selectTitle1String = "ForeYou can not work without knowing a little about you. Please select at least 2 accounts."
    
    var deselectTitle2String = "But the more we know about you, the better your matches and experience will be."
    var selectTitle2String = "Take a read what we do with your data here if you're unsure"
    
    var countryCode = "+1"
    var email = ""
    var mobile = ""
    var RelationStatus = ""
    var password = ""
    var gender = ""
    var lookingFor = ""
    
    let socialData = ["Facebook","Google","Twitter","Linkedin","Instagram"]
    var instagramLogin: InstagramSharedVC!
    
    var count = 0
    var healthDataArray = [[String:Any]]()
    var TwitchFollowedvideoList = [TwitchFollewedVideo]()
    var signal = -1

    var spotifyId = ""
    var spotifyDisplayName = ""
    var spotifyEmail = ""
    var spotifyAvatarURL = ""
    var spotifyAccessToken = ""
    var socialtypeselect:String = ""
    var socialid:String = ""

    //MARK: - LifeCycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        phoneNumberWithContryCode()
        setInitials()
        self.setNeedsStatusBarAppearanceUpdate()
        self.showStatusBar()
        facebookData = SocialData(dict: ["":""])
        googleData = SocialData(dict: ["":""])
        twitterData = SocialData(dict: ["":""])
        linkedinData = SocialData(dict: ["":""])
        instagramData = SocialData(dict: ["":""])
        spotifyData = SocialData(dict: ["":""])
        appleData = SocialData(dict: ["":""])
        let currentWifiStatus = fetchSSIDInfo()
        if currentWifiStatus != ""
        {
            wifiStatus = "Wifi Status: On"
            wifiName = currentWifiStatus
            
        }
        else
        {
            wifiStatus = "Wifi Status: Off"
            wifiStatus = currentWifiStatus
        }
        getSocialStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.instaData = InstaData(dict: ["media_Type":""])
        self.instaData?.user_name = ""
        self.instaData?.media_url = ""
    }
    
    //MARK: - Helpers
    func setInitials()
    {
        setDeselected(btn: btnFacebook)
        setDeselected(btn: btnGoogle)
        setDeselected(btn: btnTwitter)
        setDeselected(btn: btnLinkedin)
        setDeselected(btn: btnInstagram)
        setDeselected(btn: btnSpotify)
        setDeselected(btn: btnAppleLogin)
        setDeselected(btn: btntwitch)

     
        btnComplete.isEnabled = true

    }
   
    
    func setupTwitchVideoDataList()
    {
        print("DR",TwichDataList.count)
        var twitchDataList = [String:Any]()
        for data in TwitchVideoList{
            twitchDataList["url"] = data.url
            twitchDataList["title"] = data.title
            twitchDataList["views"] = data.views
            twitchDataList["game"] = data.game
            twitchDataList["published_at"] = data.published_at
            twitchVideoListArray.append(twitchDataList)

        }
        
        
        print("pppppp",twitchVideoListArray)
        
    }
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
        
        if peripheral.state == .poweredOff {
            //TODO: Update this property in an App Manager class
        }
    }
    func fetchRecentSong(userToeken:String){
        
var request = URLRequest(url: URL(string: "https://api.music.apple.com/v1/me/recent/played?limit=10"
)!,timeoutInterval: Double.infinity)
        request.addValue(userToeken, forHTTPHeaderField: "Music-User-Token")
        request.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            if let json = try? JSON(data: data) {
                let result = (json["data"]).array!
                for song in result {
                    let attributes = song["attributes"]
                    
                    var id = ""
                    var music_name = ""
                    var artistName = ""
                    var music_type = ""   //type
                    var releaseDate = ""
                    var record_Label = ""
                    var album_url = ""
                    var artworkURL = ""
                    var track_count = ""
                    var copyright = ""
                    var editorialNotes_standard = ""
                    var editorialNotes_short = ""
                    var genre = ""
                    
                    
                    if let ids = attributes["playParams"]["id"].string{
                        id = ids
                    }
                    if let names = attributes["name"].string{
                        music_name = names
                    }
                    if let artistNames = attributes["artistName"].string{
                        artistName = artistNames
                    }
                    if let artworkURLs = attributes["artwork"]["url"].string{
                        artworkURL = artworkURLs
                    }
                    if let type = song["type"].string{
                        music_type = type
                    }
                    if let releaseDates = attributes["releaseDate"].string{
                        releaseDate = releaseDates
                    }
                    if let album_urls = attributes["url"].string{
                        album_url = album_urls
                    }
                    if let record_Labels = attributes["recordLabel"].string{
                        record_Label = record_Labels
                    }
                    if let copyrights = attributes["copyright"].string{
                        copyright = copyrights
                    }
                    if let trackCounts = attributes["trackCount"].int{
                        track_count = "\(trackCounts)"
                    }
                    if let standards = attributes["editorialNotes"]["standard"].string{
                        editorialNotes_standard = standards
                    }
                    if let shorts = attributes["editorialNotes"]["short"].string{
                        editorialNotes_short = shorts
                    }
                    
                    if let genres = attributes["genreNames"].array{
                        genre = "\(genres)"
                    }
                    
                    let currentSong = Song(id: id, music_name: music_name, artistName: artistName, music_type: music_type, artworkURL: artworkURL, releaseDate: releaseDate, record_Label: record_Label, album_url: album_url, track_count: track_count, copyright: copyright, editorialNotes_standard: editorialNotes_standard, editorialNotes_short: editorialNotes_short, genre: genre)
                    //   let currentSong = Song(id: id, name: name, artistName: artistName, artworkURL: artworkURL)
                    self.songs.append(currentSong)
                }
                self.setupRecentSongList()
                
            } else {
                
            }
            
        }
        
        task.resume()
        
    }
    
    func setupRecentSongList(){
        var singleSong = [String:Any]()
        for song in songs{
            
            singleSong["id"] = song.id
            singleSong["name"] = song.music_name
            singleSong["artistName"] = song.artistName
            singleSong["artworkURL"] = song.artworkURL
            singleSong["music_type"] = song.music_type
            singleSong["releaseDate"] = song.releaseDate
            singleSong["record_Label"] = song.record_Label
            singleSong["album_url"] = song.album_url
            singleSong["track_count"] = song.track_count
            singleSong["copyright"] = song.copyright
            singleSong["editorialNotes_standard"] = song.editorialNotes_standard
            singleSong["editorialNotes_short"] = song.editorialNotes_short
            singleSong["genre"] = song.genre
            
            recentSongArray.append(singleSong)
        }
        print(recentSongArray)
    }
    
    func setuptwiitertwistList(){
        
        for object in self.twittertwistDataList{
            var singleData = [String:Any]()
            singleData["id"] = object.id
            singleData["text"] = object.text
            
            TwistterArray.append(singleData)
        }
    }
    
    
    func setupTwiterFollowingList(){
        
        for object in self.twitterFollowingDataList{
            var singleData = [String:Any]()
            singleData["id"] = object.id
            singleData["name"] = object.name
            singleData["username"] = object.username
            
            twitterFollowingDataArray.append(singleData)
        }
    }
    
    
    func setupInstaList(){
        var singleData = [String:Any]()
        singleData["media_url"] = instaData?.media_url
        singleData["media_type"] = instaData?.media_type
        singleData["user_name"] = instaData?.user_name
        instaArray.append(singleData)
    }
    
    func setupSpotifyRecentSongList(){
        var singleSong = [String:Any]()
        for song in spotifyRecentList{
            singleSong["id"] = song.id
            singleSong["name"] = song.music_name
            singleSong["artistName"] = song.artistName
            singleSong["type"] = song.type
            singleSong["album_name"] = song.album_name
            singleSong["releaseDate"] = song.releaseDate
            singleSong["totalTracks"] = song.totalTracks
            singleSong["musicUrl"] = song.musicUrl
            
            spotifyRecentSongArray.append(singleSong)
        }
        print(recentSongArray)
    }
    func setupYoutubeDataList(){
        youtubeDataArray.removeAll()
        var youtubedataList = [String:Any]()
        for data in youtubeDataList{
            youtubedataList["channel_id"] = data.channelId
            youtubedataList["channel_name"] = data.channelTitle
            youtubedataList["thumbnails"] = data.channelThumbnail
            youtubedataList["subscriberCount"] = data.subsCount
            youtubedataList["videoCount"] = data.videoCount
            youtubedataList["channel_Description"] = data.channelDescription
            youtubedataList["privacyStatus"] = data.privacyStatus
            youtubedataList["keywords"] = data.keywords
            youtubedataList["viewCount"] = data.viewCount
            youtubedataList["publishedAt"] = data.publishedAt
            youtubedataList["customUrl"] = data.channelUrl
            
            
            
        }
        youtubeDataArray.append(youtubedataList)
        
        print("pppppp",youtubeDataArray)
    }
    func doBackgroundTask() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.beginBackgroundTask()
            self.countdownTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.requestService), userInfo: nil, repeats: true)
            
            RunLoop.current.add(self.countdownTimer!, forMode: .common)
            
            RunLoop.current.run()
            
        }
        
    }
    
    func beginBackgroundTask() {
        self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            // you can't call endBackgroundTask here and you don't need to
            
        })
        
        assert(self.backgroundTask != UIBackgroundTaskIdentifier.invalid)
        
    }
    
    func endBackgroundTask() {
        if self.backgroundTask != nil {
            UIApplication.shared.endBackgroundTask(self.backgroundTask!)
            
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
            
        }
        
    }
    
    
    
    
    @objc func requestService() {
        callUpdateApi()
    }
    
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
                  
               self.navigationController?.popViewController(animated: true)

                    
                }
                else{
                    self.showAlertWithMessage("ALERT", msg!)
                }
               
            }
            else{
                
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
    
    override func viewDidAppear(_ animated: Bool) {
        signal =  getSignalStrength()
        if signal == 1{
            NetworkStrength = "Very Low"
        }else if signal == 2{
            NetworkStrength = "Low"
        }else if signal == 3{
            NetworkStrength = "Good"
        }else if signal == 4{
            NetworkStrength = "Excellent"
        }else
        {
            NetworkStrength = "Unknown"
        }
    }
    func getSignalStrenght(){
        print(signalStrengthIndi.level)
    }
    func getSignalStrength() -> Int
    {
        
        if #available(iOS 13.0, *){
            if let statusBarManager = UIApplication.shared.keyWindow?.windowScene?.statusBarManager,
               let localStatusBar = statusBarManager.value(forKey: "createLocalStatusBar") as? NSObject,
               let statusBar = localStatusBar.value(forKey: "statusBar") as? NSObject,
               let _statusBar = statusBar.value(forKey: "_statusBar") as? UIView,
               let currentData = _statusBar.value(forKey: "currentData")  as? NSObject,
               let celluar = currentData.value(forKey: "cellularEntry") as? NSObject,
               let signalStrength = celluar.value(forKey: "displayValue") as? Int {
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
                return signalStrength
            }
        }
        
    }
    func fetchBluetoothAndBatteryStatus(){
        UIDevice.current.isBatteryMonitoringEnabled = true
        print(batteryLevel)
        //  NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange(_:)), name: .UIDeviceBatteryLevelDidChange, object: nil)
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
        
    }
    @objc func batteryLevelDidChange(_ notification: Notification) {
        // self.infoLabel.text = "🔋:\(Int(batteryLevel*100))%"
    }
    func setupRedditDataList(){
        //print(redditData.count)
        var redditDataList = [String:Any]()
        for data in RedditDataList{
            redditDataList["userId"] = data.userId
            
            redditDataList["userName"] = data.userName
            redditDataList["IconImg"] = data.IconImg
            redditDataArray.append(redditDataList)

        }

        
        print("pppppp",redditDataArray)
    }
  
    
    func setupRedditCommunitiesDataList(){
        print(RedditCommunitiesList.count)
        var redditDataList = [String:Any]()
        for data in RedditCommunitiesList{
            redditDataList["userId"] = data.userId
            redditDataList["title"] = data.title
            redditDataList["URL"] = data.URL
            redditDataList["subscribers"] = data.subscribers
            redditDataList["displayName"] = data.displayName
            redditDataList["advertiser_category"] = data.advertiser_category
            redditDataList["public_description"] = data.public_description
            redditDataList["community_icon"] = data.community_icon
            redditDataList["subreddit_type"] = data.subreddit_type

            redditDataList["userName"] = data.userName
            redditDataList["IconImg"] = data.IconImg
            redditCommunitiesListArray.append(redditDataList)

        }

        print("pppppp",redditCommunitiesListArray)
    }
    func setupTwitchDataList(){
        twitchDataArray.removeAll()

        var singleData = [String:Any]()
        
        for data in TwitchDataList
        {
            print("$$$$",data)

            singleData["id"] = data.userId
            singleData["name"] = data.name
            singleData["bio"] = data.bio
            singleData["logo"] = data.logo
            
            twitchDataArray.append(singleData)


        }
         print(twitchDataArray)
       
    }
   
    func fetchTwitchModelData()
    {
        var singleData = [String:Any]()
        for data in twitchModelDataList
        {
            print("$$$$",data)
            singleData["ChannelType"] = data.game
            singleData["display_name"] = data.display_name
            singleData["logo"] = data.logo
            singleData["followers"] = data.followers
            singleData["profile_banner"] = data.profile_banner
            singleData["updated_at"] = data.updated_at
            singleData["views"] = data.views
            singleData["desc"] = data.desc
            singleData["status"] = data.status

        }
        twitchModelDataArray.append(singleData)
    }
    
    func setupTwitterDataList(){
        
        var singleData = [String:Any]()
        for data in twitterDataList{
            singleData["id"] = data.id
            singleData["name"] = data.name
            singleData["username"] = data.username
            
            twitterDataArray.append(singleData)
            
        }
      

    }
    
    func weatherService(accessToken:String) {
        for i in 0...9 {
            dispatchGroup.enter()
            
           
        let tokenURLFull =
                
                
      "https://api.music.apple.com/v1/me/recent/played?offset=\(offset)&limit=\(limit)"
            
            
            APIMusicManager.apiGet(serviceName: tokenURLFull, token: self.developerToken, usertoken: self.UserToken, counter: i){ (response:JSON?, error:NSError?, count:Int) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                //guard let response = response else { return }
                print("[executed] action \(count)")
                
                
                print(response)
                
                
                let result = response?["data"].array
                if result?.count ?? 0 > 0
                {
                for song in result!
                {
                    let attributes = song["attributes"]
                    var id = ""
                    var music_name = ""
                    var artistName = ""
                    var music_type = ""   //type
                    var releaseDate = ""
                    var record_Label = ""
                    var album_url = ""
                    var artworkURL = ""
                    var track_count = ""
                    var copyright = ""
                    var editorialNotes_standard = ""
                    var editorialNotes_short = ""
                    var genre = ""
                    if let ids = attributes["playParams"]["id"].string{
                        id = ids
                    }
                    if let names = attributes["name"].string{
                        music_name = names
                    }
                    if let artistNames = attributes["artistName"].string{
                        artistName = artistNames
                    }
                    if let artworkURLs = attributes["artwork"]["url"].string{
                        artworkURL = artworkURLs
                    }
                    if let type = song["type"].string{
                        music_type = type
                    }
                    if let releaseDates = attributes["releaseDate"].string{
                        releaseDate = releaseDates
                    }
                    if let album_urls = attributes["url"].string{
                        album_url = album_urls
                    }
                    if let record_Labels = attributes["recordLabel"].string{
                        record_Label = record_Labels
                    }
                    if let copyrights = attributes["copyright"].string{
                        copyright = copyrights
                    }
                    if let trackCounts = attributes["trackCount"].int{
                        track_count = "\(trackCounts)"
                    }
                    if let standards = attributes["editorialNotes"]["standard"].string{
                        editorialNotes_standard = standards
                    }
                    if let shorts = attributes["editorialNotes"]["short"].string{
                        editorialNotes_short = shorts
                    }
                    if let genres = attributes["genreNames"].array{
                        genre = "\(genres)"
                    }
                    
                    let currentSong = Song(id: id, music_name: music_name, artistName: artistName, music_type: music_type, artworkURL: artworkURL, releaseDate: releaseDate, record_Label: record_Label, album_url: album_url, track_count: track_count, copyright: copyright, editorialNotes_standard: editorialNotes_standard, editorialNotes_short: editorialNotes_short, genre: genre)
                    //   let currentSong = Song(id: id, name: name, artistName: artistName, artworkURL: artworkURL)
                    self.songs.append(currentSong)
                
                self.setupRecentSongList()
                
            }
                    

        }
           else
                {
                    // noting values
                }
                self.offset =  self.offset + 1
                self.dispatchGroup.leave()
            }
        }
    }
    func start(_accessToken:String) {
        weatherService(accessToken: _accessToken)
        dispatchGroup.notify(queue: .main) {
            print("All services complete")
        }
    }
    func fetchAppleMusicData(){
        
        
    AppleMusicAPI.sharedInstance.requestForUserToken{ userToken in
            self.UserToken = userToken
            self.start(_accessToken: self.UserToken)
            
          
            }
        
    }
    func setupTwitchVideoFollowedDataList()
    {
        print("DR",TwitchFollowedvideoList.count)
        var twitchDataList = [String:Any]()
        for data in TwitchFollowedvideoList{
            twitchDataList["id"] = data.userId
            twitchDataList["game"] = data.game
            
        
            let dict =  data.channel
            let status =  dict?["status"]?.stringValue
            let display_name =  dict?["display_name"]?.stringValue
            let game =  dict?["game"]?.stringValue
            let  _id =  dict?["_id"]?.int
            let  name =  dict?["name"]?.stringValue
            let  logo =  dict?["logo"]?.stringValue
            let  videobanner =  dict?["video_banner"]?.stringValue
            let  profilebanner =  dict?["profile_banner"]?.stringValue
            let  url =  dict?["url"]?.stringValue
            let  views =  dict?["views"]?.int
            let  followers =  dict?["followers"]?.int
             
            let description = dict?["description"]?.stringValue

            
      twitchDataList["status"] = status
      twitchDataList["display_name"] = display_name
      twitchDataList["game"] = game
      twitchDataList["_id"] = _id
      twitchDataList["name"] = name
      twitchDataList["logo"] = logo
      twitchDataList["videobanner"] = videobanner
      twitchDataList["profilebanner"] = profilebanner
      twitchDataList["url"] = url
      twitchDataList["views"] = views
      twitchDataList["followers"] = followers
      twitchDataList["description"] = description
      TwitchFollowedvideoListArray.append(twitchDataList)

        }
        
        
    print("FollowedVideo",TwitchFollowedvideoListArray)
        
    }
    func setupTwitchBlockDataList()
    {
        print("DR",TwitchBlocklist.count)
        var twitchDataList = [String:Any]()
        for data in TwitchBlocklist{
            twitchDataList["userId"] = data.userId
            twitchDataList["bio"] = data.bio
            twitchDataList["userName"] = data.userName
            twitchDataList["IconImg"] = data.IconImg
            twitchDataList["created_at"] = data.created_at
            twitchBlockListArray.append(twitchDataList)

        }
        
        
        print("pppppp",twitchBlockListArray)
    }
    func setupHealthDataList(){
        healthDataArray.removeAll()
        var healthDataList = [String:Any]()
        for data in HealthDataList{
            healthDataList["total_steps"] = data.StepsData
            healthDataList["total_distance"] = data.DistanceData
            healthDataList["heart_points"] = data.HeartBeat
            healthDataList["weight"] = data.WeightData
            healthDataList["calorie_burn"] = "0"

            
            
        }}
    
    
    
    
    
    @IBAction func twitchBtn(_ sender: Any)
        {
            
            
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let jumpvc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
            jumpvc!.delegate = self
            self.present(jumpvc!, animated: true, completion: nil)
            
        }
    
    
    func facebookTapped() {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email","user_birthday","user_location","user_hometown","user_gender","public_profile","user_photos,user_posts,user_likes"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,birthday,location,hometown,languages,quotes,sports,gender"]).start(completionHandler: { [self] (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result)
                    if let userDict = result as? NSDictionary {
                        let name = userDict["name"] as? String
                        let id = userDict["id"] as? String
                        let email = userDict["email"] as? String
                        let first_name = userDict["first_name"] as? String
                        let last_name = userDict["last_name"] as? String
                        
                        let data = SocialData(dict: ["id":id])
                        self.facebookData = data
                        self.facebookData.firstname = first_name!
                        self.facebookData.email = email!
                        self.facebookData.lastname = last_name!
                        callApi()
                        
                        
                        UserDetails.sharedInstance.facebookLoginID = id!
                        AppHelper.saveUserDetails()
                        self.setSelected(btn: self.btnFacebook)
                        self.count =  1
                        
                        
                        
                    }
                }else{
                    
                }
            })
        }
        GraphRequest(graphPath: "/me/feed", parameters: ["fields":"created_time,attachments,type,message"]).start(completionHandler: { (fbConnectionErr, result, error) in
            print(fbConnectionErr)
            print(result)
            print(error)
            let re = result as? [String: Any]
            let data = re?["data"] as! [[String: Any]]
            for dict in data {
                print(dict)
            }
        })
    }
    
    
    func twitterTapped() {
        
       
    }
   
    
    func twitterWithFirebase(){
        provider.getCredentialWith(nil) { credential, error in
              if error != nil {
                // Handle error.
              }
              if credential != nil {
                
                
                if credential != nil {
                    
                    
                    Auth.auth().signIn(with: credential!) { authResult, error in
                         if error != nil {
                           // Handle error.
                         }
                        
                        if let myDict = authResult?.additionalUserInfo?.profile as NSDictionary?{
                            print(myDict)
                            let username = myDict["screen_name"] as? String
                            self.getTwitterUserId(username: username!)
                            
                        }
                        
                       
                
                       }
                     }
                   }
                
                
              }
            }
   
    
   //MARK:- SIGNUP
    func callSignUpApi(){
        
        
        
        if self.TwitchDataList.count > 0{
            if let tId = self.TwitchDataList[0].userId{
                twitchId = tId
            }
            
            if let tName = self.TwitchDataList[0].name{
                
                twitchName = tName
            }
            if let tLogo = self.TwitchDataList[0].logo{
                
                twitchLogo = tLogo
            }
        }
        
        
        if self.redditDict !=  nil
        {
           
            self.radditId = redditDict?["id"] as? String ?? ""
            self.radditName = redditDict?["displayName"] as? String ?? ""
            self.radditLogo = redditDict?["iconImg"] as? String ?? ""
        }
       
      
      let param = ["app_type": AppType,
                 "email":email,
                 "device_type": "ios",
                 "device_token":  UserDetails.sharedInstance.pushnotificationtoken,
                 
                 "social_info" :[
                    "FACEBOOK": UserDetails.sharedInstance.facebookLoginID,
                    "TWITTER": UserDetails.sharedInstance.twitterLoginID,
                    "GOOGLE": UserDetails.sharedInstance.googleLoginID,
                    "LINKEDIN": UserDetails.sharedInstance.linkedinLoginID,
                    "INSTAGRAM": UserDetails.sharedInstance.instagramLoginID,
                    "APPLE": UserDetails.sharedInstance.appleLoginID,
                    "SPOTIFY": UserDetails.sharedInstance.spotifyLoginID,
                    "REDDIT": self.radditId,
                    "TWITCH": "\(twitchId)",
                    "PINTREST":""
                 ],"social_data":["TWITCH":[
                    "id":"\(twitchId)",
                    "firstname":"\(twitchName)",
                    "lastname" : "",
                    "profilePicture":"\(twitchLogo)"
                     
                 ],"REDDIT":[
                    "id":self.radditId,
                    "firstname":self.radditName,
                    "lastname" : "",
                    "profilePicture":self.radditLogo],
                 "FACEBOOK":[
                    "id":facebookData.id!,
                    "firstname":facebookData.firstname!,
                        "lastname":facebookData.lastname!,
                        "email":facebookData.email!,
                        "profilePicture":facebookData.profilePicture!
                         ],"TWITTER":[
                            "id":twitterData.id!,
                            "firstname":twitterData.firstname!,
                            "lastname":twitterData.lastname!,
                            "email":twitterData.email!,
                            "profilePicture":twitterData.profilePicture!,
                            "followersCount":"\(twitterDataArray.count)"
                          
                         ],"GOOGLE":[
                            "id":googleData.id!,
                            "firstname":googleData.firstname!,
                            "lastname":googleData.lastname!,
                            "email": googleData.email ,
                            "profilePicture":googleData.profilePicture!
                         ],"LINKEDIN":[
                            "id":linkedinData.id!,
                            "firstname":linkedinData.firstname!,
                            "lastname":linkedinData.lastname!,
                            "email":linkedinData.email!,
                            "profilePicture":linkedinData.profilePicture!
                         ],"INSTAGRAM":[
                            "id":instagramData.id!,
                            "firstname":instagramData.firstname!,
                            "lastname":instagramData.lastname!,
                            "email":instagramData.email!,
                            "profilePicture":instagramData.profilePicture!
                         ],"APPLE":[
                            "id":appleData.id!,
                            "firstname":appleData.firstname!,
                            "lastname":appleData.lastname!,
                            "email":appleData.email!,
                            "profilePicture":appleData.profilePicture!
                         ],"SPOTIFY":[
                            "id":spotifyData.id!,
                            "firstname":spotifyData.firstname!,
                            "lastname":spotifyData.lastname!,
                            "email":spotifyData.email!,
                            "profilePicture":spotifyData.profilePicture!,
                            "playListCount":"\(spotifyRecentSongArray.count)"
                         ],"PINTREST": []
           
                 
                 ],"contact_list":[],"usage_data":["APPLE_TV_DATA":[],"TWITTER_FOLLOWING_DATA":twitterFollowingDataArray,"MEDIA_DATA":photosData, "TWITTER_TWEETS_DATA":TwistterArray, "INSTAGRAM_DATA":instaArray,"SPOTIFY_DATA":spotifyRecentSongArray,"TWITTER_DATA":twitterDataArray,"APPLE_MUSIC_DATA":recentSongArray,"TWITCH_TOP_VIDEOS_LIST":twitchVideoListArray,
                "TWITCH_FOLLOWED_VIDEOS_LIST":TwitchFollowedvideoListArray
                ,"YOUTUBE_CHANNEL_LIST":youtubeDataArray
             ,"APPLE_FITNESS_DATA":healthDataArray,
            "REDDIT_NEW_USER_LIST":redditDataArray,
        "TWITCH_DATA_USER_FOLLOWS":twitchModelDataArray,
       
        "REDDIT_MY_COMMUNITIES_LIST": redditCommunitiesListArray,"BATTERY_CHARGING_STATUS":["state":"\(batteryStatus)","percent":"\(batteryPercent)"],"BLUETOOTH_CONNECTIVITY_STATUS":["state":bluetoothState],"WIFI_CONNECTIVITY_STATUS":["status":wifiStatus,"name":wifiName],"POTENTIALLY_SIGNAL_STRENGTH_CONNECTIVITY_STATUS":["status":"\(NetworkStrength)","value":"\(signal)" ]
            
        ]
    ]
as [String : Any]
    print(param)
    
    
WebServiceHandler.performPOSTRequest(urlString: kSignUp4URL, params: param ) { (result, error) in
        
        if (result != nil){
            let statusCode = result!["status"]?.string
             let msg = result!["msg"]?.string
            if statusCode == "200"
            {
               
                self.callUpdateApi()
               
            }
            else{
                self.showAlertWithMessage("ALERT", msg!)
            }
            
        }
        else{
           
        }
    }
}
        
           
func setupContactList(){
        var singleContact = [String:Any]()
        for contact in contactData{
            singleContact["f_name"] = contact.f_name
            singleContact["l_name"] = contact.l_name
            singleContact["company_name"] = contact.company_name
            singleContact["phone"] = contact.phone
            singleContact["email"] = contact.email
            singleContact["address"] = contact.address
            singleContact["dob"] = contact.dob
            singleContact["social_profile_data"] = ["":""]
            contact_listArray.append(singleContact)
        }
        print(contact_listArray)
    }
    
    func phoneNumberWithContryCode() { //-> [[String:String]] {
        
        let contacts = PhoneContacts.getContacts() // here calling the getContacts methods
        var arrPhoneNumbers = [[String:String]]()
        
        for contact in contacts {
            
            var firstName = "\(contact.givenName)"
            // firstName = encode(firstName)
            firstName = encodeToBase64(str: firstName)
            var temp = firstName
            //  firstName = decodeToBase64(str: temp)
            var lastName = "\(contact.familyName)"
            lastName = encodeToBase64(str: lastName)
            var companyName = "\(contact.organizationName)"
            companyName = encodeToBase64(str: companyName)
            var PhoneNumber = ""
            var Email = ""
            var Birthday = ""
            var fullAddress = ""
            
            for ContctNumVar: CNLabeledValue in contact.phoneNumbers {
                if let fulMobNumVar  = ContctNumVar.value as? CNPhoneNumber {
                    //let countryCode = fulMobNumVar.value(forKey: "countryCode") get country code
                    if let MccNamVar = fulMobNumVar.value(forKey: "digits") as? String {
                        
                        //let obj = ["\(contact.givenName + " " + contact.familyName)":"\(MccNamVar)"]
                        PhoneNumber = "\(MccNamVar)"
                        //arrPhoneNumbers.append(obj)
                    }
                }
            }
            
            for EmailAddress: CNLabeledValue in contact.emailAddresses {
                if let email = EmailAddress.value as? String{
                    Email = email
                }
                
                print(email)
            }
            if contact.birthday != nil{
                var year = ""
                var month = ""
                var day = ""
                if let tYear = contact.birthday!.year{
                    year = "\(tYear)"
                }
                if let tMonth = contact.birthday!.month{
                    month = "\(tMonth)"
                }
                if let tDay = contact.birthday!.day{
                    day = "\(tDay)"
                }
                
                let birthday = "\(day)-\(month)-\(year)"
                Birthday = birthday
            }
            
            
            for Address: CNLabeledValue in contact.postalAddresses {
                if let completeAddress  = Address.value as? CNMutablePostalAddress {
                    var street = ""
                    var subLocality = ""
                    var city = ""
                    var subAdminsitrativeArea = ""
                    var state = ""
                    var postalCode = ""
                    var country = ""
                    if let astreet = completeAddress.street as? String{
                        street = astreet
                    }
                    if let asubLocality = completeAddress.subLocality as? String{
                        subLocality = asubLocality
                    }
                    if let acity = completeAddress.city as? String{
                        city = acity
                    }
                    if let asubAdminsitrativeArea = completeAddress.subAdministrativeArea as? String{
                        subAdminsitrativeArea = asubAdminsitrativeArea
                    }
                    if let astate = completeAddress.state as? String{
                        state = astate
                    }
                    if let apostalCode = completeAddress.postalCode as? String{
                        postalCode = apostalCode
                    }
                    if let acountry = completeAddress.country as? String{
                        country = acountry
                    }
                    fullAddress = "\(street) \(city) \(state) \(postalCode) \(country)"
                    print(fullAddress)
                }
                
                print(email)
            }
            
            let dict = ["f_name":firstName,"l_name":lastName,"company_name":companyName,"phone":PhoneNumber,"email":Email,"address":fullAddress,"dob":Birthday]
            let data = ContactData(dict: dict as NSDictionary)
            contactData.append(data)
        }
        
        
        setupContactList()
///return arrPhoneNumbers // here array has all contact numbers.
    }
    func fetchSpotifyProfile(accessToken: String) {
        let tokenURLFull = "https://api.spotify.com/v1/me"
        let verify: NSURL = NSURL(string: tokenURLFull)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let result = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                //AccessToken
                print("Spotify Access Token: \(accessToken)")
                self.spotifyAccessToken = accessToken
                //Spotify Handle
                let spotifyId: String! = (result?["id"] as! String)
                let email = (result?["email"] as! String)
                let first_name = (result?["display_name"] as! String)
                print("Spotify Id: \(spotifyId ?? "")")
                self.spotifyId = spotifyId
                
                let data = SocialData(dict: ["id":spotifyId])
                self.spotifyData = data
                self.spotifyData?.firstname = first_name
                self.spotifyData?.email = email
                //   facebookData?.lastname = last_name!
                self.showAlertWithMessage("Success", "Successfully Connected")
                UserDetails.sharedInstance.spotifyLoginID = spotifyId
                AppHelper.saveUserDetails()
                DispatchQueue.main.async {
                    self.setSelected(btn: self.btnSpotify)
                    
                    self.setString()
                }
                //Spotify Display Name
                self.count =  1
                let spotifyDisplayName: String! = (result?["display_name"] as! String)
                print("Spotify Display Name: \(spotifyDisplayName ?? "")")
                self.spotifyDisplayName = spotifyDisplayName
                //Spotify Email
                let spotifyEmail: String! = (result?["email"] as! String)
                print("Spotify Email: \(spotifyEmail ?? "")")
                self.spotifyEmail = spotifyEmail
                //Spotify Profile Avatar URL
                let spotifyAvatarURL: String!
                let spotifyProfilePicArray = result?["images"] as? [AnyObject]
                if (spotifyProfilePicArray?.count)! > 0 {
                    //   spotifyAvatarURL = spotifyProfilePicArray![0]["url"] as? String
                } else {
                    spotifyAvatarURL = "Not exists"
                }
                //  print("Spotify Profile Avatar URL: \(spotifyAvatarURL ?? "")")
                //   self.spotifyAvatarURL = spotifyAvatarURL
                
            }
        }
        task.resume()
    }
    func setString(){
    if( count == 1)
    {
            view1.isHidden = false
            view3.isHidden = false
            view2.isHidden = true
            view4.isHidden = true
            btnComplete.backgroundColor = UIColor.black
            btnComplete.isEnabled = true
    }
    }
    
    func fetchSpotifyRecentlyPlayed(accessToken: String) {
        var limit = 50
        let tokenURLFull = "https://api.spotify.com/v1/me/player/recently-played?limit=\(limit)"
        let verify: NSURL = NSURL(string: tokenURLFull)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let result = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                //AccessToken
                if let recentData = result?["items"]{
                    let dict = ["recentData":recentData]
                    if let apiData = dict["recentData"] as? Array<Any>{
                        for element in apiData{
                            var music_name = ""
                            var id = ""
                            var type = ""
                            var album_name = ""
                            var releaseDate = ""
                            var totalTracks = ""
                            var artistName = ""
                            var musicUrl = ""
                            
                            if let trackData = element as? NSDictionary{
                                print(trackData["track"])
                                if let track = trackData["track"] as? NSDictionary{
                                    music_name = track["name"] as! String
                                    id = track["id"] as! String
                                    if let album = track["album"] as? NSDictionary{
                                        type = album["type"] as! String
                                        album_name = album["name"] as! String
                                        releaseDate = album["release_date"] as! String
                                        totalTracks = "\(album["total_tracks"] as! Int)"
                                    }
                                    
                                    if let artist = track["artists"] as? Array<Any>{
                                        for i in artist{
                                            if let artdata = i as? NSDictionary{
                                                artistName = artdata["name"] as! String
                                            }
                                        }
                                    }
                                    if let external_urls = track["external_urls"] as? NSDictionary{
                                        musicUrl = external_urls["spotify"] as! String
                                    }
                                    
                                }
                                let singleData = SpotifyData(dict: ["id":id])
                                singleData.album_name = album_name
                                singleData.artistName = artistName
                                singleData.musicUrl = musicUrl
                                singleData.music_name = music_name
                                singleData.releaseDate = releaseDate
                                singleData.totalTracks = totalTracks
                                singleData.type = type
                                
                                print(singleData)
                                self.spotifyRecentList.append(singleData)
                                self.setupSpotifyRecentSongList()
                            }
                        }
                    }
                    print(recentData)
                }
                
            }
        }
        task.resume()
    }
    
    func encodeToBase64(str:String) -> String{
        let utf8str = str.data(using: .utf8)
        var base64String = ""
        if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
            print("Encoded: \(base64Encoded)")
            base64String = "\(base64Encoded)"
            
        }else{
            
        }
        return base64String
    }
    
    func loadTwitterFollowingData(id:String){
        
        let param = [String:Any]()
        var headers: HTTPHeaders
        headers = ["Authorization":"Bearer \(twitterAccessToken)"]
        let url = "https://api.twitter.com/2/users/\(id)/following?max_results=1000"
        WebServiceHandler.performGETRequest(withURL: url, header: headers ) { (result, error) in
            
            if (result != nil){
                let statusCode = result!["status"].string
                
                if let users = result!["data"].array{
                    self.twitterFollowingDataList = TwitterData.getAllTwitterListArray(twitterArray: users)
                    print(self.twitterDataList)
                }
                
                print(self.twitterDataList)
            
                let msg = result!["msg"].string
                if statusCode == "200"
                {
                }
                
            }
            
        }
    }
    
    func loadTwitterUserData(id:String){
        
        let param = [String:Any]()
        var headers: HTTPHeaders
        headers = ["Authorization":"Bearer \(twitterAccessToken)"]
        let url = "https://api.twitter.com/1.1/users/show.json?user_id=\(id)"
        WebServiceHandler.performGETRequest(withURL: url, header: headers ) { (result, error) in
            
            if (result != nil)
            {
                let statusCode = result!["status"].string
                self.statusCount = result!["statuses_count"].int ?? 0
                let msg = result!["msg"].string
                if statusCode == "200"
                {
                }
                
            }
            
        }
    }
    
    
    func getTwitterUserId(username:String){
        
        let param = [String:Any]()
        var headers: HTTPHeaders
        headers = ["Authorization":"Bearer \(twitterAccessToken)"]
        let url = "https://api.twitter.com/2/users/by/username/\(username)"
        WebServiceHandler.performGETRequest(withURL: url, header: headers ) { (result, error) in
            
            if (result != nil)
            {
                let statusCode = result!["status"].string
                self.statusCount = result!["statuses_count"].int ?? 0
                let msg = result!["msg"].string
                 let myData = result!["data"]
                let id = myData["id"].string
                let name = myData["name"].string
                let username = myData["username"].string
                
                let data = SocialData(dict: ["id":id])
                self.twitterData = data
                self.twitterData?.firstname = username
                self.twitterData?.lastname = username
                
                UserDetails.sharedInstance.twitterLoginID = id!
                if self.isTwitterLogin == false{
                    self.count =  1
                    
                    self.isTwitterLogin = true
                }
                
                AppHelper.saveUserDetails()
                
                
                self.setSelected(btn: self.btnTwitter)
                
                self.loadTwitterFollowersData(id: id!)
                self.loadTwitterFollowingData(id: id!)
                
                self.loadTwittertwittsData(id: id!)
                }
                
                
            }
            
        }
    
    
    func loadTwitterFollowersData(id:String){
        
        let param = [String:Any]()
        var headers: HTTPHeaders
        headers = ["Authorization":"Bearer \(twitterAccessToken)"]
        let url = "https://api.twitter.com/2/users/\(id)/followers?max_results=1000"
        WebServiceHandler.performGETRequest(withURL: url, header: headers ) { (result, error) in
            
            if (result != nil){
                let statusCode = result!["status"].string
                
                if let users = result!["data"].array{
                    self.twitterDataList = TwitterData.getAllTwitterListArray(twitterArray: users)
                    print( self.twitterDataList)
                }
                print( self.twitterDataList)
                let msg = result!["msg"].string
                if statusCode == "200"
                {
                }
                
            }
            
        }
    }
    
    
    
        
        func loadTwittertwittsData(id:String)
        {
            var Urlstring:String?
            let param = [String:Any]()
            var headers: HTTPHeaders
            headers = ["Authorization":"Bearer \(twitterAccessToken)"]
            
            Urlstring = "https://api.twitter.com/2/users/\(id)/tweets?max_results=100"
            
            //let url = "https://api.twitter.com/2/users/\(id)/tweets?exclude=retweets"
            WebServiceHandler.performGETRequest(withURL: Urlstring!, header: headers ) { (result, error) in
  
                if (result != nil){
                    if let users = result!["data"].array {
                        
                        self.twittertwistDataList  = TwiitertwistData.getAllTwitterListArray(twitterArray: users)
                        print(self.twittertwistDataList)
                        
                    }
                    
                    let metadict =  result!["meta"].dictionaryValue
                    
                    if let nexttoken  =  metadict["next_token"]?.stringValue
                    {

                    }
                    
                    print(self.twittertwistDataList)
                    
                }
            }
 
            print(self.twittertwistDataList)

        }
        
    
    
    
    
    func presentTwitchWebViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let webVC = storyBoard.instantiateViewController(withIdentifier: "TwitchWebViewController") as! TwitchWebViewController
        webVC.delegate = self
       // webVC.instagramApi = self.instagramApi
       // webVC.mainVC = self
        self.present(webVC, animated:true)
    }
    
    
    func gotToken(token: String) {
        print(RedditAccessToken)
        
        self.setSelected(btn: self.btnInstagram)
        self.count =  1
        
        self.RedditAccessToken = token
        loadRedditData()
        loadRedditFriendsData()
    }
    
   
func InstagramTapped() {
        let controller = LoginWebViewController.instantiateFromStoryBoard()
        //  self.navigationController?.pushViewController(vc!, animated: true)
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
        /*
         instagramLogin = InstagramSharedVC.init(clientId: Constants.clientId, redirectUri: Constants.redirectUri) { (token, error) in
         UserDefaults.standard.set(token ?? "", forKey: "instUserID")
         
         self.instagramLogin.dismiss(animated: true, completion: {
         self.getAllPhotosFromInstagram()
         })
         }
         present(UINavigationController(rootViewController: instagramLogin), animated: true)
         */
        
    }
    
    
    
    fileprivate func getAllPhotosFromInstagram() {
        
        InstagramUserProfile.shared.getInstagramPhotoWithUrl(comptionBlock: { (aryAllPhotos, status) in
            
            if status {
                print(aryAllPhotos)
            }else{
                print("failed to fetch post")
            }
        })
    }
    
     
    
    
    
    func refreshData(data: InstagramTestUser,instaData: InstaData) {
        
        let data = SocialData(dict: ["id":data.user_id])
        
        self.instaData = instaData
        instagramData = data
        // googleData?.firstname = data.!
        // googleData?.email = email!
        //  googleData?.lastname = familyName!
        DispatchQueue.main.async {
            self.setSelected(btn: self.btnInstagram)
            self.count =  1
            
        }
    }
    
    @IBAction func btnViewPersonalityMatrixAction(_ sender: Any) {
        
    }
    func snapchattap()
    {
        SCSDKLoginClient.login(from: self, completion: { success, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if success {
                // self.fetchSnapUserInfo() //example code
            }
        })
    }
    //    private func fetchSnapUserInfo(){
    //        let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
    //        SCSDKLoginClient
    //            .fetchUserData(
    //                withQuery: graphQLQuery,
    //                variables: nil,
    //                success: {
    //                    userInfo in
    ////                    if let userInfo = userInfo,
    ////                        let data = try? JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted),
    ////                        let userEntity = try? JSONDecoder().decode(UserEntity.self, from: data) {
    ////                        DispatchQueue.main.async {
    ////                            self.goToLoginConfirm(userEntity)
    ////                        }
    //                    }
    //            }) { (error, isUserLoggedOut) in
    //                print(error?.localizedDescription ?? "")
    //        }
    //    }
    func spotifyAuthVC() {
        // Create Spotify Auth ViewController
        let spotifyVC = UIViewController()
        // Create WebView
        let webView = WKWebView()
        webView.navigationDelegate = self
        spotifyVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: spotifyVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: spotifyVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: spotifyVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: spotifyVC.view.trailingAnchor)
        ])
        
        let authURLFull = "https://accounts.spotify.com/authorize?response_type=token&client_id=" + SpotifyConstants.CLIENT_ID + "&scope=" + SpotifyConstants.SCOPE + "&redirect_uri=" + SpotifyConstants.REDIRECT_URI + "&show_dialog=false"
        
        let urlRequest = URLRequest.init(url: URL.init(string: authURLFull)!)
        webView.load(urlRequest)
        
        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: spotifyVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        spotifyVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.reffreshAction))
        spotifyVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        spotifyVC.navigationItem.title = "spotify.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        // navController.navigationBar.barTintColor = UIColor.colorFromHex("#1DB954")
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical
        
        self.present(navController, animated: true, completion: nil)
    }
    func getSocialStatus()
    {
        
        let param = ["app_type": AppType,
                     "user_id":UserDetails.sharedInstance.userID
                     
            ] as [String : Any]
        
        WebServiceHandler.performPOSTRequest(urlString: kSocialConnectURL, params: param ) { (result, error) in
            
            if (result != nil){
                let statusCode = result!["status"]?.string
                let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                    
                 let social_connect_status = result!["social_connect_status"]?.array
                    
                    for item in social_connect_status!
                    {
                        if item["name"] == "LINKEDIN"
                        {
                            self.socialtypeselect =  item["name"].stringValue
                             
                           if item["status"].int == 1
                            {
                            self.setSelected(btn: self.btnLinkedin)
                            }
                        }
                        if item["name"] == "FACEBOOK"
                        {
                           if item["status"].int == 1
                            {
                            self.socialtypeselect =  item["name"].stringValue
                            self.setSelected(btn: self.btnFacebook)
                            }
                        }
                        if item["name"] == "TWITTER"
                        {
                           if item["status"].int == 1
                            {
                            self.socialtypeselect =  item["name"].stringValue
                            self.setSelected(btn: self.btnTwitter)
                            }
                        }
                        if item["name"] == "INSTAGRAM"
                        {
                           if item["status"].int == 1
                            {
                            self.socialtypeselect =  item["name"].stringValue
                            self.setSelected(btn: self.btnInstagram)
                            }
                        }
                        if item["name"] == "APPLE"
                        {
                           if item["status"].int == 1
                            {
                            self.socialtypeselect =  item["name"].stringValue
                            self.setSelected(btn: self.btnAppleLogin)
                            }
                        }
                        if item["name"] == "GOOGLE"
                        {
                            
                           if item["status"].int == 1
                            {
                            self.socialtypeselect =  item["name"].stringValue
                            self.setSelected(btn: self.btnGoogle)
                            }
                        }
                        if item["name"].stringValue == "SPOTIFY"
                        {
                           if item["status"].int == 1
                            {
                            self.setSelected(btn: self.btnSpotify)
                            }
                        }
                        if item["name"] == "REDDIT"
                        {
                           if item["status"].int == 1
                            {
                            self.socialtypeselect =  item["name"].stringValue
                            self.setSelected(btn: self.btnInstagram)
                            }
                        }
                        if item["name"] == "TWITCH"
                        {
                           if item["name"].int == 1
                            {
                            self.socialtypeselect =  item["name"].stringValue
                            self.setSelected(btn: self.btntwitch)
                            }
                        }
                        
                    }
                    self.showAlertWithMessage("ALERT", msg!)

                       
                        
                    }
                }
               
            else
            {
                self.showAlertWithMessage("ALERT", "")
              
            }
        }
    }
    
    
    func removeSocialConection()
    {
      
        let param = ["app_type": AppType,
                     "user_id":UserDetails.sharedInstance.userID,
                     
                     "type": "" ,//FACEBOOK/TWITTER/GOOGLE/LINKEDIN/INSTAGRAM/PINTREST
                       "id": "" //id of the social account
            ] as [String : Any]
        
        WebServiceHandler.performPOSTRequest(urlString: kremovesocialurl, params: param ) { (result, error) in
            
            if (result != nil){
                let statusCode = result!["status"]?.string
                let msg = result!["msg"]?.string
                if statusCode == "200"
                {
                   
                     self.showAlertWithMessage("ALERT", msg!)
                

                    }
                 else {
                    
                }
                }
               
            else
            {
                self.showAlertWithMessage("ALERT", "")
               
            }
        }
    }
    
    func setSelected(btn:UIButton) {
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.borderColor = UIColor.black
        btn.backgroundColor = Colors.ORANGE_COLOR
    }
    func setDeselected(btn:UIButton) {
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.borderColor = UIColor.lightGray
        btn.backgroundColor = UIColor.white
    }
    
    @IBAction func bckBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnFacebookAction(_ sender: Any)
    {
        facebookTapped()
        
    }
    @IBAction func btnGoogleAction(_ sender: Any)
    {
        googleTapped()
        
    }
    
    @IBAction func btnTwitterAction(_ sender: Any)
    {
       // twitterTapped()
        twitterWithFirebase()
        
    }
    
    @IBAction func btnLinkedinAction(_ sender: Any) {
        
        callApi()
    }
    @IBAction func btnInstagramAction(_ sender: Any) {
        // InstagramTapped()
        //presentWebViewController()
        self.presentTwitchWebViewController()
    }
    
    @IBAction func btnSnapchatTap(_ sender: Any) {
        snapchattap()
        //callApi()
    }
    @IBAction func btnSpotifyTapped(_ sender: Any) {
        spotifyAuthVC()
       
    }
    func callApi()
    {
    setupSpotifyRecentSongList()
    setupInstaList()
    setupTwitterDataList()
    setuptwiitertwistList()
    setupYoutubeDataList()
    setupRedditDataList()
    setupTwiterFollowingList()
    setupHealthDataList()
    setupTwitchDataList()
    setupTwitchBlockDataList()
    setupTwitchVideoDataList()
    setupTwitchVideoFollowedDataList()
    setupRedditCommunitiesDataList()
    fetchAppleMusicData()
    fetchBluetoothAndBatteryStatus()
    self.showStatusBar()
    
  //  print(allContacts)
    let currentWifiStatus = fetchSSIDInfo()
    if currentWifiStatus != ""
    {
        wifiStatus = "Wifi Status: On"
        wifiName = currentWifiStatus
        
    }else{
        wifiStatus = "Wifi Status: Off"
        wifiStatus = currentWifiStatus
    }
    
   
    }
    @IBAction func btnCompleteAction(_ sender: Any) {

        callSignUpApi()
        // self.push(controller)
    }
    
    @IBAction func btnAppleLoginAction(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            
            authorizationController.delegate = self
            
            authorizationController.presentationContextProvider = self
            
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    
   func presentWebViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let webVC = storyBoard.instantiateViewController(withIdentifier: "webView") as! WebViewController
        webVC.delegate = self
        
        
        // webVC.instagramApi = self.instagramApi
        // webVC.mainVC = self
        self.present(webVC, animated:true)
    }
    
}

extension SocialAccountConnectVC : GIDSignInDelegate{
    
    
    func googleTapped() {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/youtube")
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID
            // For client-side use only!
            print(userId)
            let idToken = user.authentication.idToken
            print("ID",user.authentication.idToken)
            print("A.T",user.authentication.accessToken)
            
            // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            self.count = 1
            getyoutubeData(userId: user.authentication.accessToken! ?? "")
            let data = SocialData(dict: ["id": userId])
            googleData = data
            googleData?.firstname = givenName!
            googleData?.email = email!
            googleData?.lastname = familyName!
            
            UserDetails.sharedInstance.googleLoginID = user.userID!
            AppHelper.saveUserDetails()
            
            self.setSelected(btn: self.btnGoogle)
            
            // ...
        } else {
            
        }
    }
    func getyoutubeData(userId : String)
    {
        let param = [String:Any]()
        var headers: HTTPHeaders
        headers = ["Authorization":"Bearer \(userId)","Accept":"application/json"]
        let url =     "https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2CbrandingSettings%2Cstatistics%2CcontentOwnerDetails%2Clocalizations%2Cstatus&mine=true&key=452669675710-o4kh4n83252mlbs7f0vasu7ui0fqqvnp.apps.googleusercontent.com"
        WebServiceHandler.performGETRequest(withURL: url, header: headers ) { (result, error) in
            print(result)
            
            if (result != nil)
            {
                var itemData = result!["items"].array
                print(itemData)
                
                for (key) in itemData!
                {
                    let cId = key["id"].string
                    
                    let data = YoutubeData(dict: ["id":cId])
                    let snippetData = key["snippet"].dictionary
                    
                    data.channelId = cId
                    let channelDescription = snippetData?["description"]?.string ?? ""
                    data.channelDescription = channelDescription
                    data.channelTitle = snippetData?["title"]?.string ?? ""
                    data.publishedAt = snippetData?["publishedAt"]?.string ?? ""
                    data.channelUrl = "https://www.youtube.com/c/\(snippetData?["customUrl"]?.string ?? "")/videos"
                    
                    
                    let channelThumbnail = snippetData?["thumbnails"]?.dictionary
                    let mediumThumbnil = channelThumbnail?["medium"]?.dictionary
                    data.channelThumbnail = mediumThumbnil?["url"]?.string
                    let statsDict = key["statistics"].dictionary
                    let brandsDict = key["brandingSettings"].dictionary
                    let statusDict = key["status"].dictionary
                    data.privacyStatus = statusDict?["privacyStatus"]?.string
                    let channelDta = brandsDict?["channel"]?.dictionary
                    data.keywords = channelDta?["keywords"]?.string
                    data.subsCount = statsDict?["subscriberCount"]?.string
                    data.videoCount = statsDict?["videoCount"]?.string
                    data.viewCount = statsDict?["viewCount"]?.string
                    
                    self.youtubeDataList.append(data)
                    print("***",self.youtubeDataList)
                    
                }}
            
            
            
        }
        callApi()
    }
    
    func signIn(_ signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func signIn(_ signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

@available(iOS 13.0, *)
extension SocialAccountConnectVC: ASAuthorizationControllerPresentationContextProviding {
    
    //For present window
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
        
    }
    
}
@available(iOS 13.0, *)
extension  SocialAccountConnectVC: ASAuthorizationControllerDelegate {
    
    // ASAuthorizationControllerDelegate function for authorization failed
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print(error.localizedDescription)
        
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Create an account as per your requirement
            
            let appleId = appleIDCredential.user
            
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            
            let appleUserLastName = appleIDCredential.fullName?.familyName
            
            let appleUserEmail = appleIDCredential.email
            
            let data = SocialData(dict: ["id":appleId])
            
            AppleId = appleId
            
            appleData.id =  appleId
            if let appleUserName = appleUserFirstName{
                appleData?.firstname = appleUserName
            }
            if let appleEmail = appleUserEmail{
                appleData?.email = appleEmail
            }
            if let appleLastName = appleUserLastName{
                appleData?.lastname = appleLastName
            }
            
            
            
            UserDetails.sharedInstance.appleLoginID = appleId
            AppHelper.saveUserDetails()
            setSelected(btn: btnAppleLogin)
            self.count =  1
           
            
            //Write your code
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            
            let appleUsername = passwordCredential.user
            
            let applePassword = passwordCredential.password
            
            //Write your code
            
        }
        
    }}
    
    extension SocialAccountConnectVC: WKNavigationDelegate {
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            RequestForCallbackURL(request: navigationAction.request)
            decisionHandler(.allow)
        }
        
        func RequestForCallbackURL(request: URLRequest) {
            // Get the access token string after the '#access_token=' and before '&token_type='
            let requestURLString = (request.url?.absoluteString)! as String
            if requestURLString.hasPrefix(SpotifyConstants.REDIRECT_URI) {
                if requestURLString.contains("#access_token=") {
                    if let range = requestURLString.range(of: "=") {
                        let spotifAcTok = requestURLString[range.upperBound...]
                        if let range = spotifAcTok.range(of: "&token_type=") {
                            let spotifAcTokFinal = spotifAcTok[..<range.lowerBound]
                            handleAuth(spotifyAccessToken: String(spotifAcTokFinal))
                        }
                    }
                }
            }
        }
        
        func handleAuth(spotifyAccessToken: String) {
            fetchSpotifyProfile(accessToken: spotifyAccessToken)
        fetchSpotifyRecentlyPlayed(accessToken: spotifyAccessToken)
            
           /// self.start(_accessToken: spotifyAccessToken)
            
            // Close Spotify Auth ViewController after getting Access Token
            self.dismiss(animated: true, completion: nil)
        }
        
        
        func loadRedditData(){
            
            let param = [String:Any]()
            var headers: HTTPHeaders
            headers = ["Authorization":"Bearer \(self.RedditAccessToken)"]
            let url = "https://oauth.reddit.com/api/v1/me"
            WebServiceHandler.performGETRequest(withURL: url, header: headers ) { (result, error) in
                
                if (result != nil){
                    let statusCode = result!["status"].string
                    
                    var id = ""
                    var iconImg = ""
                    var displayName = ""
                    
                    id = result!["id"].stringValue
                      
                    
                    
                    if let dict = result!["subreddit"].dictionary{
                        if let kIconImg = dict["icon_img"]?.stringValue{
                            iconImg = kIconImg
                        }
                        
                        if let kDisplayName = dict["display_name"]?.stringValue{
                            displayName = kDisplayName
                        }
                    }
                    self.redditDict = ["id":id,"iconImg":iconImg,"displayName":displayName]
                    print(self.redditDict)
                    self.setupRedditDataList()
                    self.loadRedditFriendsData()
                    self.loadRedditSubredditData()
                }
                
            }
        }
        
        
        
        func loadRedditFriendsData(){
            
            let param = [String:Any]()
            var headers: HTTPHeaders
            headers = ["Authorization":"Bearer \(self.RedditAccessToken)"]
            let url = "https://oauth.reddit.com//users/new"
            WebServiceHandler.performGETRequest(withURL: url, header: headers ) { (result, error) in
                
                           
                                
                                let dataArr = result?["data"].dictionary
                                let childData = dataArr?["children"]?.array
                                print("&&&&&&&&&&&",childData)
                if childData?.count ?? 0 > 0
                {
                    self.RedditDataList = []
                                for item in childData!
                               {

                                    let dataDic = item["data"].dictionaryValue
                                    let api =  RedditData.init(dict: dataDic)
                                    self.RedditDataList.append(api)

                                }
                                print("*******",self.RedditDataList)
                    self.setupRedditDataList()
                }
        }
        }
        func loadRedditSubredditData(){
            
            let param = [String:Any]()
            var headers: HTTPHeaders
            headers = ["Authorization":"Bearer \(self.RedditAccessToken)"]
            print(headers)
            let url = "https://oauth.reddit.com//subreddits/mine/subscriber"
            WebServiceHandler.performGETRequest(withURL: url, header: headers ) { (result, error) in
                
                let dataArr = result?["data"].dictionary
                let childArr = dataArr?["children"]?.array
                if childArr?.count ?? 0 > 0
                {
                    self.RedditCommunitiesList = []
                for item in childArr!
                {
                    let dataDic = item["data"].dictionaryValue
                    let api =  RedditCommunities.init(dict: dataDic)
                    self.RedditCommunitiesList.append(api)
                }
                print("%%%%%%",result)
                }
            }
            self.setupRedditCommunitiesDataList()
                
            }
        
        
        func getTwitchData(twitchArray: [TwitchData],token:String) {
            self.showAlertWithMessage("Success", "Successfully Connected")
            self.setSelected(btn: self.btntwitch)
            //self.count = self.count + 1
            self.setString()
            self.twitch_AccessToken = token
            
            self.TwitchDataList = twitchArray
            
            getTwitchFollowData(id:twitchArray[0].userId!,accessToken:self.twitch_AccessToken)
            getTwitchBlockList(id:twitchArray[0].userId!,accessToken:self.twitch_AccessToken)
            getTwitchVideoList(id:twitchArray[0].userId!,accessToken:self.twitch_AccessToken)
            getTwitchVideoFollowedList(id:twitchArray[0].userId!,accessToken:self.twitch_AccessToken)
            setupTwitchDataList()
            fetchTwitchModelData()
            setupTwitchBlockDataList()
            setupTwitchVideoDataList()
            setupTwitchVideoFollowedDataList()
            
        }
        
        
        
        
        func getTwitchFollowData(id:String,accessToken : String)
        {
            var headers = [
                "Accept":"application/vnd.twitchtv.v5+json",
                "Authorization": "OAuth \(accessToken)",
                "Client-ID":"y47rvrma2t6pp1t7hglw55dtosjqlw"
                //"":""
            ]
            WebServiceHandler.performGETRequest(withURL:  "https://api.twitch.tv/kraken/users/\(id)/follows/channels", header: headers) {(result,error) in
                
                if result == nil{return}
                let data = ["data": JSON(result!)]
                if (result != nil)
                {
                    if let follows = result!["follows"].array{
                        for i in follows{
                            let twitchData = TwitchModel.parseTwitchData(details: i["channel"])
                            
                            //print(twitchData)
                            self.twitchArray.append(twitchData)
                           // print(self.twitchArray)
                            self.twitchModelDataList.append(contentsOf: self.twitchArray)

                        }
                    }
                   // self.twitchModelDataList.append(contentsOf: self.twitchArray)
                   //
                    print(result!)
                    let user_id = result!["user_id"].string
                    
                    
                }
            }
        
            
        }
        
        
        func getTwitchVideoFollowedList(id:String,accessToken : String)
        {
          
            let headers = [
              "Accept":"application/vnd.twitchtv.v5+json",
              "Client-ID":"y47rvrma2t6pp1t7hglw55dtosjqlw",
              "Authorization": "OAuth \(accessToken)"
              
          ]
          
          WebServiceHandler.performGETRequest(withURL:  "https://api.twitch.tv/kraken/streams/followed?stream_type=live&offset=0&limit=25", header: headers) {(result,error) in
              
              if result == nil{return}
              let data = ["data": JSON(result!)]
              if (result != nil)
              {
                  let dataArr = result?["streams"].array
                  print("Video list",dataArr)
                  if dataArr?.count ?? 0 > 0
                  {
                    self.TwitchFollowedlist = []
                     
                        for item in dataArr!
                            {
                            let channeldict =  item.dictionaryValue
                            let api =  TwitchFollewedVideo.init(dict: channeldict)
                            
                           /// let dict =   api.channel
                            
                             self.TwitchFollowedlist.append(api)
                            
                             }
                                  print("*******", self.TwitchFollowedlist)
                  }
              }
              }

        }
        
      func getTwitchVideoList(id:String,accessToken : String)
      {
        
        var headers = [
            "Accept":"application/vnd.twitchtv.v5+json",
            "Client-ID":"y47rvrma2t6pp1t7hglw55dtosjqlw",
            "Authorization": "OAuth \(accessToken)"
            
        ]
        
        WebServiceHandler.performGETRequest(withURL:  "https://api.twitch.tv/kraken/videos/top?offset=0&limit=25&stream_type=all", header: headers) {(result,error) in
            
            if result == nil{return}
            let data = ["data": JSON(result!)]
            if (result != nil)
            {
                let dataArr = result?["streams"].array
                print("Video list",dataArr)
                if dataArr?.count ?? 0 > 0
                {
                    self.TwitchVideoList = []
                                for item in dataArr!
                               {
                                    
                                    
                                   // let dataDic = item["data"].dictionaryValue
                                    let api =  TwichVideos.init(dict: item)
                                 ///   let  api =  TwitchVideoList(date)
                                                        
                                    self.TwitchVideoList.append(api)

                   }
                   /// self.callSignUpApi()
                    print("*******",self.TwitchVideoList)
                }
            }
            }

      }
        func getTwitchBlockList(id:String,accessToken : String)
        {
            var headers = [
                "Accept":"application/vnd.twitchtv.v5+json",
                "Authorization": "OAuth \(accessToken)",
                "Client-ID":"y47rvrma2t6pp1t7hglw55dtosjqlw"
                //"":""
            ]
            
            WebServiceHandler.performGETRequest(withURL:  "https://api.twitch.tv/kraken/users/\(id)/blocks", header: headers) {(result,error) in
                
                if result == nil{return}
                let data = ["data": JSON(result!)]
                if (result != nil)
                {
                    let dataArr = result?["blocks"].array
                    
                   print("Block list",dataArr)
                    
                    if dataArr?.count ?? 0 > 0
                    {
                        self.TwitchBlocklist = []
                                    for item in dataArr!
                                   {
                                        
                                        let dataDic = item["user"].dictionaryValue
                                        let api =  TwitchBlockList.init(dict: dataDic)
                                                            
                                        self.TwitchBlocklist.append(api)

                                   
                                        
                                    }
                                    print("*******",self.TwitchBlocklist)
                    }
                }
            }
    }
            
        
        @objc func cancelAction() {
            self.dismiss(animated: true, completion: nil)
        }
        
        @objc func reffreshAction() {
            self.webView.reload()
        }
    }


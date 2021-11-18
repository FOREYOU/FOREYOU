//
//  TwitchModel.swift
//  FOREYOU
//
//  Created by Vikas Kushwaha on 04/03/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON

class TwitchModel: NSObject {
    
    
    var status = ""
    var display_name = ""
     var  game = ""
    var  updated_at = ""
    var  logo = ""
    var followers = ""
    var profile_banner = ""
    var views = ""
    var desc = ""
    var channelName : Dictionary = ["":""]
   
    class func getAllTwitchListArray(twitchArray:[JSON]) -> Array<TwitchModel>{
            var paymentDataArray = Array<TwitchModel>()
            for elements in twitchArray{
                let dataDetails = TwitchModel.parseTwitchData(details: elements)
                paymentDataArray.append(dataDetails)
            }
            return paymentDataArray
        }
        
        class func parseTwitchData(details:JSON) -> TwitchModel{
            let dataDetails = TwitchModel()
           
            dataDetails.status = details["status"].string ?? ""
            dataDetails.display_name =   details["display_name"].string ??  ""
            dataDetails.desc = details["description"].string ?? ""
            dataDetails.game =   details["game"].string ??  ""
            dataDetails.updated_at = details["updated_at"].string ?? ""
            dataDetails.logo =   details["logo"].string ??  ""
            dataDetails.followers = "\(details["followers"].int ?? 0)"
            dataDetails.profile_banner =   details["profile_banner"].string ??  ""
            dataDetails.views = "\(details["views"].int ?? 0)"
           print(dataDetails)
           
            return dataDetails
        }

}

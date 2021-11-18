//
//  TwitchFollewedVideo.swift
//  FOREYOU
//
//  Created by Dj on 10/03/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON
class TwitchFollewedVideo: NSObject {
    var userId:String?
    var game:String?
    var IconImg:String?
    var channel:[String:JSON]?
    var bio:String?
        var created_at:String?

        
        init(dict:[String : JSON])
        {
            userId = dict["_id"]?.string
            game = dict["game"]?.string
            channel = dict["channel"]?.dictionaryValue
           // bio = dict["bio"]?.string
           // created_at = dict["created_at"]?.string
        }
}

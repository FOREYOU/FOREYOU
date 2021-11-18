//
//  HealthData.swift
//  FOREYOU
//
//  Created by Apple on 03/03/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON

class TwitchBlockList : NSObject {
var userId:String?
var userName:String?
var IconImg:String?
var bio:String?
    var created_at:String?

    
    init(dict:[String : JSON])
    {
        userId = dict["id"]?.string
        IconImg = dict["logo"]?.string
        userName = dict["display_name"]?.string
        bio = dict["bio"]?.string
        created_at = dict["created_at"]?.string
    }
}

//
//  HealthData.swift
//  FOREYOU
//
//  Created by Apple on 03/03/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON

class RedditData : NSObject {
var userId:String?
var userName:String?
var IconImg:String?

    
    init(dict:[String : JSON])
    {
        userId = dict["id"]?.string
        IconImg = dict["icon_img"]?.string
        userName = dict["display_name"]?.string
               
    }
}

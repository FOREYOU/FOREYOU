//
//  HealthData.swift
//  FOREYOU
//
//  Created by Apple on 03/03/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

class TwitchData : NSObject {
var name:String?
var userId:String?
var bio:String?
var logo:String?

init(dict:NSDictionary){
    name = dict["name"] as? String ?? ""
    userId = dict["userId"] as? String ?? ""
    bio=dict["bio"] as? String ?? ""
    logo = dict["logo"] as? String ?? ""
    //totalFollowing = dict["totalFollowing"] as? String ?? ""
}
}

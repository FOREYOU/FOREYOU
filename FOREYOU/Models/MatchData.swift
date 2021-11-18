//
//  MatchData.swift
//  FOREYOU
//
//  Created by Apple on 20/04/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON
class MatchData: NSObject {
    
    static let sharedInstance = MatchData()
    var firstName = ""
    
    var lastName: String?
    var profile_image: [JSON]?
    var address:String?
    var userId:String?
    var emailId:String?
    var is_locked:String?
    var user_distance:String?
    
    var match_percentage:String?
     
    
    func setJson(json:JSON)
       {
        
        firstName = json["user_firstname"].stringValue
        lastName = json["user_lastname"].stringValue
        profile_image = json["user_profile_pic"].arrayValue
        address = json["user_location"].stringValue
        userId = json["user_id"].stringValue
        emailId = json["user_email"].stringValue
        is_locked = json["is_locked"].stringValue
        user_distance = json["user_distance"].stringValue
        match_percentage = json["match_percentage"].stringValue

      
    }
}

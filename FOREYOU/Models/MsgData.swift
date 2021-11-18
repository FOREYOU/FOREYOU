//
//  MsgData.swift
//  FOREYOU
//
//  Created by Apple on 27/04/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON
class MsgData: NSObject {
    
    static let sharedInstance = MsgData()
    var message_text = ""
    var reciveData:NSMutableDictionary = [:]
    var senderData:NSMutableDictionary = [:]
    var receiver_user_id:String? = ""
    var sender_user_id:String? = ""

     
    
    func setJson(json:JSON)
       {
        
        message_text = json["message_text"].stringValue
        reciveData = json["rec"] as? NSMutableDictionary ?? ["":""]
        senderData = json["sender"] as? NSMutableDictionary ?? ["":""]
        sender_user_id = json["sender_user_id"].stringValue
        receiver_user_id = json["receiver_user_id"].stringValue

      
    }
}

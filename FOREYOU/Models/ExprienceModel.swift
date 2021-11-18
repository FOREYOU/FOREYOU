//
//  ExprienceModel.swift
//  FOREYOU
//
//  Created by Mac MIni on 16/07/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON
class ExprienceModel: NSObject {
    
    var venue_id:String?
    var venue_name:String?
    var venue_logo:String?
    var event_id:String?
    var event_image :String?
    var  event_date :String?
    var  event_time :String?
    var  event_title :String?
    var event_desc :String?
    var event_url :String?
    var event_name :String?
    var category:String?
   
  
     
    init(dict:[String : JSON])
        {
        venue_id = dict["venue_id"]?.string
        venue_name = dict["venue_name"]?.string
        venue_logo = dict["venue_logo"]?.string
        event_id = dict["event_id"]?.string
        event_image = dict["event_image"]?.string
        event_date = dict["event_date"]?.string
        event_time = dict["event_time"]?.string
        event_title = dict["event_title"]?.string
        event_desc = dict["event_desc"]?.string
        event_url = dict["event_url"]?.string
        event_name = dict["event_name"]?.string
        category = dict["category"]?.string
        
        }
}

//
//  matrixModel.swift
//  FOREYOU
//
//  Created by Mac MIni on 07/09/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON
class matrixModel: NSObject {
    var name:String?
    var value:String?
    var status:Int?
    var id:Int?
    var value_desc : String?
    var desc : String?
    
    
    init(json:JSON) {
         
        name  = json["name"].string
        value =  json["value"].string
        status  = json["status"].int
        id =  json["id"].int
        value_desc =  json["value_desc"].string
        desc =  json["desc"].string
    }
    
}

//
//  TwichVideos.swift
//  FOREYOU
//
//  Created by Dj on 09/03/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON
class TwichVideos: NSObject {
    var url:String?
    var title:String?
    var views:String?
    var game:String?
    var published_at:String?


    
     init(dict:JSON)
        {
        url = dict["url"].string
        title = dict["title"].string
        views = dict["views"].string
        game = dict["game"].string
        published_at = dict["published_at"].string
        }
    }



//
//  HealthData.swift
//  FOREYOU
//
//  Created by Apple on 03/03/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON

class RedditCommunities : NSObject {
var userId:String?
var userName:String?
var IconImg:String?
var title:String?
var URL: String?
var subscribers:String?
var name:String?
var displayName:String?
var advertiser_category:String?
var public_description:String?
var community_icon:String?
var subreddit_type:String?
    init(dict:[String : JSON])
    {
        userId = dict["id"]?.string
        IconImg = dict["icon_img"]?.string
        displayName = dict["display_name"]?.string
        title = dict["title"]?.string
        URL = "https://www.reddit.com/\(displayName ?? ""))"
        subscribers = dict["subscribers"]?.string
        userName = dict["name"]?.string
        advertiser_category = dict["advertiser_category"]?.string
        public_description = dict["public_description"]?.string
        community_icon = dict["community_icon"]?.string
        subreddit_type = dict["subreddit_type"]?.string

    }
}

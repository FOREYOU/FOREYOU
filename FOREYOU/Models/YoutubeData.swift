//
//  YoutubeData.swift
//  FOREYOU
//
//  Created by Apple on 19/02/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

class YoutubeData: NSObject {
    
    var channelDescription:String?
    var channelTitle:String?
    var channelThumbnail:String?
    var channelId:String?
    var statsDict:String?
    var subsCount:String?
    var videoCount:String?
    var viewCount:String?
    var publishedAt:String?
    var channelUrl:String?
    var privacyStatus:String?
    var keywords:String?

    init(dict:NSDictionary){
        channelDescription=dict["channelDescription"] as? String ?? ""
        channelTitle = dict["channelTitle"] as? String ?? ""
        channelThumbnail=dict["channelThumbnail"] as? String ?? ""
        channelId = dict["channelId"] as? String ?? ""
        statsDict=dict["statsDict"] as? String ?? ""
        subsCount=dict["subsCount"] as? String ?? ""
        videoCount=dict["videoCount"] as? String ?? ""
        privacyStatus=dict["privacyStatus"] as? String ?? ""
        keywords=dict["keywords"] as? String ?? ""
        viewCount=dict["viewCount"] as? String ?? ""

        //musicUrl=dict["musicUrl"] as? String ?? ""
    }
}

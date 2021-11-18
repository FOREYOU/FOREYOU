//
//  TwitterData.swift
//  FOREYOU
//
//  Created by Vikas Kushwaha on 08/02/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON

class TwitterData: NSObject {
    
    var id:String = ""
    var name:String = ""
    var screen_name:String = ""
    var listed_count:String = ""
    var followers_count:String = ""
    var favourites_count:String = ""
    var profile_image_url:String = ""
    var friends_count:String = ""
    var username = ""
    
    class func getAllTwitterListArray(twitterArray:[JSON]) -> Array<TwitterData>{
        var paymentDataArray = Array<TwitterData>()
        for elements in twitterArray{
            let dataDetails = TwitterData.parseTwitterData(details: elements)
            paymentDataArray.append(dataDetails)
        }
        return paymentDataArray
    }
    
    class func parseTwitterData(details:JSON) -> TwitterData{
        let dataDetails = TwitterData()
       
        dataDetails.name = details["name"].string ?? ""
        dataDetails.id = details["id"].string ?? ""
        dataDetails.username = details["username"].string ?? ""
        dataDetails.screen_name = details["screen_name"].string ?? ""
        dataDetails.listed_count = "\(details["listed_count"].int ?? 0)"
        
        dataDetails.followers_count = "\(details["followers_count"].int ?? 0)"
        dataDetails.favourites_count = "\(details["favourites_count"].int ?? 0)"
        dataDetails.profile_image_url = details["profile_image_url"].string ?? ""
        dataDetails.friends_count =  "\(details["friends_count"].int ?? 0)"
        
        return dataDetails
    }
}

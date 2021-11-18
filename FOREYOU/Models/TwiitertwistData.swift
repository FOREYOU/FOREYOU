//
//  TwiitertwistData.swift
//  FOREYOU
//
//  Created by Dj on 14/02/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit
import SwiftyJSON
class TwiitertwistData: NSObject {
    var text:String?
    var id:String?
   
    class func getAllTwitterListArray(twitterArray:[JSON]) -> Array<TwiitertwistData>{
            var paymentDataArray = Array<TwiitertwistData>()
            for elements in twitterArray{
                let dataDetails = TwiitertwistData.parseTwitterData(details: elements)
                paymentDataArray.append(dataDetails)
            }
            return paymentDataArray
        }
        
        class func parseTwitterData(details:JSON) -> TwiitertwistData{
            let dataDetails = TwiitertwistData()
           
            dataDetails.text = details["text"].string ?? ""
            dataDetails.id =   details["id"].string ??  ""
           
            return dataDetails
        }
    }
    


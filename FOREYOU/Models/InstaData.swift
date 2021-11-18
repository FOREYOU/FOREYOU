//
//  InstaData.swift
//  FOREYOU
//
//  Created by Vikas Kushwaha on 08/02/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import Foundation
class InstaData: NSObject
{
    var id: String?
    var media_url: String?
    var user_name: String?
    var media_type: String?

    
    init(dict:NSDictionary) {
        id = dict["id"] as? String ?? ""
        media_url = dict["media_url"] as? String ?? ""
        user_name=dict["user_name"] as? String ?? ""
        media_type = dict["media_type"] as? String ?? ""

    }
}

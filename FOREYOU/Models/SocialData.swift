//
//  SocialData.swift
//  FOREYOU
//
//  Created by Vikas Kushwaha on 14/01/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

class SocialData: NSObject {
    
    var id:String?
    var firstname:String?
    var lastname:String?
    var email:String?
    var profilePicture:String?
    
    init(dict:NSDictionary){
        id=dict["id"] as? String ?? ""
        firstname = dict["firstname"] as? String ?? ""
        lastname=dict["lastname"] as? String ?? ""
        email = dict["email"] as? String ?? ""
        profilePicture=dict["profilePicture"] as? String ?? ""
    }

}

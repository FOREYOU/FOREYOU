//
//  ContactData.swift
//  FOREYOU
//
//  Created by Vikas Kushwaha on 14/01/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

class ContactData: NSObject {

    var f_name:String?
    var l_name:String?
    var company_name:String?
    var phone:String?
    var email:String?
    var address:String?
    var dob:String?
    
    init(dict:NSDictionary){
        f_name=dict["f_name"] as? String ?? ""
        l_name = dict["l_name"] as? String ?? ""
        company_name=dict["company_name"] as? String ?? ""
        email = dict["email"] as? String ?? ""
        phone=dict["phone"] as? String ?? ""
        address=dict["address"] as? String ?? ""
        dob=dict["dob"] as? String ?? ""
    }

}

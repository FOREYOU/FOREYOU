//
//  WebServiceHandler.swift
//  Posh_IT
//
//  Created by Vikash Rajput on 3/8/18.
//  Copyright © 2018 Vikash Rajput. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
class WebServiceHandler: NSObject {
    
    class func performGETRequest(withURL urlString: String,header: HTTPHeaders, completion completionBlock: @escaping (_ result: JSON?, _ error: Error?) -> Void) {
        
        SVProgressHUD.setForegroundColor(UIColor.blue)
         //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        
        //HUD Color
        SVProgressHUD.setStatus("Please wait ....")
        SVProgressHUD.show(withStatus: "Please wait...")
        
        SVProgressHUD.show()
       
        
        print(urlString);
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
      
        var headers: HTTPHeaders
        
        if header == nil{
            headers = [
                "Content-Type":"application/json"
                //"":""
            ]
        }else{
            headers = header
        }
           
        Alamofire.request(urlString, method : .get, parameters : nil, encoding : JSONEncoding.default , headers : headers).responseData { dataResponse in
            
            let statusCode = dataResponse.response?.statusCode
            
            SVProgressHUD.dismiss()
            if statusCode == 200{ 
                let responseJSON = JSON(dataResponse.data!)
                print(responseJSON)
                if responseJSON.dictionary != nil{
                    let statusCodeOnResponse = responseJSON.dictionary!["status"]?.string
                    completionBlock(responseJSON, dataResponse.error)

                    if statusCodeOnResponse == "200" {
                    
                    }
                    else if statusCodeOnResponse == "801"{
                     
                    }
                    else{
                        completionBlock(responseJSON, dataResponse.error)
                    }
                }
                else{
                    print(dataResponse.error?.localizedDescription ?? "HTTP Error")
                    completionBlock(nil, dataResponse.error)
                }
            }
            else{
              //  print(dataResponse.error?.localizedDescription ?? "HTTP Error")
             //   completionBlock(nil, dataResponse.error)
            }
        }
    }
    
    
    class func performPOSTRequest(urlString: String?, params: Parameters?, completion completionBlock: @escaping (_ result: [String: JSON]?, _ error: Error?) -> Void) {
 
        SVProgressHUD.setForegroundColor(UIColor.black)
         //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        //HUD Color
        
        SVProgressHUD.show(withStatus: "Please wait...")

        
        SVProgressHUD.show()
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        var headers: HTTPHeaders
        
            headers = [
                "Content-Type":"application/json"
                //"":""
            ]
    
        print(params!)
        
        Alamofire.request(urlString!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
        
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
                
            }
            .validate { request, response, data in
                return .success
            }
            .responseString { response in

                
                let statusCode = response.response?.statusCode
                
                SVProgressHUD.dismiss()
                
                if statusCode == 200{
                    
                    
                    let responseJSON = JSON(response.data as AnyObject);
                    
                    print("responseJSON::", responseJSON)
                    
                    if let statusCodeOnResponse = responseJSON.dictionary?["status"]?.string{
                        if statusCodeOnResponse == "200" {
                            if let userDetails = responseJSON.dictionary!["this_user"] {
                                do {
                                    let data = try userDetails.rawData()
                                } catch let error as NSError {
                                    print("Could not save. \(error), \(error.userInfo)")
                                }
                            }
                            completionBlock(responseJSON.dictionary, nil)
                        }
                        else if statusCodeOnResponse == "801"{
                   
                        }
                        else{
                            completionBlock(responseJSON.dictionary, nil)
                        }
                    }
                    else{
                        completionBlock(nil, response.error)
                    }
                }
                else{
                    completionBlock(nil, response.error)
                }
        }
    }
    
    
    class func performPOSTRequestWithForm(urlString: String?, params: Parameters?, completion completionBlock: @escaping (_ result: [String: JSON]?, _ error: Error?) -> Void) {
        
      
        SVProgressHUD.setForegroundColor(UIColor.black)
         //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        //HUD Color
        SVProgressHUD.setStatus("Please wait ....")
        
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        
        
        print(params!)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params! {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        
        }, usingThreshold: UInt64.init(), to: urlString!, method: .post, headers: headers) { (result) in
            
            SVProgressHUD.dismiss()
            switch result{
            
        
            case .success(let upload, _, _):
                upload.responseJSON { response in

                    if response.error != nil{
                        completionBlock(nil, response.error)
                        return
                    }
                    
                    let statusCode = response.response?.statusCode
                    if statusCode == 200{
                        let responseJSON = JSON(response.data as AnyObject);
                        print(responseJSON)
                        completionBlock(responseJSON.dictionary, nil)
                    }else{
                        completionBlock(nil, response.error)
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completionBlock(nil, error)
            }
        
        
        
     
        }
    }

    
    class func performMultipartRequest(urlString: String?, fileName: String, params: Parameters?, imageDataArray: Array<Data>?, completion completionBlock: @escaping (_ result: [String: JSON]?, _ error: Error?) -> Void) {
        
        SVProgressHUD.setForegroundColor(UIColor.black)
         //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        //HUD Color
        SVProgressHUD.show(withStatus: "Please wait...")

        
        SVProgressHUD.show()
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        
          let headers: HTTPHeaders = [
            "":""
          ]
        
        print(params!)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params! {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if imageDataArray != nil{
                var count = 0
                for data in imageDataArray!{
                    var imageName = fileName
                    imageName = imageName + "[" + String(count) + "]"
                    if count != 0{
                       
                    }
                    else{
                     //   imageName = imageName + ".png"
                    }
                    multipartFormData.append(data, withName: imageName, fileName: "imageName.png", mimeType: "image/jpeg")
                    count += 1
                }
            }
        }, usingThreshold: UInt64.init(), to: urlString!, method: .post, headers: headers) { (result) in
            
            SVProgressHUD.dismiss()
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    
                    if response.error != nil{
                        completionBlock(nil, response.error)
                        return
                    }
                    

                    let statusCode = response.response?.statusCode
                    if statusCode == 200{
                        let responseJSON = JSON(response.data as AnyObject);
                        print("responseJSON::", responseJSON)
                        
                        let statusCodeOnResponse = responseJSON.dictionary!["status"]?.string
                        /*
                        if !UserDetails.sharedInstance.isLiveServerUpdate{
                            let serverTimestemp = responseJSON.dictionary!["server_timestamp"]?.stringValue
                            UserDetails.sharedInstance.isLiveServerUpdate = true
                            UserDetails.sharedInstance.serverTimeStemp = serverTimestemp ?? "0"
                        }
                        */
                        
                        if statusCodeOnResponse == "200" {
                            
                            if let userDetails = responseJSON.dictionary!["this_user"] {
                                
                                do {
                                    let data = try userDetails.rawData()
                                    //AppHelper.updateValueInCoreData(urlString: userDetailsUrl, resultData: data)
                                    /*
                                    if let savedUserJson = AppHelper.getValueFromCoreData(urlString: userDetailsUrl){
                                        UserDetails.sharedInstance.getAllUserDetails(details: savedUserJson)
                                    }
                                    */
                                } catch let error as NSError {
                                    print("Could not save. \(error), \(error.userInfo)")
                                }
                            }
                            
                            completionBlock(responseJSON.dictionary, nil)

                        }
                        else if statusCodeOnResponse == "801"{
                
                        }
                        else{
                            completionBlock(responseJSON.dictionary, nil)
                        }
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completionBlock(nil, error)
            }
        }
    }
}



extension String {
    
//    static func ==(lhs: String, rhs: String) -> Bool {
//        return lhs.compare(rhs, options: .numeric) == .orderedSame
//    }
//    
    static func <(lhs: String, rhs: String) -> Bool {
        return lhs.compare(rhs, options: .numeric) == .orderedAscending
    }
    
//    static func <=(lhs: String, rhs: String) -> Bool {
//        return lhs.compare(rhs, options: .numeric) == .orderedAscending || lhs.compare(rhs, options: .numeric) == .orderedSame
//    }
//
//    static func >(lhs: String, rhs: String) -> Bool {
//        return lhs.compare(rhs, options: .numeric) == .orderedDescending
//    }
//
//    static func >=(lhs: String, rhs: String) -> Bool {
//        return lhs.compare(rhs, options: .numeric) == .orderedDescending || lhs.compare(rhs, options: .numeric) == .orderedSame
//    }
    
}
 

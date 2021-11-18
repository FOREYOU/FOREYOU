//
//  AppleMusicAPI.swift
//  MusicPlayer
//
//  Created by Sai Kambampati on 5/30/20.
//  Copyright © 2020 Sai Kambmapati. All rights reserved.
//

import Foundation
import StoreKit
import SwiftyJSON
class AppleMusicAPI {
    
    static let sharedInstance = AppleMusicAPI()
    let developerToken = "eyJhbGciOiJFUzI1NiIsImtpZCI6IkJOUTdQUVc5OUMifQ.eyJpc3MiOiJRWTY4MzhCVzkzIiwiZXhwIjoxNjE2MjM5MDIyLCJpYXQiOjE2MTI0NTMyMDZ9.38L6g90FnPUJ-hQjCTFpqzGAMGlGHU3wHhABoHc5z-soVr57LFEN5ORjpLIoOCRlYCYlmw-GfHby_-SdB8-FAw"
    
  
    
    var cloudServiceController:SKCloudServiceController?
    
    var userToken = ""
    var storeFrontId = ""

    
    
    func getUserToken(completion: @escaping(_ userToken: String) -> Void) {
        SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { (userToken, error) in
              guard error == nil else {
                   return
              }
            completion(userToken!)
        }
    }
    
    func requestForUserToken(completion: @escaping(_ userToken: String) -> Void){
        SKCloudServiceController.requestAuthorization { [weak self] (authorizationStatus) in
            
            switch authorizationStatus {
            case .authorized:
                
                print("Authorized")
                
                self?.cloudServiceController = SKCloudServiceController()
                self!.cloudServiceController!.requestUserToken(forDeveloperToken: self!.developerToken) { (userToken, error) in
                    if userToken != nil{
                        self!.userToken = userToken!
                    }else{
                        self!.userToken = ""
                    }
                    
                    guard error == nil else {
                        return
                    }
                    completion(userToken!)
                }
                
            default:
                
                break
                
            }
        }
    }
    
    func fetchStorefrontID(userToken: String, completion: @escaping(String) -> Void){
         var storefrontID: String!
         let musicURL = URL(string: "https://api.music.apple.com/v1/me/storefront")!
         var musicRequest = URLRequest(url: musicURL)
         musicRequest.httpMethod = "GET"
         musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
         musicRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
            
         URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
              guard error == nil else { return }
                
              if let json = try? JSON(data: data!) {
                  let result = (json["data"]).array!
                  let id = (result[0].dictionaryValue)["id"]!
                 
                  storefrontID = id.stringValue
                  completion(storefrontID)
              }
         }.resume()
    }
    
    /*
    func fetchStorefrontID() -> String {
        let lock = DispatchSemaphore(value: 0)
        var storefrontID: String! 
        
        let musicURL = URL(string: "https://api.music.apple.com/v1/me/storefront")!
        var musicRequest = URLRequest(url: musicURL)
        musicRequest.httpMethod = "GET"
        musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        musicRequest.addValue(getUserToken(), forHTTPHeaderField: "Music-User-Token")
        
        URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
            guard error == nil else { return }
            
            if let json = try? JSON(data: data!) {
                let result = (json["data"]).array!
                let id = (result[0].dictionaryValue)["id"]!
                storefrontID = id.stringValue
                lock.signal()
            }
        }.resume()
        
        lock.wait()
        return storefrontID
    }
    */
    
    
    func fetchRecentSong(userToeken:String){
        var semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: "https://api.music.apple.com/v1/me/recent/played")!,timeoutInterval: Double.infinity)
        request.addValue(userToeken, forHTTPHeaderField: "Music-User-Token")
        request.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    func searchAppleMusic(searchTerm: String!,userToeken:String,storeFId:String) -> [Song] {
        let lock = DispatchSemaphore(value: 0)
        var songs = [Song]()

        let musicURL = URL(string: "https://api.music.apple.com/v1/catalog/\(storeFId)/search?term=\(searchTerm.replacingOccurrences(of: " ", with: "+"))&types=songs&limit=25")!
        var musicRequest = URLRequest(url: musicURL)
        musicRequest.httpMethod = "GET"
        musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        musicRequest.addValue(userToeken, forHTTPHeaderField: "Music-User-Token")
        
        URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
            guard error == nil else { return }
            if let json = try? JSON(data: data!) {
                let result = (json["results"]["songs"]["data"]).array!
                for song in result {
                    let attributes = song["attributes"]
                 //   let currentSong = Song(id: attributes["playParams"]["id"].string!, name: attributes["name"].string!, artistName: attributes["artistName"].string!, artworkURL: attributes["artwork"]["url"].string!)
                  //  songs.append(currentSong)
                }
                lock.signal()
            } else {
                lock.signal()
            }
        }.resume()
        
        lock.wait()
        return songs
    }
    
}

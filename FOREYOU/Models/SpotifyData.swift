//
//  SpotifyData.swift


import UIKit

class SpotifyData: NSObject {
    
    var music_name:String?
    var id:String?
    var type:String?
    var album_name:String?
    var releaseDate:String?
    var totalTracks:String?
    var artistName:String?
    var musicUrl:String?
    
    init(dict:NSDictionary){
        music_name=dict["music_name"] as? String ?? ""
        id = dict["id"] as? String ?? ""
        type=dict["type"] as? String ?? ""
        album_name = dict["album_name"] as? String ?? ""
        releaseDate=dict["releaseDate"] as? String ?? ""
        totalTracks=dict["totalTracks"] as? String ?? ""
        artistName=dict["artistName"] as? String ?? ""
        musicUrl=dict["musicUrl"] as? String ?? ""
    }

}

//
//  Song.swift
//  MusicPlayer
//
//  Created by Sai Kambampati on 5/30/20.
//  Copyright © 2020 Sai Kambmapati. All rights reserved.
//

import Foundation

struct Song {
    var id = ""
    var music_name = ""
    var artistName = ""
    var music_type = ""
    var artworkURL = ""
    var releaseDate = ""
    var record_Label = ""
    var album_url = ""
    var track_count = ""
    var copyright = ""
    var editorialNotes_standard = ""
    var editorialNotes_short = ""
    var genre = ""

    init(id: String, music_name: String, artistName: String, music_type: String, artworkURL: String, releaseDate: String, record_Label: String, album_url: String, track_count: String, copyright: String, editorialNotes_standard: String, editorialNotes_short: String, genre: String) {
        self.id = id
        self.music_name = music_name
        self.artworkURL = artworkURL
        self.music_type = music_type
        self.artistName = artistName
        self.releaseDate = releaseDate
        self.record_Label = record_Label
        self.album_url = album_url
        self.track_count = track_count
        self.copyright = copyright
        self.editorialNotes_standard = editorialNotes_standard
        self.editorialNotes_short = editorialNotes_short
        self.genre = genre
    }
}

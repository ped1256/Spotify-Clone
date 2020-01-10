//
//  SearchTracksDecode.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 24/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation
struct Tracks: Decodable {
    let tracks: [Track]
}
struct Track: Decodable {
    let id: String
    let name: String
    let album: Album
    let uri: String
    let href: String
    let msTime: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, name, album, uri, href, msTime = "duration_ms"
    }
}

struct Album: Decodable {
    let images: [ImageDecodable]
}

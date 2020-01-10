//
//  Artist.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 22/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation

struct SearchArtistsDecode: Decodable {
    let artists: Artists
}

struct Artists: Decodable {
    let items: [Artist]?
    let limit: Int?
    let next: String?
    let offSet: Int?
    let previous: String?
    let total: Int?
}

struct Artist: Decodable {
    let genres: [String]
    let name: String
    let href: String
    let images: [ImageDecodable]
    let id: String
}

struct ImageDecodable: Decodable {
    let height: Int
    let url: String
    let width: Int
}

// criar decodable for tracks

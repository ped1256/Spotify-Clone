//
//  Artist.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 22/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation

struct Artists: Decodable {
    let artists: ArtistValues
    
}

struct ArtistValues: Decodable {
    let items: [Item]?
    let limit: Int?
    let next: String?
    let offSet: Int?
    let previous: String?
    let total: Int?
}

struct Item: Decodable {
    let genres: [String]
    let name: String
    let images: [ArtistImage]
    let uri: String
    
}

struct ArtistImage: Decodable {
    let height: Int
    let url: String
    let width: Int
}

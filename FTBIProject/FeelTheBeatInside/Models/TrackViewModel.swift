//
//  TrackViewModel.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 25/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation
class TrackViewModel: NSObject {
    
    var id: String?
    var name: String?
    var album: Album?
    var uri: String?
    var href: String?
    var msTime: Int?
    var image: UIImage?
    var imagePath: String?
    var imageCompletion: ((UIImage) -> ())?
    var isPlaying = false
    var trackPosition = 0
    
    var formattedMsTime: String {
        guard let msTime = self.msTime else{ return "" }
        
        let time = secondsToMinutesSeconds(seconds: msTime / 1000)
        
        var minuteSecondMS: String {
            return String(format:"%d:%02d", time.0, time.1)
        }
        
        return minuteSecondMS
    }
    
    init(with object: Track) {
        super.init()
        
        self.id = object.id
        self.name = object.name
        self.album = object.album
        self.uri = object.uri
        self.href = object.href
        self.msTime = object.msTime
        self.imagePath = object.album.images.first?.url
        
        guard let path = self.imagePath else { return }
        
        Utils.parseImage(path: path) { [weak self] image in
            self?.image = image
            self?.imageCompletion?(image)
        }

    }
    

    private func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600 / 60), (seconds % 3600) % 60)
    }
}

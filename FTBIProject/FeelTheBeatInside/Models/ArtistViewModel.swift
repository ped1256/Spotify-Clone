//
//  ArtistViewModel.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 23/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation

class ArtistViewModel: NSObject {
    var name: String?
    var imagePath: String?
    var image: UIImage?
    var href: String?
    var id: String?
    var imageCompletion: ((UIImage) -> ())?
    var tracks: [TrackViewModel]?
    
    init(with object: Artist) {
        super.init()
        
        self.name = object.name
        self.imagePath = object.images.first?.url
        self.id = object.id
        self.href = object.href
        
        guard let path = self.imagePath else { return }
        
        Utils.parseImage(path: path) { [weak self] image in
            self?.image = image
            self?.imageCompletion?(image)
        }
    }
    
//    private func parseImage() {
//        guard let path = imagePath else { return  }
//        NetworkOperation.parseImage(path: path) { image in
//            self.imageCompletion?(image)
//            self.image = image
//        }
//    }
}

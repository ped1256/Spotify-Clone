//
//  Utils.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 26/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation

class Utils: NSObject {
    static func parseImage(path: String, completion: @escaping (UIImage) -> ()) {
        NetworkOperation.parseImage(path: path) { image in
            completion(image)
        }
    }
}

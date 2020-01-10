//
//  AccessControlManager.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 21/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation

struct Constants {
    static let userDefaultsAccessTokenKey = "lastValidAccessToken"
}

class AccessControllManager: NSObject {
    
    static var shared = AccessControllManager()
    
    var accessToken: String = {
        guard let acessToken = UserDefaults.standard.value(forKey: Constants.userDefaultsAccessTokenKey) as? String else { return "No Access token" }
        return acessToken
    }()
    
}

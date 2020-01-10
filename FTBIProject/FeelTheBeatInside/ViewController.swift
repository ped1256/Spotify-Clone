//
//  ViewController.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 20/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController, SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("logou")
        self.configuration.playURI = "spotify:track:20I6sIOMTCkB6w7ryavxtO"
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("")
    }
    
    
    let SpotifyClientID = "9b38fc69950848d3821e06544d6eab4a"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://ftbi.herokuapp.com/api/token"),
            let tokenRefreshURL = URL(string: "https://ftbi.herokuapp.com/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = ""
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startSession()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        self.sessionManager.application(app, open: url, options: options)
        return true
    }

    private func startSession() {
        let requestedScopes: SPTScope = [.appRemoteControl]
        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
    }
    
    @objc private func playSomething(_ sender: Any) {
        
    }
}


//
//  AppDelegate.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 20/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    

    let spotifyClientID = "9b38fc69950848d3821e06544d6eab4a"
    let spotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback") ?? URL(fileURLWithPath: "invalid redirect url")
    
    lazy var configuration = SPTConfiguration(clientID: spotifyClientID, redirectURL: spotifyRedirectURL)
    
    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://ftbi.herokuapp.com/api/token"),
            let tokenRefreshURL = URL(string: "https://ftbi.herokuapp.com/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            
            // play this song in start because this song is so nice rs rs
            // music suggestion for your guys.
            self.configuration.playURI = "spotify:track:0eDQj41kzBhMKQIkTt6OJR"
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    @objc private func startSession() {
        let requestedScopes: SPTScope = [.appRemoteControl]
        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        self.appRemote.connectionParameters.accessToken = session.accessToken
        DispatchQueue.main.async { [weak self] in
            self?.appRemote.connect()
        }
        
        UserDefaults.standard.set(session.accessToken, forKey: Constants.userDefaultsAccessTokenKey)
        NotificationCenter.default.post(Notification(name: .finishedSessionNotificationName))
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerControlAction(_:)), name: .playItemNotificationName, object: nil)
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        
    }
    
    @objc private func playerControlAction(_ notification: NSNotification) {
        guard let playerControll = notification.object as? PlayerControl else { return }
        
        switch playerControll.state {
        case .pause:
            self.pause()
        case .play:
            self.play(uri: playerControll.trackURI)
        case .resume:
            self.resume()
        default:
            break
        }
    }
    
    @objc private func play(uri: String){
        self.appRemote.playerAPI?.play(uri, callback: nil)
    }
    
    @objc private func pause(){
        self.appRemote.playerAPI?.pause(nil)
    }
    
    @objc private func resume(){
        self.appRemote.playerAPI?.resume(nil)
    }
    
    @objc private func previous(){
        self.appRemote.playerAPI?.skip(toPrevious: nil)
    }
    var shouldPauseInStart: Bool = true
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        if shouldPauseInStart {
            self.appRemote.playerAPI?.pause(nil)
        }
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })

        shouldPauseInStart = false

    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        // update state here
        // this state dont called in all time, because that i created my personal progressview state.
        debugPrint("Track name: %@", playerState.playbackPosition)
    }
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let nav = UINavigationController()
        
        let launchScreen = AuthenticationViewController()
//        let launchScreen = HomePlayerViewController()
        nav.isNavigationBarHidden = true
        nav.viewControllers = [launchScreen]
        
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startSession), name: .startSessionNotificationName, object: nil)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        self.sessionManager.application(app, open: url, options: options)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if self.appRemote.isConnected {
            self.appRemote.disconnect()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let _ = self.appRemote.connectionParameters.accessToken {
            self.appRemote.connect()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FeelTheBeatInside")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


//
//  SearchArtistOperation.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 21/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation

class NetworkOperation: NSObject {
        static func search(query: String, completion: @escaping (SearchArtistsDecode) -> ()) {
            
        guard query.count > 2 else { return }

        let urlString = "https://api.spotify.com/v1/search?q=\(query)&type=artist".replacingOccurrences(of: " ", with: "%20").folding(options: .diacriticInsensitive, locale: .current)

        let weakUrl = URL(string: urlString)
        
        guard let url = weakUrl else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(AccessControllManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                guard error == nil, let dataResponse = data else { return }
                
                let artists = try JSONDecoder().decode(SearchArtistsDecode.self, from: dataResponse)

                completion(artists)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }

        task.resume()
    }
    
    static func parseImage(path: String, completion: @escaping (UIImage) -> ()) {
        let weakUrl = URL(string: path)
        guard let url = weakUrl else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let dataResponse = data, let image = UIImage(data: dataResponse) else { return }
            completion(image)
        }
        task.resume()
    }
    
    static func getArtistTracks(path: String, completion: @escaping (Tracks) -> ()) {
        let weakUrl = URL(string: "https://api.spotify.com/v1/artists/\(path)/top-tracks?country=BR")
        guard let url = weakUrl else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(AccessControllManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                guard let dataResponse = data else { return }
                let decodableTracks = try JSONDecoder().decode(Tracks.self, from: dataResponse)
                completion(decodableTracks)
                
            } catch let error {
                print("Error", error)
            }
        }
        
        task.resume()
    }
}

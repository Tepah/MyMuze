//
//  SpotifyAPIClient.swift
//  MyMuze
//
//  Created by Diamond Ly on 4/16/24.
//

import Foundation
import Alamofire

class SpotifyAPIClient {
    private let clientID = "f77d210cbcb34136b4c1900721413fc2"
    private let clientSecret = "8f01f4aa5cf045e395167820f98e6154"
    private let tokenURL = "https://accounts.spotify.com/api/token"
    private let searchURL = "https://api.spotify.com/v1/search"
    
    func getAccessToken(completion: @escaping (String?) -> Void) {
        let parameters: [String: String] = [
            "grant_type": "client_credentials",
            "client_id": clientID,
            "client_secret": clientSecret
        ]
        
        AF.request(tokenURL, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any],
                       let accessToken = JSON["access_token"] as? String {
                        completion(accessToken)
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    print("Error getting access token: \(error)")
                    completion(nil)
                }
            }
    }
    
    func searchTracks(query: String, accessToken: String, completion: @escaping ([String]?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters: [String: String] = [
            "q": query,
            "type": "track",
            "market": "US",
            "offset": "20"
        ]
        
        AF.request(searchURL, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any],
                       let tracks = JSON["tracks"] as? [String: Any],
                       let items = tracks["items"] as? [[String: Any]] {
                        let trackNames = items.compactMap { $0["name"] as? String }
                        completion(trackNames)
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    print("Error searching tracks: \(error)")
                    completion(nil)
                }
            }
    }
    
}

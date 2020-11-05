//
//  NetworkManager.swift
//  Twitch Demo
//
//  Created by ZiyoMukhammad Usmonov on 11/5/20.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = API.Routes.TopGames
    let cache = NSCache<NSString, UIImage>()

    private init () {}
    
    func getTopGames(page: Int, completed: @escaping (Result<GameApiResponse, TGError>) -> Void) {
        let endPoint = baseURL + "/top?offset=\(page)&limit=10"
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidLocation))
            return
        }
        
        var request = URLRequest(url: url)

        request.setValue(API.Keys.APIKey, forHTTPHeaderField: API.Headers.Authorization)
        request.setValue(API.Headers.Accept, forHTTPHeaderField: "Accept")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(GameApiResponse.self, from: data)
                completed(.success(apiResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
                }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}

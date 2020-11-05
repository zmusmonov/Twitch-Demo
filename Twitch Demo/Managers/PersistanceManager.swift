//
//  PersistanceManager.swift
//  Twitch Demo
//
//  Created by ZiyoMukhammad Usmonov on 11/5/20.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersistanceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys { static let favorites = "topGames" }
    
    static func updateWith(game: TopGames, actionType: PersistanceActionType, completed: @escaping(TGError?) -> Void) {
    retrieveTopGames { result in
            switch result {
            case .success(var games):
                switch actionType {
                case .add:
                    guard !games.contains(game) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    
                    games.append(game)
                    
                case .remove:
                    games.removeAll { $0.game.name == game.game.name}
                }
                
                completed(save(games: games))
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveTopGames(completed: @escaping (Result<[TopGames], TGError>) -> Void) {
        guard let gamesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([TopGames].self, from: gamesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToSave))
        }
    }
    
    static func save(games: [TopGames]) -> TGError? {
        do {
            let encoder = JSONEncoder()
            let encodedGames = try encoder.encode(games)
            defaults.setValue(encodedGames, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToSave
        }
    }
}

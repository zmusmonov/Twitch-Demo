//
//  TopGames.swift
//  Twitch Demo
//
//  Created by ZiyoMukhammad Usmonov on 11/5/20.
//

import Foundation

struct GameApiResponse {
    let total: Int
    let top: [TopGames]
}

extension GameApiResponse: Decodable {
        
    private enum GameApiResponseCodingKeys: String, CodingKey {
        case total = "_total"
        case top
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GameApiResponseCodingKeys.self)
        
        total = try container.decode(Int.self, forKey: .total)
        top = try container.decode([TopGames].self, forKey: .top)
    }
}

struct TopGames: Equatable {
    static func == (lhs: TopGames, rhs: TopGames) -> Bool {
        return true
    }
    
    let viewers: Int
    let channels: Int
    let game: Game
}

extension TopGames: Decodable, Encodable {
    
    enum TopGameCodingKeys: String, CodingKey {
        case viewers
        case channels
        case game
    }
    
    init(from decoder: Decoder) throws {
        let topGameContainer = try decoder.container(keyedBy: TopGameCodingKeys.self)
        
        viewers = try topGameContainer.decode(Int.self, forKey: .viewers)
        channels = try topGameContainer.decode(Int.self, forKey: .channels)
        game = try topGameContainer.decode(Game.self, forKey: .game)
    }
}

struct Game: Encodable {
    let name: String
    let logo: Logo
    let box: Box
}

extension Game: Decodable {
    
    enum GameCodingKeys: String, CodingKey {
        case name
        case logo
        case box
    }
    
    init(from decoder: Decoder) throws {
        let gameContainer = try decoder.container(keyedBy: GameCodingKeys.self)
        name = try gameContainer.decode(String.self, forKey: .name)
        logo = try gameContainer.decode(Logo.self, forKey: .logo)
        box =  try gameContainer.decode(Box.self, forKey: .box)
    }
}

struct Logo: Codable {
    let large: String
    let medium: String
    let small: String
    
    enum LogoCodingKeys: String, CodingKey {
        case large
        case medium
        case small
    }
    
    init(from decoder: Decoder) throws {
        let logoDecoder = try decoder.container(keyedBy: LogoCodingKeys.self)
        
        large = try logoDecoder.decode(String.self, forKey: .large)
        medium = try logoDecoder.decode(String.self, forKey: .medium)
        small = try logoDecoder.decode(String.self, forKey: .small)
    }
}

struct Box: Codable {
    let large: String
    let medium: String
    let small: String
    
    enum LogoCodingKeys: String, CodingKey {
        case large
        case medium
        case small
    }
    
    init(from decoder: Decoder) throws {
        let logoDecoder = try decoder.container(keyedBy: LogoCodingKeys.self)
        
        large = try logoDecoder.decode(String.self, forKey: .large)
        medium = try logoDecoder.decode(String.self, forKey: .medium)
        small = try logoDecoder.decode(String.self, forKey: .small)
    }
}

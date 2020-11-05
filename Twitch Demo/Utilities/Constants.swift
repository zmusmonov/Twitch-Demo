//
//  Constants.swift
//  Twitch Demo
//
//  Created by ZiyoMukhammad Usmonov on 11/5/20.
//

import UIKit

struct AppColor {
    static let appPrimaryColor =  UIColor(red: 145/255, green: 79/255, blue: 251/255, alpha: 1.0)
    static let appSecondaryColor =  UIColor(red: 55/255, green: 3/255, blue: 139/255, alpha: 1.0)
}

struct API {
    struct Headers {
        static let Authorization = "Client-ID"
        static let Accept = "application/vnd.twitchtv.v5+json"
    }
    
    struct Routes {
        static let TopGames = "https://api.twitch.tv/kraken/games"
    }
    
    struct Keys {
        static let APIKey = "sd4grh0omdj9a31exnpikhrmsu3v46"
    }
}

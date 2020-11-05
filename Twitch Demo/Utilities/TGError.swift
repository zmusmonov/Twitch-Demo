//
//  TGError.swift
//  Twitch Demo
//
//  Created by ZiyoMukhammad Usmonov on 11/5/20.
//

import Foundation

enum TGError: String, Error {
    case invalidLocation    = "This location created an invalid request. Please try again."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection"
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
    case unableToSave   = "There was an error save this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user. You must REALLY like them!"
}

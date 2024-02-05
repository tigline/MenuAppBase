//
//  AppState.swift
//

import Foundation

struct AppState {
    var destinations = [Destination]()
    var favoriteMovieIDs = Set<Int>()
    var favoritePersonIDs = Set<Int>()
    var tabDestination: TabDestination = .movie
    var sideSelection: Category = .nowPlaying
    var machineCode: String = "X3V9YPJABVZGAELIZ9"
    var checkLanguage: String = "JP"
}


struct ShopInfo {
    let name:String
    let address:String
    let invoice:String 
    let telNumber:String
    let deviceCode:String
    let machineCode:String
}


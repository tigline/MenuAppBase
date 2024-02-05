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
}


struct UserInfo {
    
}

struct DeviceInfo {
    
}

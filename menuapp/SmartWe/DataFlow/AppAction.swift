//
//  AppAction.swift
//

import Foundation

enum AppAction {
    /// favorite movie data update from Core Data
    case movieChangedFormCoreData(Set<Int>)
    /// favorite person data update from Core Data
    case personChangedFormCoreData(Set<Int>)
    /// switch tabView
    case TabItemButtonTapped(TabDestination)
    
    case sideBarTapped(String)
    /// empty destinations and back to home
    case setDestination(to: [Destination])
    /// update destination
    case updateDestination(to: [Destination])
    /// append one destination into destinations
    case gotoDestination(Destination)
    /// update favorite movies
    case updateMovieWishlist(Int)
    /// update favorite person
    case updateFavoritePersonList(Int)
    ///  update machine info
    case updateMachineInfo(MachineInfo)
    
}

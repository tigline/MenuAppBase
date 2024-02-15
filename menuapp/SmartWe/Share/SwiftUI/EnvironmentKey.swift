//
//  ActionKey.swift
//

import Foundation
import SwiftUI
import TMDb

struct StoreKey: EnvironmentKey {
    static var defaultValue = Store()
}

struct InWishlistKey: EnvironmentKey {
    static var defaultValue: (Int) -> Bool = { _ in true }
}

struct InOptionlistKey: EnvironmentKey {
    static var defaultValue: (String, String) -> Bool = { _,_  in false }
}

struct themeKey: EnvironmentKey {
    static var defaultValue: (Assets) -> Void = {
        #if DEBUG
        print("select theme \($0.themeColor)")
        #endif
    }
}

struct GoMovieDetailFromHomeKey: EnvironmentKey {
    static var defaultValue: (Category, Movie) -> Void = {
        #if DEBUG
            print("goto (\($0)):(\($1.title))'s detail view")
        #endif
    }
}

struct GoMovieDetailFormCategoryKey: EnvironmentKey {
    static var defaultValue: (Movie) -> Void = {
        #if DEBUG
            print("goto (\($0.title))'s detail view")
        #endif
    }
}

struct UpdateMovieWishlistKey: EnvironmentKey {
    static var defaultValue: (Int) -> Void = {
        #if DEBUG
            print("update movie id:\($0) in favorite movie list")
        #endif
    }
}

struct UpdateMenuOptionlistKey: EnvironmentKey {
    static var defaultValue: (String, String) -> Void = {
        #if DEBUG
            print("update option old:\($0) new:\($1) in menu option list")
        #endif
    }
}

struct GoCategoryKey: EnvironmentKey {
    static var defaultValue: (Destination) -> Void = {
        #if DEBUG
            print("go to \($0.debugDescription)'s gallery view")
        #endif
    }
}

struct GoOptionsKey: EnvironmentKey {
    static var defaultValue: (Menu) -> Void = {
        #if DEBUG
            print("go to \($0.mainTitle)'s options view")
        #endif
    }
}

struct MovieIsLoadingKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

struct BackdropSizeKey: EnvironmentKey {
    static var defaultValue: CGSize = .zero
}

struct OverlayContainerSceneName: EnvironmentKey {
    static var defaultValue: String = UUID().uuidString
}

extension EnvironmentValues {
    
    var store:Store {
        get { self[StoreKey.self] }
        set { self[StoreKey.self] = newValue }
    }
    var theme: (Assets) -> Void {
        get { self[themeKey.self] }
        set { self[themeKey.self] = newValue }
    }
    
    var goOptions: (Menu) -> Void {
        get { self[GoOptionsKey.self] }
        set { self[GoOptionsKey.self] = newValue }
    }
    // check if in favorite movie list
    var inWishlist: (Int) -> Bool {
        get { self[InWishlistKey.self] }
        set { self[InWishlistKey.self] = newValue }
    }
    
    var inOptionlist: (String, String) -> Bool {
        get { self[InOptionlistKey.self] }
        set { self[InOptionlistKey.self] = newValue }
    }

    // go to movie detail view from home
    var goDetailFromHome: (Category, Movie) -> Void {
        get { self[GoMovieDetailFromHomeKey.self] }
        set { self[GoMovieDetailFromHomeKey.self] = newValue }
    }

    // go to movie detail view from movie gallery
    var goDetailFromCategory: (Movie) -> Void {
        get { self[GoMovieDetailFormCategoryKey.self] }
        set { self[GoMovieDetailFormCategoryKey.self] = newValue }
    }

    // add movie into favorite list
    var updateWishlist: (Int) -> Void {
        get { self[UpdateMovieWishlistKey.self] }
        set { self[UpdateMovieWishlistKey.self] = newValue }
    }
    
    var updateOptionlist: (String, String) -> Void {
        get { self[UpdateMenuOptionlistKey.self] }
        set { self[UpdateMenuOptionlistKey.self] = newValue }
    }

    // go to category gallery view
    var goCategory: (Destination) -> Void {
        get { self[GoCategoryKey.self] }
        set { self[GoCategoryKey.self] = newValue }
    }

    var isLoading: Bool {
        get { self[MovieIsLoadingKey.self] }
        set { self[MovieIsLoadingKey.self] = newValue }
    }

    // set nowPlaying backdrop size in compact mode
    var backdropSize: CGSize {
        get { self[BackdropSizeKey.self] }
        set { self[BackdropSizeKey.self] = newValue }
    }

    // overlay Container name
    var containerName: String {
        get { self[OverlayContainerSceneName.self] }
        set { self[OverlayContainerSceneName.self] = newValue }
    }
}

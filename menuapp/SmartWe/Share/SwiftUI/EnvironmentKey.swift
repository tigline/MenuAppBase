//
//  ActionKey.swift
//

import Foundation
import SwiftUI


struct MenuStoreKey: EnvironmentKey {
    static var defaultValue = MenuStore(appService: AppService.appDefault)
}

struct SoundManagerKey: EnvironmentKey {
    static var defaultValue = SoundManager()
}

struct CargoStoreKey: EnvironmentKey {
    static var defaultValue = CargoStore(appService: AppService.appDefault)
}

struct showEnterTableKey: EnvironmentKey {
    static var defaultValue: (Bool) -> Void = { _ in }
}

struct InOptionlistKey: EnvironmentKey {
    static var defaultValue: (String, String) -> Bool = { _,_  in false }
}

struct themeKey: EnvironmentKey {
    static var defaultValue: (AppTheme) -> Void = {
        #if DEBUG
        print("select theme \($0.themeColor)")
        #endif
    }
}

struct UpdateMenuOptionlistKey: EnvironmentKey {
    static var defaultValue: (String, String, Double) -> Void = {
        #if DEBUG
            print("update option old:\($0) new:\($1) \($2) in menu option list")
        #endif
    }
}


struct GoOptionsKey: EnvironmentKey {
    static var defaultValue: (Menu, UIImage, CGRect) -> Void = {
        #if DEBUG
        print("go to \($0) \($1) \($2)'s options view")
        #endif
    }
}

struct MenuIsLoadingKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

struct BackdropSizeKey: EnvironmentKey {
    static var defaultValue: CGSize = .zero
}

struct OverlayContainerSceneName: EnvironmentKey {
    static var defaultValue: String = UUID().uuidString
}

extension EnvironmentValues {
    
    var soundPlayer:SoundManager {
        get { self[SoundManagerKey.self] }
        set { self[SoundManagerKey.self] = newValue }
    }

    var menuStore:MenuStore {
        get { self[MenuStoreKey.self] }
        set { self[MenuStoreKey.self] = newValue }
    }
    
    var cargoStore:CargoStore {
        get { self[CargoStoreKey.self] }
        set { self[CargoStoreKey.self] = newValue }
    }
    
    var theme: (AppTheme) -> Void {
        get { self[themeKey.self] }
        set { self[themeKey.self] = newValue }
    }
    
    var goOptions: (Menu, UIImage, CGRect) -> Void {
        get { self[GoOptionsKey.self] }
        set { self[GoOptionsKey.self] = newValue }
    }
    
    
    var inOptionlist: (String, String) -> Bool {
        get { self[InOptionlistKey.self] }
        set { self[InOptionlistKey.self] = newValue }
    }
    
    var updateOptionlist: (String, String, Double) -> Void {
        get { self[UpdateMenuOptionlistKey.self] }
        set { self[UpdateMenuOptionlistKey.self] = newValue }
    }

    var isLoading: Bool {
        get { self[MenuIsLoadingKey.self] }
        set { self[MenuIsLoadingKey.self] = newValue }
    }
    
    var showTable: (Bool) -> Void {
        get { self[showEnterTableKey.self] }
        set { self[showEnterTableKey.self] = newValue }
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

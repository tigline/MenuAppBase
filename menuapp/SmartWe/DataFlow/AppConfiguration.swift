//
//  Configuration.swift
//

import Foundation
import SwiftUI
import TMDb

final class AppConfiguration: ObservableObject {
    /// colorScheme
    @AppStorage("colorScheme") var colorScheme: AppTheme = .orange
    /// Language
    //@AppStorage("language") var appLanguage: AppLanguage = .system
    @Published var appLanguage: AppLanguage = .system {
        didSet {
            UserDefaults.standard.set(appLanguage.rawValue, forKey: "language")
        }
    }
    /// selected genre
    @AppStorage("genres") var genres: [Int] = Genres.allCases.map { $0.rawValue }
    /// show book mark button in movie poster
    @AppStorage("show_favorite_button_in_movie_poster") var show_favorite_button_in_movie_poster = true
    /// show book mark button in person poster
    @AppStorage("show_favorite_button_in_person_poster") var show_favorite_button_in_person_poster = true
    /// open in new window on macOS
    @AppStorage("open_in_new_window") var open_in_new_window = false
    /// show bookMark
    @AppStorage("showBookMarkInPoster") var showBookMarkInPoster = true
    
    @AppStorage("machineCode") var machineCode:String?
    
    @AppStorage("logoImage") var logoImage:String = ""
    
    @AppStorage("shopCode") var shopCode:String?
    
    @AppStorage("menuLaguage") var menuLaguage:String?
    
    @AppStorage("tableNo") var tableNo:String?
    
    @AppStorage("orderKey") var orderKey:String?
    
    @AppStorage("lastChangedDate") var lastChangedDate: Double = Date().timeIntervalSince1970
    
    @AppStorage("loginState") var loginState: LoginState = .logout

    static let share = AppConfiguration()
    
    init() {
        if let language = UserDefaults.standard.integer(forKey: "language") as Int?,
           let appLanguage = AppLanguage(rawValue: language) {
           self.appLanguage = appLanguage
        }
    }
}

//
//  Configuration.swift
//

import Foundation
import SwiftUI
import TMDb

final class AppConfiguration: ObservableObject {
    /// colorScheme
    @AppStorage("colorScheme") var colorScheme: ColorSchemeSetting = .system
    /// Language
    @AppStorage("language") var appLanguage: AppLanguage = .system
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
    
    @AppStorage("loginState") var loginState: LoginState = .logout

    static let share = AppConfiguration()
}

//
//  Configuration.swift
//

import Foundation
import SwiftUI

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
    
    @AppStorage("shopName") var shopName:String = ""
    
    @AppStorage("shopAddress") var shopAddress:String = ""
    
    @AppStorage("shopTel") var shopTel:String = ""
    
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

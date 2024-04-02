//
//  SettingAppearance.swift
//

import Foundation
import SwiftUI

struct SettingAppearance: View {
    @StateObject private var configuration = AppConfiguration.share
    @State private var logoutPresent:Bool = false
    
    
    let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "App Name"

    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"

    let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"

    
    
    var body: some View {
            
            Form {
                Section(header: Text("version_info")) {
                    LabeledContent {
                        Text(appVersion + "(\(appBuild))")
                    } label: {
                        Text(appName)
                    }
                }
                
                Section(header: Text("shop_info")) {
                                   
                    LabeledContent {
                        Text(configuration.shopName)
                    } label: {
                        Text("shop_name")
                    }
                    
                    LabeledContent {
                        Text(configuration.shopAddress)
                    } label: {
                        Text("shop_address")
                    }
                    
                    LabeledContent {
                        Text(configuration.shopTel)
                    } label: {
                        Text("shop_tel")
                    }
                }
                
                Section(header: Text("setting")) {
                    // Language
                    Picker("setting_theme", selection: $configuration.colorScheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.localizedString)
                                .tag(theme.rawValue)
                        }
                    }
                    .pickerStyle(.menu)


                    // Theme
                    Picker("language", selection: $configuration.appLanguage) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.localizedString)
                                .tag(language)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section {
                    Button(action: {
                        logoutPresent.toggle()
                    }, label: {
                        HStack(alignment: .center){
                            Spacer()
                            Text("log_out")
                                .foregroundStyle(.red)
                            Spacer()
                        }
                    })
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("logout_caution", isPresented: $logoutPresent) {
                Button {
                    configuration.machineCode = ""
                    configuration.loginState = .logout
                    logoutPresent.toggle()
                } label: {
                    HStack {
                        Spacer()
                        Text("sure_text")
                            
                        Spacer()
                    }
                }.foregroundStyle(.red)
                
                Button {
                    logoutPresent.toggle()
                } label: {
                    HStack {
                        Spacer()
                        Text("cancel_text")
                        Spacer()
                    }
                }
            }

        

    }
}

struct SettingAppearance_Previews: PreviewProvider {
    static var previews: some View {
        SettingAppearance()
            //.environmentObject(Store())
    }
}

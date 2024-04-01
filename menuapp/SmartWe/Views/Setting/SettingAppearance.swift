//
//  SettingAppearance.swift
//

import Foundation
import SwiftUI

struct SettingAppearance: View {
    @StateObject private var configuration = AppConfiguration.share
    @State private var logoutPresent:Bool = false
    
    var body: some View {
            
            Form {
                Section(header: Text("version_info")) {
                    LabeledContent {
                        Text("1.0.0")
                    } label: {
                        Text("SmartWe App")
                    }
                }
                
                Section(header: Text("shop_info")) {
                                   
                    LabeledContent {
                        Text("甘兰牛肉面")
                    } label: {
                        Text("shop_name")
                    }
                    
                    LabeledContent {
                        Text("日本桥")
                    } label: {
                        Text("shop_address")
                    }
                    
                    LabeledContent {
                        Text("06-8888-9999")
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
            .navigationTitle(SettingCategory.appearance.localizedString)
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

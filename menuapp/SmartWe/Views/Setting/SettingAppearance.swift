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
                Section(header: Text("版本信息")) {
                    LabeledContent {
                        Text("1.0.0")
                    } label: {
                        Text("SmartWe App")
                    }
                }
                
                Section(header: Text("店铺信息")) {
                                   
                    LabeledContent {
                        Text("甘兰牛肉面")
                    } label: {
                        Text("名称")
                    }
                    
                    LabeledContent {
                        Text("日本桥")
                    } label: {
                        Text("地址")
                    }
                    
                    LabeledContent {
                        Text("06-8888-9999")
                    } label: {
                        Text("电话")
                    }
                }
                
                Section(header: Text("设置")) {
                    // Language
                    Picker("Setting_ColorScheme_Label", selection: $configuration.colorScheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.localizedString)
                                .tag(theme.rawValue)
                        }
                    }
                    .pickerStyle(.menu)


                    // Theme
                    Picker("Setting_Language_Label", selection: configuration.$appLanguage) {
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
            .alert("Are you sure to logout", isPresented: $logoutPresent) {
                Button {
                    configuration.machineCode = ""
                    configuration.loginState = .logout
                    logoutPresent.toggle()
                } label: {
                    HStack {
                        Spacer()
                        Text("Sure")
                            
                        Spacer()
                    }
                }.foregroundStyle(.red)
                
                Button {
                    logoutPresent.toggle()
                } label: {
                    HStack {
                        Spacer()
                        Text("Cancel")
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

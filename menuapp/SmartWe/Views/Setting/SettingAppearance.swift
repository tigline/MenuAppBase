//
//  SettingAppearance.swift
//

import Foundation
import SwiftUI

struct SettingAppearance: View {
    @EnvironmentObject var configuration: AppConfiguration
    @State private var logoutPresent:Bool = false
    @State private var password:String = ""
    @State private var showResetPw:Bool = false
    @State private var showPWResult:Bool = false
    @Environment(\.appRouter) var appRouter
    
    let coreDataStack = CoreDataStack.shared
    
    
    
    let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "App Name"

    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"

    let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"

    var curPassword:String {
        configuration.password
    }
    
    var body: some View {
            
            Form {
                Section(
                    header: Text("version_info").font(configuration.appLanguage.regularFont(14))
                    
                ) {
                    LabeledContent {
                        Text(appVersion + "(\(appBuild))")
                            .font(configuration.appLanguage.regularFont(16))
                    } label: {
                        Text(appName)
                            .font(configuration.appLanguage.regularFont(16))
                    }
                    
                }
                
//                Section(header: Text("shop_info")) {
//                                   
//                    LabeledContent {
//                        Text(configuration.shopName)
//                    } label: {
//                        Text("shop_name")
//                    }
//                    
//                    LabeledContent {
//                        Text(configuration.shopAddress)
//                    } label: {
//                        Text("shop_address")
//                    }
//                    
//                    LabeledContent {
//                        Text(configuration.shopTel)
//                    } label: {
//                        Text("shop_tel")
//                    }
//                }
                
                Section(header: Text("operation_password")) {
                                   
                    LabeledContent {
                        
                        Button {
                            showResetPw.toggle()
                        } label: {
                            Text("password_reset")
                                .font(configuration.appLanguage.regularFont(16))
                        }

                        
                    } label: {
                        Text(configuration.password)
                    }
                }
                
                Section(header: Text("setting").font(configuration.appLanguage.regularFont(14))) {
                    // Language
                    Picker("setting_theme", selection: configuration.$colorScheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.localizedString)
                                .font(configuration.appLanguage.regularFont(16))
                                .tag(theme.rawValue)
                        }
                    }
                    .pickerStyle(.menu)


                    // Theme
                    Picker("language", selection: configuration.$appLanguage) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.localizedString)
                                .font(configuration.appLanguage.regularFont(16))
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
                                .font(configuration.appLanguage.regularFont(16))
                                .foregroundStyle(.red)
                            Spacer()
                        }
                    })
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("logout_caution", isPresented: $logoutPresent) {
                Button {
                    Task {
                        try coreDataStack.batchDeleteDataWithTableNumber(configuration.tableNo ?? "")
                        configuration.machineCode = nil
                        configuration.orderKey = nil
                        configuration.tableNo = nil
                        appRouter.router = nil
                        configuration.loginState = .logout
                    }
                    
                    //logoutPresent.toggle()
                } label: {
                    HStack {
                        Spacer()
                        Text("sure_text")
                            .font(configuration.appLanguage.regularFont(16))
                        Spacer()
                    }
                }.foregroundStyle(.red)
                
                Button(role: .cancel) {
                    //logoutPresent.toggle()
                } label: {
                    HStack {
                        Spacer()
                        Text("cancel_text")
                            .font(configuration.appLanguage.regularFont(16))
                        Spacer()
                    }
                }
            }
            .alert("password_reset_tips", isPresented: $showResetPw) {
                
                TextField("", text: $password)//password_text
                    .keyboardType(.numberPad)
                    .padding()
                
                Button(role:.none) {
                    if password == "" {
                        showPWResult.toggle()
                    } else {
                        configuration.password = password
                    }
                    password = ""
                } label: {
                    HStack {
                        Spacer()
                        Text("sure_text")
                            .font(configuration.appLanguage.regularFont(16))
                        Spacer()
                    }
                }
                
                Button("cancel_text", role: .cancel){
                    password = ""
                }
                .font(configuration.appLanguage.regularFont(16))
                
            }
            .alert("password_is_empty", isPresented: $showPWResult) {
                
                Button(role:.none) {
                    showResetPw = true
                } label: {
                    HStack {
                        Spacer()
                        Text("reset_password")
                            .font(configuration.appLanguage.regularFont(16))
                        Spacer()
                    }
                }
                
                Button("cancel_text", role: .cancel){
                }
                .font(configuration.appLanguage.regularFont(16))
            }

        

    }
}

struct SettingAppearance_Previews: PreviewProvider {
    static var previews: some View {
        SettingAppearance()
            //.environmentObject(Store())
    }
}

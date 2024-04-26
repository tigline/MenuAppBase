//
//  NavigationStack.swift
//  MovieHunter
//
//  Created by Yang Xu on 2023/3/25.
//

import Foundation
import SwiftUI

struct StackContainer: View {
    @StateObject private var configuration = AppConfiguration.share
    var theme:AppTheme {
        configuration.colorScheme
    }
    
    @Environment(\.menuStore) var menuStore
    @Environment(\.cargoStore) var cargoStore
    @Environment(\.appRouter) var appRouter
    
    @State private var password:String = ""
    @State private var showOptions = false
    @State private var showTable:Bool = false
    @State private var showPWAlert:Bool = false
    @State private var showPWResult:Bool = false
    //let category:MenuCategory
    var body: some View {
        VStack {

            ToolbarView()

            NavigationStack() {
                    VStack {
                        switch appRouter.router {
                            case .menu(_):
                                MenuGalleryLazyVGrid()
                            case .cart:
                                ShoppingCarView().ignoresSafeArea(.keyboard)
                            case .order:
                                OrderView().ignoresSafeArea(.keyboard)
                            case .setting:
                                SettingAppearance()
                            case .none:
                                MenuGalleryLazyVGrid()
                            
                        }
                    }
                    .toolbar(.hidden, for: .navigationBar)
                    
            }
            
        }
        .background(theme.themeColor.contentBg)
        .environment(\.showTable) { showTable in
            
            DispatchQueue.main.async {
                self.showPWAlert = showTable
                //print("showPWAlert set to \(showPWAlert)")
            }
        }
        .onAppear{
            if configuration.tableNo == nil {
                showPWAlert = true
            }
        }
//        .onChange(of: configuration.tableNo, { oldValue, newValue in
//            if configuration.tableNo == nil {
//                showPWAlert = true
//            }
//        })
        .alert("input_password_title", isPresented: $showPWAlert) {
            
            SecureField("password_text", text: $password)//password_text
                .keyboardType(.numberPad)
                .padding()
            
            Button(role:.none) {
                
                #if DEBUG
                if password == "" {
                    password = "123456"
                }
                #endif
                
                if password == configuration.password {
                    showTable = true
                } else {
                    showPWResult.toggle()
                }
                password = ""
            } label: {
                HStack {
                    Spacer()
                    Text("sure_text")
                    Spacer()
                }
            }
            
            Button("cancel_text", role: .cancel){
                password = ""
            }
            
        }
        .alert("password_error", isPresented: $showPWResult) {
            
            Button(role:.none) {
                showPWAlert = true
            } label: {
                HStack {
                    Spacer()
                    Text("password_reinput")
                    Spacer()
                }
            }
            
            Button("cancel_text", role: .cancel){
            }
        }
        .sheet(isPresented: $showTable) {
            SelectTableView()
        }

    }
    

//    let showStack: Bool = {
//        #if DEBUG
//        let arguments = ProcessInfo.processInfo.arguments
//        var allow = true
//        for index in 0 ..< arguments.count - 1 where arguments[index] == "-ShowMovie" {
//            allow = arguments.count >= (index + 1) ? arguments[index + 1] == "1" : true
//            break
//        }
//        return allow
//        #else
//        return true
//        #endif
//    }()
}

//struct StackContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        StackContainer(category: )
//    }
//}


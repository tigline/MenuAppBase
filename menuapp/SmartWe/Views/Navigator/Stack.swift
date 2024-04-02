//
//  NavigationStack.swift
//  MovieHunter
//
//  Created by Yang Xu on 2023/3/25.
//

import Foundation
import SwiftUI

struct StackContainer: View {
    @Environment(\.store) var store
    var destinations:Binding<[Destination]> {
        .init(get:{store.state.destinations}, set:{store.state.destinations = $0})
    }
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
    //let category:MenuCategory
    var body: some View {
        VStack {

            ToolbarView()

            NavigationStack(path: destinations) {
                    VStack {
                        switch appRouter.router {
                        case .menu(_):
                                MenuGalleryLazyVGrid()
                            case .cart:
                                ShoppingCarView()
                            case .order:
                                OrderView()
                            case .setting:
                                SettingAppearance()
                            case .none:
                                MenuGalleryLazyVGrid()
                        }
                    }
                    .toolbar(.hidden, for: .navigationBar)
                    
                    .navigationDestination(for: Destination.self) { destination in
                        switch destination {
                        case .favoritePerson:
                            EmptyView()
                        case .movieDetail(_):
                            // movie Detail
                            EmptyView()
                        case .personDetail:
                            EmptyView()
                        default:
                            EmptyView()
                        }
                    }
            }
            
        }
        .background(theme.themeColor.contentBg)
        .environment(\.showTable) { showTable in
            showPWAlert = showTable
        }
        .onAppear{
            if configuration.tableNo == nil {
                showPWAlert = true
            }
        }
        .onChange(of: configuration.tableNo, { oldValue, newValue in
            if configuration.tableNo == nil {
                showPWAlert = true
            }
        })
        .alert("input_password_title", isPresented: $showPWAlert) {
            
            SecureField("password_text", text: $password)
                .keyboardType(.numberPad)
                .padding()
            
            Button(role:.none) {
                if password == "" {
                    showPWAlert = false
                    showTable = true
                } else {
                    showPWAlert = true
                }
            } label: {
                HStack {
                    Spacer()
                    Text("sure_text")
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


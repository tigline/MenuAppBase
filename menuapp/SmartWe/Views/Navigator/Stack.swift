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
    
    @Environment(\.store.state.appTheme) var theme
    
    @Environment(\.menuStore) var menuStore
    @Environment(\.cargoStore) var cargoStore
    @Environment(\.appRouter) var appRouter
    @State private var showOptions = false
    
    @State var showCargoView = false
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
                        case .movieDetail(let movie):
                            // movie Detail
                            MovieDetailContainer(movie: movie)
                        case .personDetail:
                            EmptyView()
                        default:
                            EmptyView()
                        }
                    }
            }
            
        }
        .background(theme.themeColor.contentBg)
        .environment(\.goOptions) { menu, rect in
            
            if let optionGroupVoList =  menu.optionGroupVoList,
                optionGroupVoList.count > 0 {
                menuStore.selectMenuItem(menu)
                showOptions.toggle()
            } else {
                //add to shopping car
                cargoStore.addGood(menu, price: menu.currentPrice)
            }
            
        }
//        .sheet(isPresented: $showOptions, content: {
//            OptionGroupListView(isShowing: $showOptions)
//        })
        
        .overlay(
            
            showOptions ? OptionGroupListView(isShowing: $showOptions):nil,
            alignment: .center // 定位到底部
        )
        .overlay {
            showCargoView ? ShoppingCarView():nil
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


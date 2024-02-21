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
                            case let .menu(categoryName):
                                
                                MenuGalleryLazyVGrid(items: menuStore.curMenuInfo?.menuVoList ?? [])
                            
                            case .cart:
                                ShoppingCarView()
                            
                            case let .order(order):
                                EmptyView()

                            case .setting:
                                EmptyView()
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
            //Spacer()
            
            //.setBackdropSize()
            
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
            
        }.sheet(isPresented: $showOptions, content: {
            OptionGroupListView(isShowing: $showOptions)
        })
        
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

struct ToolbarView: View {
    @Environment(\.store.state.appTheme) var theme
    @State var showPopover = false
    @State var showThemePopover = false
    @Environment(\.menuStore) var menuStore
    @Environment(\.appRouter) var appRouter
    
    
    
    var body: some View {
        HStack{
            
            OrderButton(icon: "button_bell_ White",
                        text: "オーダボタン",
                        bgColor: theme.themeColor.darkRed,
                        textColor: .white) {
                
            }
            OrderButton(icon: "button_ list_black",
                        text: "注文履歴",
                        bgColor: theme.themeColor.mainBackground,
                        textColor: .black) {
                
            }
            
            
            CartButton(icon: "button_shopping car_ black",
                        text: "買い物かご",
                        bgColor: theme.themeColor.mainBackground,
                        textColor: .black) {
                menuStore.updateTab("買い物かご")
                appRouter.updateRouter(.cart)
                
            }.background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            menuStore.cartIconGlobalFrame = geometry.frame(in: .global)
                        }
                }
            )
            
            Spacer()
            Button(LocalizedStringKey("setting_theme")){
    
                showThemePopover = true
            }
            .padding()
            .background(theme.themeColor.mainBackground)
            .cornerRadius(10)
            .popover(isPresented: $showThemePopover, content: {
                ThemePopverMenu(showPopover: $showThemePopover)
            })
            
            OrderButton(icon: "language_Japanese",
                        text: "日本语",
                        bgColor: .white,
                        textColor: .brown) {
                showPopover = true
            }
            .popover(isPresented: $showPopover, content: {
                LanguagePopverMenu(showPopover: $showPopover)
            })
        

                
        }
        .frame(height: 70)
        .padding(.leading,31)
        .padding(.trailing,16)
        .background(theme.themeColor.navBgColor)
    }
}

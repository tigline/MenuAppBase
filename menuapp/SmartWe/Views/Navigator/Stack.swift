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
    @Environment(\.smartwe) var smartwe

    @Environment(\.store.state.sideSelection) var sideSelection
    @Environment(\.store.state.appTheme) var theme
    @State var category:MenuCategory
    @State var showPopover = false
    @State var showThemePopover = false
    var body: some View {
        VStack {
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
                OrderButton(icon: "button_shopping car_ black",
                            text: "買い物かご",
                            bgColor: theme.themeColor.mainBackground,
                            textColor: .black) {
                    
                }
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
                    
            
            
            NavigationStack(path: destinations) {
                MenuListView(menuCategory: category)
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
            
        }.background(theme.themeColor.contentBg)
    }
    
//    // 测试时，屏蔽 Movie 视图，减少 TMDb 网络调用，防止被封
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

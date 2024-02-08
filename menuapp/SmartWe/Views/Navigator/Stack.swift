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
    
    var body: some View {
        VStack {
            HStack{
                
                OrderButton(icon: "button_bell_ White",
                            text: "オーダボタン",
                            bgColor: theme.themeColor.darkRed) {
                    
                }
                OrderButton(icon: "button_bell_ White",
                            text: "注文履歴",
                            bgColor: theme.themeColor.mainBackground) {
                    
                }
                OrderButton(icon: "button_shopping car_ White",
                            text: "買い物かご",
                            bgColor: theme.themeColor.mainBackground) {
                    
                }
                Spacer()
//                OrderButton(icon: "",
//                            text: "Language",
//                            bgColor: theme.themeColor.mainBackground) {
//                    
//                }

                    
            }
            .frame(height: 50)
            .padding(.horizontal)
            .background(theme.themeColor.buttonColor)

            
            Rectangle()
                .fill(Color.gray) // 设置分割线颜色
                    .frame(height: 1)
                    .padding(.leading, 2)
                    
            
            
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
            
        }.background(theme.themeColor.buttonColor)
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

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
    var body: some View {
                VStack {
            HStack{
                Button("オーダボタン", action: {
                    Task {
                        let result = try await smartwe.activeDevice(machineCode:testMachineCode)
                        store.send(.updateMachineInfo(result.data))
                    }
                })
                    .buttonStyle(.bordered)
                Button("注文履歴", action: {})
                    .buttonStyle(.bordered)
                Button("買い物かご", action: {
                    Task {
                        let result = try await smartwe.menuItemList(shopCode: store.state.machineInfo.shopCode, language: store.state.machineInfo.languages[0])
                        print("menuList : \(result)")
                    }
                })
                    .buttonStyle(.bordered)
                Spacer()
                
                Button("Language", action: {})
                    .buttonStyle(.bordered)
            }
            .frame(height: 50)
            .padding(.horizontal)
            //.padding(.vertical, 10)
            
            
            NavigationStack(path: destinations) {
                MenuListView(category: store.state.sideSelection)
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
            //.setBackdropSize()
            
        }
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

struct StackContainer_Previews: PreviewProvider {
    static var previews: some View {
        StackContainer()
    }
}

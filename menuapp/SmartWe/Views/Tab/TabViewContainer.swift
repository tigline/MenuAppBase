//
//  TabViewContainer.swift
//

import Foundation
import SwiftUI

struct SideBarContainer: View {
    @StateObject private var configuration = AppConfiguration.share
    @State private var loader = ShopMenuInfoLoader()

    @Environment(\.store.state.appTheme) var theme
    @Environment(\.menuStore) var menuStore
    
    @State var isLoading = false
    //@State var selectionBar:String?
    
    
    
    var body: some View {
        let _ = Self._printChanges()
        NavigationSplitView {
            
            SideBar()
                .navigationSplitViewColumnWidth(200)
                .background(theme.themeColor.mainBackground)
            
        } detail: {
            StackContainer()
        }
        .environment(\.isLoading, isLoading)
        .onAppear(perform: {
            Task {
                
                isLoading = true
                guard let shopCode = configuration.shopCode else {
                    return
                }
                guard let language = configuration.menuLaguage else {
                    return
                }
                await menuStore.load(shopCode:shopCode, language:language)
                isLoading = false
            }
        })
    }
}

struct SideBar:View {
    
    @Environment(\.store.state.appTheme) var theme
    @Environment(\.menuStore) var menuStore
    @Environment(\.isLoading) private var isLoading
    @StateObject private var configuration = AppConfiguration.share
    @State var showPopover = false
    @Environment(\.appRouter) var appRouter
//    init() {
//        selectionBar = menuStore.catagory
//    }
    
    var selectionBar: Binding<String?> {
        Binding<String?>(
            get: { menuStore.catagory },
            set: {
                menuStore.updateTab($0 ?? "")
                appRouter.updateRouter(.menu($0 ?? ""))
            }
        )
    }
    
    var body: some View {
        let _ = Self._printChanges()

        VStack {
            LogoImageView(path: configuration.logoImage)
                .frame(width:200,height: 50)
                .padding(.top,10)
                .padding(.bottom,30)
                .background(theme.themeColor.mainBackground)
                .gesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .onEnded({ _ in
                            menuStore.updateTab("setting")
                            appRouter.updateRouter(.setting)
                        })
                )
            
            if isLoading {
                Spacer()
                ProgressView().padding(10)
                    .navigationBarTitle("Sidebar", displayMode: .inline)
                    .navigationBarHidden(true)
            } else {
                sidebarList
            }
                
            Spacer()
                
            Button(LocalizedStringKey("log_out")){
                configuration.machineCode = ""
                configuration.loginState = .logout
            }
            .padding()
        }
        
    }
    
    
    
    @ViewBuilder
    var sidebarList: some View {
        List(menuStore.catagorys, id: \.self, selection: selectionBar) { menu in
            
            NavigationLink(value: menu) {
                Label(menu, systemImage: "hand.thumbsup.fill")
                    .padding(.leading)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity, alignment:.leading)
                    .foregroundColor(menuStore.catagory == menu ? .white : .init(hex: "#828282"))
                    .background(menuStore.catagory == menu ? theme.themeColor.buttonColor : Color.clear)
                    .rightHalfRadius(13)
            }
            .listRowBackground(
                Color.clear
            )

        }
        .listStyle(SidebarListStyle())
        .padding(.leading, -25)
        .padding(.trailing, -20)
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, alignment: .leading)
        .scrollContentBackground(.hidden)
    }
}





@Observable
class AppRouter {
    
    var router:Router?
    
    func updateRouter(_ route: Router) {
        router = route
    }
}

enum Router: Hashable {
    
    case menu(String)
    case cart
    case order
    case setting
    
    var id: Router { self }
    
    
}

enum OrderRouter: Hashable {
    case booking
    case shopping
}


struct NavigateEnvironmentKey:EnvironmentKey {
    static var defaultValue: (AppRouter)->Void = {
        #if DEBUG
        print("go to \($0)'s route view")
        #endif
    }
}

struct RouteEnvironmentKey:EnvironmentKey {
    static var defaultValue:AppRouter = AppRouter()
}

extension EnvironmentValues {
//    var router:(AppRouter)->Void {
//        get { self[NavigateEnvironmentKey.self] }
//        set { self[NavigateEnvironmentKey.self] = newValue }
//    }
    
    var appRouter: AppRouter {
        get { self[RouteEnvironmentKey.self] }
        set { self[RouteEnvironmentKey.self] = newValue }
    }
}



//struct TabViewContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        #if os(iOS)
////            TabViewContainer()
////                .environmentObject(Store.share)
////                .previewDevice(.iPhoneName)
//
//        SideBarContainer()
//                .environment(\.deviceStatus, .regular)
//                .previewDevice(.iPadName)
//        #endif
//    }
//}

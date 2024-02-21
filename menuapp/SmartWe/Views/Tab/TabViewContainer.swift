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
            TabViewContainer()
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
//        menuStore.binding(for: \.catagory, toFunction: {
//            //menuStore.updateTab($0 ?? "")
//            router(.menu($0 ?? ""))
//        })
        Binding<String?>(
            get: { menuStore.catagory },
            set: {
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
    
    @ViewBuilder
    var sidebarScroll: some View {
        ScrollView(.vertical) {
            ForEach(menuStore.catagorys, id: \.self) { menu in
                //let menu = index
                Button(action: {
                    menuStore.updateTab(menu)
                }, label: {
                    HStack {
                        
                        Label(menu, systemImage: "hand.thumbsup.fill")
                            .foregroundColor(menuStore.catagory == menu ? .white : .init(hex: "#828282"))
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 15, leading: 30, bottom: 10, trailing: 0))
                    .background(menuStore.catagory == menu ? theme.themeColor.buttonColor : Color.clear)
                    .cornerRadius(10)
                })
                .padding(.vertical)
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.trailing, 5)
            .padding(.leading, -10)
            .navigationBarTitle("Sidebar", displayMode: .inline)
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.themeColor.mainBackground)
        }
        .background(theme.themeColor.mainBackground)
        .scrollIndicators(.hidden)
    }
}



struct TabViewContainer: View {
    @Environment(\.menuStore) var menuStore
    @Environment(\.appRouter) var appRouter
    
    
    var body: some View {
        let _ = Self._printChanges()
        ZStack {
            
            switch appRouter.router {
                case let .menu(categoryName):
                ForEach(menuStore.menuList, id: \.self) { category in
                    if (categoryName == category.categoryName) {
                        StackContainer(category:category)
                            .tag(category.categoryName)
                    }
                }
                //StackContainer(category:categoryName)
                case let .order(order):
                    EmptyView()

                case let .setting:
                    EmptyView()
            }
            
        }

    }
}
//        TabView(selection: selection) {
//            ForEach(categorys, id: \.self) { category in
//                StackContainer(category:category)
//                    .tag(category.categoryName)
//            }
//        }

@Observable
class AppRouter {
    var router:Router = .menu("")

    func updateRouter(_ route: Router) {
        router = route
    }
}

enum Router: Hashable {
    
    case menu(String)
    case order(OrderRouter)
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
    var router:(AppRouter)->Void {
        get { self[NavigateEnvironmentKey.self] }
        set { self[NavigateEnvironmentKey.self] = newValue }
    }
    
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

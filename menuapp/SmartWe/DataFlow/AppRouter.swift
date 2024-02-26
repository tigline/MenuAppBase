//
//  AppRouter.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/26.
//

import SwiftUI

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

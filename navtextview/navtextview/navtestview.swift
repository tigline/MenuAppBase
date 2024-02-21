//
//  navtestview.swift
//  navtextview
//
//  Created by Aaron Hou on 2024/02/21.
//

//
//  Navtestview.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/21.
//


import SwiftUI
import Observation

enum AppScreen: Hashable, Identifiable, CaseIterable {
    
    case backyards
    case birds
    case plants
    
    var id: AppScreen { self }
}

extension AppScreen {
    
    @ViewBuilder
    var label: some View {
        switch self {
            case .backyards:
                Label("Backyards", systemImage: "tree")
            case .birds:
                Label("Birds", systemImage: "bird")
            case .plants:
                Label("Plants", systemImage: "leaf")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .backyards:
                BackyardNavigationStack()
            case .birds:
                BirdsNavigationStack()
            case .plants:
                PlantsNavigationStack()
        }
    }
    
}

@Observable
class Router {
    var birdRoutes: [BirdRoute] = []
    var plantRoutes: [PlantRoute] = []
}

enum PlantRoute {
    case home
    case detail
}

struct Bird: Hashable {
    let name: String
}

enum BirdRoute: Hashable {
    case home
    case detail(Bird)
}

struct BirdsNavigationStack: View {
    
    @Environment(Router.self) private var router
    
    var body: some View {
        
        @Bindable var router = router
        
        NavigationStack(path: $router.birdRoutes) {
            Button("Go to detail") {
                router.birdRoutes.append(.detail(Bird(name: "Sparrow")))
            }.navigationDestination(for: BirdRoute.self) { route in
                switch route {
                    case .home:
                        Text("Home")
                    case .detail:
                        Text("Detail")
                }
            }
        }
    }
}

struct PlantsNavigationStack: View {
    
    @Environment(Router.self) private var router
    
    var body: some View {
        
        @Bindable var router = router
        
        NavigationStack(path: $router.plantRoutes) {
            Button("Plants Go to detail") {
                router.birdRoutes.append(.home)
            }.navigationDestination(for: PlantRoute.self) { route in
                switch route {
                    case .home:
                        Text("Home")
                    case .detail:
                        Text("Plant Detail")
                }
            }
        }
    }
}

struct BackyardNavigationStack: View {
    var body: some View {
        NavigationStack {
            List(1...10, id: \.self) { index in
                NavigationLink {
                    Text("Backyard Detail")
                } label: {
                    Text("Backyard \(index)")
                }
            }.navigationTitle("Backyards")
        }
    }
}


struct AppTabView: View {
    
    @Binding var selection: AppScreen?
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppScreen.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreen?)
                    .tabItem { screen.label }
            }
        }
    }
}

struct ContentViews: View {
    
    @State private var selection: AppScreen? = .backyards
    
    var body: some View {
        AppTabView(selection: $selection)
    }
}

#Preview {
    ContentViews()
        .environment(Router())
}


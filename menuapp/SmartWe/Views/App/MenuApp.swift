//
//  MovieHunterApp.swift
//

import SwiftUI

@main
struct MenuApp: App {
    let stack = CoreDataStack.shared
    @State var appConfiguration = AppConfiguration()
    var body: some Scene {
        WindowGroup {
            ContentView(model: ContentView.Model(configuration: appConfiguration))
                .environment(\.managedObjectContext, stack.container.viewContext)
                .environmentObject(appConfiguration)
        }
        #if os(macOS)
        .defaultSize(width: 1024, height: 800)
        .defaultPosition(.center)
        #endif

        #if os(macOS)
            Settings {
                SettingContainer()
            }

            MenuBarExtra {
                MenuBar()
            } label: {
                Image(systemName: "film.fill")
            }
            .menuBarExtraStyle(.menu)

            WindowGroup(id: windowGroupID, for: Category.self) { category in
                ContentView(category: category.wrappedValue)
                    .environment(\.managedObjectContext, stack.viewContext)
            }
            .defaultSize(width: 1024, height: 800)
            .defaultPosition(.center)
        #endif
    }
}

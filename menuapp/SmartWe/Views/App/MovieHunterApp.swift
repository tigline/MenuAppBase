//
//  MovieHunterApp.swift
//

import SwiftUI

@main
struct MovieHunterApp: App {
    let stack = CoreDataStack.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, stack.container.viewContext)
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

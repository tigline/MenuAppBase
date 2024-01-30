//
//  menuappApp.swift
//  menuapp
//
//  Created by Aaron Hou on 2024/01/30.
//

import SwiftUI

@main
struct menuappApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  navtextviewApp.swift
//  navtextview
//
//  Created by Aaron Hou on 2024/02/21.
//

import SwiftUI

@main
struct navtextviewApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

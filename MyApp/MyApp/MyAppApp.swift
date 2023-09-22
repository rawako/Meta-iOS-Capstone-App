//
//  MyAppApp.swift
//  MyApp
//
//  Created by Rawand Rzgar on 2023-09-22.
//

import SwiftUI

@main
struct MyAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

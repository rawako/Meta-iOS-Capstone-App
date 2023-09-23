//
//  MyAppApp.swift
//  MyApp
//
//  Created by Rawand Rzgar on 2023-09-22.
//

import Foundation
import SwiftUI
import CoreData

@main
struct MyAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

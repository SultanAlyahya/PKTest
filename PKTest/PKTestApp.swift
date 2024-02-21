//
//  PKTestApp.swift
//  PKTest
//
//  Created by Sultan alyahya on 11/08/1445 AH.
//

import SwiftUI

@main
struct PKTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

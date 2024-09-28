//
//  PlanITselfApp.swift
//  PlanITself
//
//  Created by 김동한 on 26/09/2024.
//

import SwiftUI

@main
struct PlanITselfApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

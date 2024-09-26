//
//  PlanItApp.swift
//  PlanIt
//
//  Created by 김동한 on 26/09/2024.
//

import Foundation
import SwiftUI

@main
struct PlanItApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.viewContext)  // Core Data 컨텍스트를 전달
        }
    }
}

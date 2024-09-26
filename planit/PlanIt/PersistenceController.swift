//
//  PersistenceController.swift
//  PlanIt
//
//  Created by 김동한 on 26/09/2024.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PlanIt")  // "PlanIt"은 Core Data 모델 이름
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
}


//
//  CoreDataManager.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    var context: NSManagedObjectContext { get }
    func saveContext() throws
}

class CoreDataManager: CoreDataManagerProtocol {

    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "myTunesApp")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              print("Failed to load persistent store: \(error)")
          } else {
              print("Persistent store loaded successfully")
          }
      })

        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw error
            }
        }
    }
}

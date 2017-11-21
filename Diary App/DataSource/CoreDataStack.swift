//
//  CoreDataStack.swift
//  Diary App
//
//  Created by Angus Muller on 08/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//


import Foundation
import CoreData

class CoreDataStack {
    
    // The managed object context associated with the main queue.
    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()
    
    // Use NSPersistentCotainer that handles the creation of the managedObjectModel, the persistentStoreCoordinator and the managedObjectContext.
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores() { storeDescription, error in
            if let error = error as NSError? {
                // NOTE Temp error handling - Better handle this error for user
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
}

extension NSManagedObjectContext {
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                fatalError("Error: \(error.localizedDescription)") // Note in production app this would need changed
            }
        }
    }
}

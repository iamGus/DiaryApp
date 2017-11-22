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
    
    
    
    // This below function is currently unused. I had the idea of trying to take out some of the entry object creation from the Detailviewcontroller into here but have not managed to to do this yet.
    func insertEntryItem(text: String?, dateCreated: NSDate?, dateEdited: NSDate?, location: String?, moodStatus: Mood?) -> Entry? {
        guard let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as? Entry else { return nil }
        //An entry must not be allwoed to be created if no text so return nill
        guard let text = text else { return nil }
        
        entry.dateCreated = dateCreated
        entry.dateEdited = dateEdited
        entry.text = text
        entry.location = location
        entry.moodStatus = moodStatus ?? .none
        
        return entry
    }
    
}

extension NSManagedObjectContext {
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                print("Error: \(error.localizedDescription)") // Note in production app this would need changed
            }
        }
    }

}

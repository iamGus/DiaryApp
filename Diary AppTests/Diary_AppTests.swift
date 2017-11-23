//
//  Diary_AppTests.swift
//  Diary AppTests
//
//  Created by Angus Muller on 08/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import XCTest
@testable import Diary_App
import CoreData

class Diary_AppTests: XCTestCase {
    
   // Entry test data
    var newEntry: Entry?
    var entryText = "Some text for an entry"
    
    // Core Data properties
    let managedObjectContext = CoreDataStack().managedObjectContext
    
    lazy var testFetchedResultsController: NSFetchedResultsController<Entry> = {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
 
    
    override func setUp() {
        super.setUp()
        
        deleteAll()
        
        // Create new entry
        newEntry = Entry.insertNewEntry(inManagedObjectContext: managedObjectContext, text: entryText)
        if newEntry != nil {
            newEntry?.text = entryText
        }
        self.managedObjectContext.saveChanges()
        
       tryFetch()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        // Delete all entries in Entry entity
        deleteAll()
    }
    
    func testCreateEntry() {
        print(testFetchedResultsController.fetchedObjects?.count)
        //XCTAssert(testFetchedResultsController.fetchedObjects?.count != Optional(0), "Error creating entry")
        XCTAssertNotNil(newEntry, "Error creating entry")
    
    }
    
    func testEditEntry() {
        XCTAssertNotNil(newEntry, "Error creating entry")
        let newText = "Updated text"
        newEntry?.text = newText
        self.managedObjectContext.saveChanges()
        tryFetch()
        XCTAssert(newEntry?.text == newText, "Error updating entry, text did not change")
    }
    
    func testDeleteEntry() {
        XCTAssertNotNil(newEntry, "Error creating entry")
        if let entry = testFetchedResultsController.fetchedObjects?.first {
           self.managedObjectContext.delete(entry)
           self.managedObjectContext.saveChanges()
        }
        
        tryFetch()
        
        XCTAssert(testFetchedResultsController.fetchedObjects?.count == Optional(0), "Error deleteing entry")
    }
    
    //MARK: Helpers
    
    // Delete all entries in Entry entity
    func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.managedObjectContext.execute(batchDeleteRequest)
        } catch {
            print("Remove all error: \(error)")
        }
    }
    
    func tryFetch() {
        do {
            try testFetchedResultsController.performFetch()
        } catch {
            //NOTE Need to handle error with user
            print("Error fetching item objects: \(error.localizedDescription)")
        }
    }
    
}

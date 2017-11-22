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
    var text: String?
    var newEntry: Entry?

    
    // Core Data properties
    let managedObjectContext = CoreDataStack().managedObjectContext
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    

    
    override func setUp() {
        super.setUp()

        do {
                try fetchedResultsController.performFetch()
            } catch {
                    print("Error fetching item objects: \(error.localizedDescription)")
            }
        
        
        self.text = "dfd"
        let entity = NSEntityDescription.entity(forEntityName: "Entry", in: self.managedObjectContext)
        newEntry = Entry(entity: entity!, insertInto: managedObjectContext)
        newEntry?.text = "ddddh"
        self.managedObjectContext.saveChanges()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        self.text = nil
        
        // Delete all entries in Entry entity
        
        deleteAll()
    }
    
    func testCreateEntry() {
        
        //print("section count is: \(fetchedResultsController.sections?.count)")
        print("Objects count is: \(fetchedResultsController.fetchedObjects?.count)")
        print(newEntry)
        
        XCTAssert(fetchedResultsController.fetchedObjects?.count != Optional(0), "Error creating entry")
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
    
}

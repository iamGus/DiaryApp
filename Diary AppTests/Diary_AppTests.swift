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
    
    var text: String?
    var dateCreated: NSDate?
    var dateEdited: NSDate?
    
    let managedObjectContext = CoreDataStack().managedObjectContext
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    override func setUp() {
        super.setUp()
        
        self.text = "dfd"
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
}

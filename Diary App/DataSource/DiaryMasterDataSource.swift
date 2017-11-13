//
//  DiaryMasterDataSource.swift
//  Diary App
//
//  Created by Angus Muller on 13/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit
import CoreData

class DiaryMasterDataSource: NSObject, UITableViewDataSource {
    private let tableView: UITableView
    private let managedObjectContext: NSManagedObjectContext
    
    // Use fetched results controller
    lazy var fetchedResultsController: DiaryFetchedResultsController = {
        return DiaryFetchedResultsController(managedObjectContext: self.managedObjectContext, tableView: self.tableView)
    }()
    
    init(tableView: UITableView, context: NSManagedObjectContext) {
        self.tableView = tableView
        self.managedObjectContext = context
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        
        return configureCell(cell, at: indexPath)
    }
    
    // Set action for delete button
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let entry = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(entry)
        managedObjectContext.saveChanges()
    }
    
    // Helper to return configured cell
    private func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) -> UITableViewCell {
        let entry = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = entry.text
        cell.detailTextLabel?.text = entry.dateCreated?.description
        
        return cell
    }
    
    func object(at indexPath: IndexPath) -> Entry {
        return fetchedResultsController.object(at: indexPath)
    }
 
}

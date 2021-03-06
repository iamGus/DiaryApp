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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = fetchedResultsController.sections?[section] else { return nil }
        return section.name
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier, for: indexPath) as! EntryCell
        
        let entry = fetchedResultsController.object(at: indexPath)
        let viewModel = EntryCellViewModel(entry: entry) // get viewmodel of cell
        
        cell.configure(with: viewModel) // Pass viewmodel of cell to cell view
        
        return cell
    }
    
    // Set action for delete button
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let entry = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(entry)
        managedObjectContext.saveChanges()
    }
    
    // Helper to return configured cell

    
    func object(at indexPath: IndexPath) -> Entry {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func todaysDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, YYYY"
        return formatter.string(from: date)
    }
 
}

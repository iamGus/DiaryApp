//
//  DiaryMasterController.swift
//  Diary App
//
//  Created by Angus Muller on 09/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit
import CoreData

class DiaryMasterController: UITableViewController {
    
    @IBOutlet weak var topTitleLabel: UINavigationItem!
    
    
    let managedObjectContext = CoreDataStack().managedObjectContext
    
    lazy var dataSource: DiaryMasterDataSource = {
        return DiaryMasterDataSource(tableView: self.tableView, context: managedObjectContext)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 170
        topTitleLabel.title = dataSource.todaysDate()
        
        
    }
    
    // Mark: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    
    
   //NOTE - check below guard let error handling
    
    // MARK: Navigation
    
    // NOTE: The managedObjectContext instance on NewEntryController is using dependency Injection so is using same as MasterDetail. May need to change to singleton object depending on how using seperate view for cell.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newEntry" {
            let newEntryController = segue.destination as! NewEntryController
            newEntryController.managedObjectContext = self.managedObjectContext // send referance of context
        } else if segue.identifier == "showDetail" {
            guard let detailsViewController = segue.destination as? NewEntryController, let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let entry = dataSource.object(at: indexPath)
            detailsViewController.currentEntry = entry // pass over selected entry data
            detailsViewController.managedObjectContext = self.managedObjectContext // send referance of context
        }
    }

}


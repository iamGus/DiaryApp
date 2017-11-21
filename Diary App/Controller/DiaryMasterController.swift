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
        tableView.estimatedRowHeight = 150
        topTitleLabel.title = dataSource.todaysDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emptyTablePlaceholder() // show default text when tableview is empty
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
            let newEntryController = segue.destination as! DetailEntryController
            newEntryController.managedObjectContext = self.managedObjectContext // send referance of context
        } else if segue.identifier == "showDetail" {
            guard let detailsViewController = segue.destination as? DetailEntryController, let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let entry = dataSource.object(at: indexPath)
            detailsViewController.currentEntry = entry // pass over selected entry data
            detailsViewController.managedObjectContext = self.managedObjectContext // send referance of context
        }
    }

}

// show default text when tableview is empty
extension DiaryMasterController {
    func emptyTablePlaceholder(){
        if self.tableView.visibleCells.isEmpty {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
            //tableView.backgroundColor = UIColor.clearColor()
            
            let label = UILabel()
            label.frame.size.height = 42
            label.frame.size.width = (tableView.frame.size.width-10)
            label.center = tableView.center
            label.center.y = (tableView.frame.size.height/2.2)
            label.numberOfLines = 0
            label.textColor = UIColor.darkGray
            label.text = "You have not added any Diary entries yet. Use green pencil at top right."
            label.textAlignment = .center
            label.tag = 1
            
            self.tableView.addSubview(label)
        }else{
            self.tableView.viewWithTag(1)?.removeFromSuperview()
        }
    }
}


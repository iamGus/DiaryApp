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
    
    let managedObjectContext = CoreDataStack().managedObjectContext
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching item objects: \(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)

        return configureCell(cell, at: indexPath)
    }
    
    // Helper to return configured cell
    private func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) -> UITableViewCell {
        let entry = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = entry.text
        cell.detailTextLabel?.text = entry.dateCreated?.description
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Navigation
    
    // NOTE: The managedObjectContext instance on NewEntryController is using dependency Injection so is using same as MasterDetail. May need to change to singleton object depending on how using seperate view for cell.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newEntry" {
            let newEntryController = segue.destination as! NewEntryController
            newEntryController.managedObjectContext = self.managedObjectContext
        }
    }

}

extension DiaryMasterController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

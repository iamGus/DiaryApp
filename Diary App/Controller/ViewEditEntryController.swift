//
//  ViewEditEntryController.swift
//  Diary App
//
//  Created by Angus Muller on 10/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit
import CoreData

class ViewEditEntryController: UIViewController {
    
    @IBOutlet weak var textField: UITextView!
    
    var entry: Entry?
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let entry = entry {
            textField.text = entry.text
        }
    }
    
    // Updating an entry
    @IBAction func save(_ sender: Any) {
        guard let newText = textField.text, !newText.isEmpty else { return /* Note return popup of empty text */  }
        if let entry = entry {
            entry.text = newText
            context.saveChanges()
            navigationController?.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

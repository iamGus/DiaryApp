//
//  NewEntryController.swift
//  Diary App
//
//  Created by Angus Muller on 10/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit
import CoreData

class NewEntryController: UIViewController {
    
    @IBOutlet weak var textField: UITextView!
    
    var managedObjectContext: NSManagedObjectContext!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

 
    @IBAction func save(_ sender: Any) {
        
        guard let text = textField.text, !text.isEmpty else { return /* Note return popup of empty text */ } 
        
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as! Entry
        
        entry.text = text
        
        managedObjectContext.saveChanges()
        
        self.navigationController?.popViewController(animated: true)
        
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

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
    @IBOutlet weak var textFieldCountLabel: UILabel!
    
    var managedObjectContext: NSManagedObjectContext!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self

        // Do any additional setup after loading the view.
    }
    @objc static func didEnterText() {
        print("wohoo")
    }
 
    @IBAction func save(_ sender: Any) {
        
        guard let text = textField.text, !text.isEmpty else { return /* Note return popup of empty text */ }
        
        // Check characters entered in text field
        if textField.text.count > 200 {
            return print("Sorry you have exceeded the count")
        }
        
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
// UITableView delegate - Update count
extension NewEntryController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textFieldCountLabel.text = String(textField.text.count)
        if textField.text.count <= 200 {
            textFieldCountLabel.textColor = UIColor.init(red: 125/255, green: 156/255, blue: 91/255, alpha: 1)
        } else {
            textFieldCountLabel.textColor = UIColor.red
        }
    }
}

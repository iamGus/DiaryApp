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
    
    @IBOutlet weak var addLocationButtonLabel: UIButton!
    var managedObjectContext: NSManagedObjectContext!
    var locationText: String? // Store location from Location VC
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self

        // Do any additional setup after loading the view.
    }
    @objc static func didEnterText() {
        print("wohoo")
    }
 
    @IBAction func save(_ sender: Any) {
        
        guard let text = textField.text, !text.isEmpty else {
            self.showAlert(title: "Alert", message: "You cannot save an entry without text, please first enter text")
            return
        }
        
        // Check characters entered in text field
        if textField.text.count > 200 {
            self.showAlert(title: "Alert", message: "Your text exceeds the 200 characters limit, please shorten")
            return
        }
        
    
        
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as! Entry
        
        entry.text = text
        
        // Check if locationText property has text, if it does then put into entry
        if let locationText = locationText {
            entry.location = locationText
        }
        
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
    
    // Unwinde From CurrentLocationController
    @IBAction func unwindFromLocationVC(_ sender: UIStoryboardSegue) {
        if sender.source is CurrentLocationController {
            if let senderVC = sender.source as? CurrentLocationController {
                if let senderVCLocationText = senderVC.locationText {
                    self.locationText = senderVCLocationText
                    addLocationButtonLabel.setTitle(senderVCLocationText, for: .normal) //loaction button text update
                }
            }
        }
    }

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

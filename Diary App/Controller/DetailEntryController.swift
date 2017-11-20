//
//  DetailEntryController.swift
//  Diary App
//
//  Created by Angus Muller on 10/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit
import CoreData

class DetailEntryController: UIViewController {
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var textFieldCountLabel: UILabel!
    
    @IBOutlet weak var addLocationButtonLabel: UIButton!
    
    @IBOutlet weak var monthTopHeadingLabel: NSLayoutConstraint!
    @IBOutlet weak var dateHeadingLabel: UILabel!
    @IBOutlet weak var badButtonLabel: UIButton!
    @IBOutlet weak var averageButtonLabel: UIButton!
    @IBOutlet weak var goodButtonLabel: UIButton!
    @IBOutlet weak var moodIcon: UIImageView!
    
    
    var managedObjectContext: NSManagedObjectContext!
    var currentEntry: Entry? // If viewing current entry master VC passes entry to here
    var locationText: String? // Store location from Location VC
    var mood: Mood = .none {
        didSet {
            // Set mood icon
            switch self.mood {
            case .none: moodIcon.image = nil
            case .happy: moodIcon.image = #imageLiteral(resourceName: "icn_happy")
            case .average: moodIcon.image = #imageLiteral(resourceName: "icn_average")
            case .bad: moodIcon.image = #imageLiteral(resourceName: "icn_bad")
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self

        // Check if this is an existing entry or a new entry. If exisiting then populate fields:
        if let currentEntry = currentEntry {
            textField.text = currentEntry.text
            mood = currentEntry.moodStatus
            textViewDidChange(textField)
            
            if let location = currentEntry.location {
                addLocationButtonLabel.setTitle(location, for: .normal)
            }
        }
        
    }
 
    // Saving changes or adding new entry
    @IBAction func save(_ sender: Any) {
        
        // Check textfield not empty
        guard let text = textField.text, !text.isEmpty else {
            self.showAlert(title: "Alert", message: "You cannot save an entry without text, please first enter text")
            return
        }
        
        // Check characters entered in text field
        if textField.text.count > 200 {
            self.showAlert(title: "Alert", message: "Your text exceeds the 200 characters limit, please shorten")
            return
        }
        
        if let currentEntry = currentEntry { // If data in current Entry property then we are editing an entry
            
            currentEntry.text = text
            
            // Check if mood selected, if there is one then put into entry
            if mood != .none {
                currentEntry.moodStatus = mood
            }
            
            // Check if locationText property has text, if it does then put into entry
            if let locationText = locationText {
                currentEntry.location = locationText
                print("In current entry")
            }
            
        } else { // Else it must be a new entry
            let newEntry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as! Entry
            
            newEntry.text = text
            
            // Check if mood selected, if there is one then put into entry
            if mood != .none {
                newEntry.moodStatus = mood
            }
            
            // Check if locationText property has text, if it does then put into entry
            if let locationText = locationText {
                newEntry.location = locationText
                print("In new entry")
            }
            
        }
        
        managedObjectContext.saveChanges()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
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
    
    @IBAction func moodButtonAction(_ sender: UIButton) {
        switch sender {
        case badButtonLabel:
            mood = .bad
        case averageButtonLabel: mood = .average
        case goodButtonLabel: mood = .happy
        default: mood = .none
        }
    }
    

}

// UITableView delegate - Update count
extension DetailEntryController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textFieldCountLabel.text = String(textField.text.count)
        if textField.text.count <= 200 {
            textFieldCountLabel.textColor = UIColor.init(red: 125/255, green: 156/255, blue: 91/255, alpha: 1)
        } else {
            textFieldCountLabel.textColor = UIColor.red
        }
    }
}

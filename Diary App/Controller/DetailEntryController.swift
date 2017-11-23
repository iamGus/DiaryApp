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
    @IBOutlet weak var monthTopHeadingLabel: UILabel!
    @IBOutlet weak var dateHeadingLabel: UILabel!
    @IBOutlet weak var badButtonLabel: UIButton!
    @IBOutlet weak var averageButtonLabel: UIButton!
    @IBOutlet weak var goodButtonLabel: UIButton!
    @IBOutlet weak var moodIcon: UIImageView!
    @IBOutlet weak var lastUpdatedHeadingLabel: UILabel!
    @IBOutlet weak var lastUpdatedDateLabel: UILabel!
    
    
    
    // Properties
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
        
        // MARK: Keyboard display and remove
        
            // Observers for keyboard appearing and hiding
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
            // If user touches screen when keyboard shown
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
        
        textField.delegate = self

        // Check if this is an existing entry or a new entry. If exisiting then populate fields:
        if let currentEntry = currentEntry {
            textField.text = currentEntry.text
            mood = currentEntry.moodStatus
            textViewDidChange(textField)
            
            // Check there is a date in dateCreated
            if let dateCreated = currentEntry.dateCreated {
                dateHeadingLabel.text = Helper.titleDate(date: dateCreated)
                monthTopHeadingLabel.text = Helper.detailTopDate(date: dateCreated)
            } else {
                dateHeadingLabel.text = "Date Unknown"
                monthTopHeadingLabel.text = "Date Unknown"
            }
            
            
            // Check if entry has an edited date
            if let dateEdited = currentEntry.dateEdited {
                lastUpdatedDateLabel.text = Helper.titleDate(date: dateEdited)
                
            // If it does not have an edited date then hide lables
            } else {
                lastUpdatedHeadingLabel.isHidden = true
                lastUpdatedDateLabel.isHidden = true
            }
            if let location = currentEntry.location {
                addLocationButtonLabel.setTitle(location, for: .normal)
            }
        
        } else {
            // Must be a new entry
            // Set Date title to todays date
            dateHeadingLabel.text = Helper.titleDate()
            monthTopHeadingLabel.text = Helper.detailTopDate()
            lastUpdatedHeadingLabel.isHidden = true
            lastUpdatedDateLabel.isHidden = true
            
        }
        
    }
 
    // Saving changes or adding new entry
    @IBAction func save(_ sender: Any) {
        
        // Check textfield not empty
        guard let text = textField.text, !text.isEmpty else {
            self.showAlert(title: "Alert", message: "You cannot save an entry without text, please first enter text")
            return
        }
        
        // Check if max characters have been entered in text field
        if textField.text.count > 200 {
            self.showAlert(title: "Alert", message: "Your text exceeds the 200 characters limit, please shorten")
            return
        }
        
        if let currentEntry = currentEntry { // If data in current Entry property then we are editing an entry
            
            currentEntry.text = text // Put current text into textfield
            
            // Check if mood selected, if there is one then put into entry
            if mood != .none {
                currentEntry.moodStatus = mood
            }
            
            // Check if locationText property has text, if it does then put into entry
            if let locationText = locationText {
                currentEntry.location = locationText
                print("In current entry")
            }
            
            // Updated date edited date to todays date
            currentEntry.dateEdited = NSDate()
            
        } else { // Else it must be a new entry
            //Make new insertobject checking first that their is text for the entry. The text should have already been checked above but by having this insertNewEntry method it makes sure that the text has been checked.
            guard let newEntry = Entry.insertNewEntry(inManagedObjectContext: managedObjectContext, text: text) else {
                return
            }
            
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
    
    // Mood buttons action, set mood property
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

// UITableView delegate - Update character count
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

// MARK: Additional keyboard setup
extension DetailEntryController {
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    // Used when user touches outside textfield to close keyboard
    @objc func dismissKeyboard() {
        textField.resignFirstResponder()
    }
}

//
//  Entry+CoreDataClass.swift
//  Diary App
//
//  Created by Angus Muller on 10/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//
//

import Foundation
import CoreData


public class Entry: NSManagedObject {
    
    // Set date for when entry created and update edited date when edited.
    
    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        self.dateCreated = NSDate()
        
        self.mood = 0 //Set mood to 0 = Mood.none
    }
    
    // An entry must have text to be bale to be insrted into objectContext so the below method checks this before returning an instance of Entry
    class func insertNewEntry(inManagedObjectContext managedObjectContext: NSManagedObjectContext, text: String?) -> Entry? {
        guard let text = text else {
            return nil
        }
        
        guard let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as? Entry else { return nil }
        
        return entry
    }
    
    // Format month then year into string
    func dateMonth() -> String {
        guard let dateCreated = dateCreated else {
            return "Date unknown"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.string(from: dateCreated as Date)
    }
    
    // Format month then year into string
    var computedMonth: String {
        guard let dateCreated = dateCreated else {
            return "Date unknown"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.string(from: dateCreated as Date)
    }
 
}

enum Mood: Int {
    case none, happy, average, bad
}

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
        self.dateEdited = NSDate()
        self.mood = 0 //Set mood to 0
    }
    
    func dateMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.string(from: dateCreated as Date)
    }
 
}

enum Mood: Int {
    case none, happy, average, bad
}

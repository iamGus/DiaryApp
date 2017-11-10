//
//  Entry+CoreDataProperties.swift
//  Diary App
//
//  Created by Angus Muller on 10/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        //Return the entries in order of date created
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        return request
    }

    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var dateEdited: NSDate?
    @NSManaged public var location: String?
    @NSManaged public var mood: Int16
    @NSManaged public var text: String?

}

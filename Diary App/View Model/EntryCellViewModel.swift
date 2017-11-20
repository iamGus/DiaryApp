//
//  EntryCellViewModel.swift
//  Diary App
//
//  Created by Angus Muller on 13/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

struct EntryCellViewModel {
    let dateTitle: String
    let text: String
    let mood: Mood
    let location: String?
}

extension EntryCellViewModel {
    init(entry: Entry) {
        // Format date for date title
        self.dateTitle = Helper.titleDate(date: entry.dateCreated)
        self.text = entry.text
        self.mood = entry.moodStatus
        self.location = entry.location
    }
}





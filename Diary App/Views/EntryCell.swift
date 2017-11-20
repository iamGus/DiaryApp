//
//  EntryCell.swift
//  Diary App
//
//  Created by Angus Muller on 13/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
    
    static let reuseIdentifier = "EntryCell"
    
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var entryTextLabel: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var locationTextLabel: UILabel!
    @IBOutlet weak var moodIcon: UIImageView!
    @IBOutlet weak var contentsViewBottomConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with viewModel: EntryCellViewModel) {
        dateTitleLabel.text = viewModel.dateTitle
        entryTextLabel.text = viewModel.text
        
        if let location = viewModel.location {
            locationTextLabel.text = location
        } else {
            // Hide location elements as there is no location text
            locationIcon.isHidden = true
            locationTextLabel.isHidden = true
            contentsViewBottomConstraint.constant = 0
        }
        
        // Set mood icon
        switch viewModel.mood {
        case .none: moodIcon.image = nil
        case .happy: moodIcon.image = #imageLiteral(resourceName: "icn_happy")
        case .average: moodIcon.image = #imageLiteral(resourceName: "icn_average")
        case .bad: moodIcon.image = #imageLiteral(resourceName: "icn_bad")
        }
        
    }

}

//
//  Helper.swift
//  Diary App
//
//  Created by Angus Muller on 15/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

class Helper {
    // Return correctly formatted date for entry date title
    static func titleDate(date: NSDate = NSDate()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "EEEE d MMMM"
        
        return dateFormatter.string(from: date as Date)
    }
    
    static func detailTopDate(date: NSDate = NSDate()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMMM YYYY"
        
        return dateFormatter.string(from: date as Date)
    }
}

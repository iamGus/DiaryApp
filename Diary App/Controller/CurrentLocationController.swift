//
//  CurrentLocationController.swift
//  Diary App
//
//  Created by Angus Muller on 16/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

class CurrentLocationController: UIViewController {
    
    // MARK: Properties
    
    lazy var locationManager: LocationManager = {
        return LocationManager(delegate: self, permissionsDelegate: nil)
    }()
    
    var coordinate: Coordinate?
    
    var isAuthorized: Bool {
        let isAuthorizedForLocation = LocationManager.isAuthorized
        
        return isAuthorizedForLocation
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isAuthorized {
            locationManager.requestLocation()
        } else {
            //Do Permissions
            print("do permissions")
        }
    }

    // MARK: Permissions
    //To setup permissions func
    

}

// MARK: - Location Manager Delegate
extension CurrentLocationController: LocationManagerDelegate {
    func obtainedCoordinates(_ coordinate: Coordinate) {
        self.coordinate = coordinate
       
    }
    
    func failedWithError(_ error: LocationError) {
        print(error)
    }
}

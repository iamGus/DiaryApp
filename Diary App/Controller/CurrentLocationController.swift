//
//  CurrentLocationController.swift
//  Diary App
//
//  Created by Angus Muller on 16/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationController: UIViewController {
    
    // MARK: Properties
    
    lazy var locationManager: LocationManager = {
        return LocationManager(delegate: self, permissionsDelegate: self)
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
            requestLocationPermissions()
        }
    }

    // MARK: Permissions
    //To setup permissions func
    func requestLocationPermissions() {
        do {
            try locationManager.requestLocationAuthorization()
        } catch LocationError.disallowedByUser {
            // Show alert to user
        } catch let error {
            print("Location Authorization Error: \(error.localizedDescription)")
        }
    }

}

// MARK: - Location Manager Delegate
extension CurrentLocationController: LocationManagerDelegate {
    func obtainedCoordinates(_ coordinate: Coordinate) {
        self.coordinate = coordinate
        print(coordinate)
       
    }
    
    func failedWithError(_ error: LocationError) {
        print(error)
    }
}

//Mark: Location Permissions Delegate
extension CurrentLocationController: LocationPermissionsDelegate {
    
    
    func authorizationSucceeded() {
        // NOTE: I Do not know if i need t oenter anything in here
        print("hit auhtorizationsucceeded func")
        locationManager.requestLocation()
    }
 
    
    func authorizationFailedWithStatus(_ status: CLAuthorizationStatus) {
        
        let alertController = UIAlertController(title: "Need permission", message: "Message", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) {
            UIAlertAction in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: { (success) in
                                                print("Open \(UIApplicationOpenSettingsURLString): \(success)")
                    })
                } else {
                    let success = UIApplication.shared.openURL(url)
                    print("Open \(UIApplicationOpenSettingsURLString): \(success)")
                }
            }
        }
        
        alertController.addAction(okAction)
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

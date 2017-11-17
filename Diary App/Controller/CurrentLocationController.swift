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
    
    var locationText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isAuthorized {
            locationManager.requestLocation() // If already authorised then go ahead and request lcoation
        } else {
            //Else if not authorised then request permission
            requestLocationPermissions()
        }
    }

    // MARK: Permissions
    //To setup permissions func
    func requestLocationPermissions() {
        do {
            try locationManager.requestLocationAuthorization()
        } catch LocationError.disallowedByUser {
            // NOTE: This is where you would normaly have code bringing up alert to user that they need to change settings to allow the app to know location. But the didChangeAuthorization in locationManager is being triggered even when the authorization status has not changed meaning that the authroization failed with status deligate is being triggered which then brings up the correct UIAlert and thus why I have not put any code in here.
           
        } catch let error {
            print("Location Authorization Error: \(error.localizedDescription)")
        }
    }

}

// MARK: - Location Manager Delegate
extension CurrentLocationController: LocationManagerDelegate {
    func obtainedCoordinates(_ coordinate: CLLocation) {
        
        locationManager.getPlacemark(forLocation: coordinate) { (originPlacemark, error) in
            if let error = error {
                print(error) //NOTE: need to deal with this
                
            } else if let placemark = originPlacemark?.locality {
                
                self.locationText = placemark
                self.performSegue(withIdentifier: "unwindFromLocation", sender: self)
                
            } else {
                // No text data for locality, return to view and show popup
            }
        }
       
    }
    
    func failedWithError(_ error: LocationError) {
        print(error)
    }
}

//Mark: Location Permissions Delegate
extension CurrentLocationController: LocationPermissionsDelegate {
    
    
    func authorizationSucceeded() {
        // location manager permission returns scucess so go ahead and now request lcoation
        locationManager.requestLocation()
    }
 
    
    func authorizationFailedWithStatus(_ status: CLAuthorizationStatus) {
        // Meaning authorization is denied so ask user to allow permissions in settings
        let alertController = UIAlertController(title: "Permission Request", message: "Location permission is currently not allowed, please change in settings so app can find your location", preferredStyle: .alert)
        
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

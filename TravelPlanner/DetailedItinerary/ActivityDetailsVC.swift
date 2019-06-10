//
//  ActivityDetailsVC.swift
//  TravelPlanner
//
//  Created by Liang Cheung on 6/9/19.
//  Copyright © 2019 LZCHEUNG. All rights reserved.
//

import UIKit
import MapKit
import Contacts
import CoreLocation

class ActivityDetailsVC: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var navigationSegment: UISegmentedControl!
    
    var activity: Activity?
    var placemark: MKPlacemark?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureLocationManager()
        
        if let data = activity {
            nameLabel.text = data.name
            startTimeLabel.text = "Start Time: \(Activity.timeFormatter.string(from: data.startTime))"
            endTimeLabel.text = "End Time: \(Activity.timeFormatter.string(from: data.endTime))"
            addressLabel.text = data.address
        }
    }
    
    func configureLocationManager() {
        CLLocationManager.locationServicesEnabled()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = 1.0
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func openDirections(_ sender: UIButton) {
        if let selectedPlacemark = placemark, let userlocation = locationManager.location {
            let curLocation = MKPlacemark(coordinate: userlocation.coordinate)
            let destinationMapItem = MKMapItem(placemark: selectedPlacemark)
            let sourceMapItem = MKMapItem(placemark: curLocation)
            var directionMode = MKLaunchOptionsDirectionsModeDriving
            
            switch navigationSegment.selectedSegmentIndex {
            case 0:
                directionMode = MKLaunchOptionsDirectionsModeDriving
            case 1:
                directionMode = MKLaunchOptionsDirectionsModeWalking
            case 2:
                directionMode = MKLaunchOptionsDirectionsModeTransit
            default:
                break;
            }
            
            
            let mapItems = [sourceMapItem, destinationMapItem]
            let directionOptions = [MKLaunchOptionsDirectionsModeKey: directionMode]
            MKMapItem.openMaps(with: mapItems, launchOptions: directionOptions)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editActivity" {
            let destinationVC = segue.destination as! UINavigationController
            let editActivityVC = destinationVC.viewControllers[0] as! EditActivityVC
            editActivityVC.newActivity = activity
        }
    }

}

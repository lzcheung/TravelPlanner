//
//  DailyActivityTVC.swift
//  TravelPlanner
//
//  Created by Liang Cheung on 5/28/19.
//  Copyright © 2019 LZCHEUNG. All rights reserved.
//

import UIKit
import MapKit

class DailyActivityTVC: UIViewController {
    enum ActivityVCMode {
        case table
        case map
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toggleButton: UIBarButtonItem!
    @IBOutlet weak var addActivityButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var dateFormatter = DateFormatter()
    var viewMode = ActivityVCMode.table {
        didSet {
            if viewMode != oldValue {
                updateCurrentView()
            }
        }
    }
    var activities: Activities?
    let dataStore = DataStorage.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "h:mm a"
        roundButton(addActivityButton)
        
        updateMapAnnotations()
        showRouteOnMap()
    }
    
    func roundButton(_ component: UIView) {
        component.layer.cornerRadius = 20
        component.clipsToBounds = true
    }
    
    func updateCurrentView() {
        if viewMode == .table {
            mapView.isHidden = true
            tableView.isHidden = false
            addActivityButton.isHidden = false
            toggleButton.title = "Map"
        } else {
            tableView.isHidden = true
            mapView.isHidden = false
            toggleButton.title = "List"
            addActivityButton.isHidden = false
            mapView.showAnnotations(mapView.annotations, animated: false)
        }
    }
    
    func updateMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        if let annotations = activities?.activities {
            for annotation in annotations {
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    @IBAction func toggleSwitchViews(_ sender: Any) {
        viewMode = viewMode == .table ? .map : .table
    }
    
    @IBAction func saveNewActivity(_ sender: UIStoryboardSegue) {
        if let editActivityVC = sender.source as? EditActivityVC, let activity = editActivityVC.newActivity {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // update the tableView
                let indexPath = IndexPath(row: activities?.activities.count ?? 0, section: 0)
                activities?.append(activity: activity)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            dataStore.updatePersistentStorage()
            updateMapAnnotations()
            showRouteOnMap()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toActivityDetail" {
            let destVC = segue.destination as! ActivityDetailsVC
            var activity: Activity? = nil
            if let annotation = sender as? Activity {
                activity = annotation
            } else {
                let index = tableView.indexPathForSelectedRow!
                activity = activities?.get(index: index.row)
            }
            
            if let selectedActivity = activity {
                destVC.activity = selectedActivity
                destVC.placemark = MKPlacemark(coordinate: selectedActivity.coordinate)
            }
        } else if segue.identifier == "addActivitySegue" {
            if let index = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: index, animated: true)
            }
        }
    }

}

extension DailyActivityTVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities?.activities.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        if let activity = activities?.activities[indexPath.row] {
            let startTime = dateFormatter.string(from: activity.startTime)
            let endTime = dateFormatter.string(from: activity.endTime)
            
            cell.nameLabel.text = activity.name
            cell.timeLabel.text = "\(startTime) - \(endTime)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            activities?.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            dataStore.updatePersistentStorage()
        }
    }
}

extension DailyActivityTVC: MKMapViewDelegate {
    func showRouteOnMap() {
        mapView.removeOverlays(self.mapView.overlays)
        if let annotations = activities?.activities, annotations.count > 1 {
            for index in 1..<annotations.count {
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: annotations[index - 1].coordinate, addressDictionary: nil))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotations[index].coordinate, addressDictionary: nil))
                request.requestsAlternateRoutes = true
                request.transportType = .automobile
                
                let directions = MKDirections(request: request)
                
                directions.calculate { [unowned self] response, error in
                    guard let unwrappedResponse = response else { return }
                    
                    if (unwrappedResponse.routes.count > 0) {
                        let route = unwrappedResponse.routes[0]
                        self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let pr = MKPolylineRenderer(overlay: overlay);
        pr.strokeColor = .blue
        pr.lineWidth = 5;
        return pr;
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Activity {
            let annotationView = MKMarkerAnnotationView()
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            
            let calloutButton = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = calloutButton
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "toActivityDetail", sender: annotationView.annotation!)
    }
}

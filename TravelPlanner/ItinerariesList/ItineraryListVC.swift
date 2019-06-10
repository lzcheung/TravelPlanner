//
//  ItineraryListVC.swift
//  TravelPlanner
//
//  Created by Liang Cheung on 5/15/19.
//  Copyright © 2019 LZCHEUNG. All rights reserved.
//

import UIKit

class ItineraryListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private var dataStore : DataStorage = DataStorage.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.itineraries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItineraryCell", for: indexPath) as! ItineraryTVCell
        
        let itinerary = dataStore.itineraries[indexPath.row]
        
        cell.setCellData(itinerary: itinerary)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataStore.itineraries.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            dataStore.updatePersistentStorage()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.leftBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    @IBAction func saveToTripList(_ segue: UIStoryboardSegue) {
        if let editItineraryVC = segue.source as? EditItineraryVC, let itinerary = editItineraryVC.itinerary {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // update the tableView
                let indexPath = IndexPath(row: dataStore.itineraries.count, section: 0)
                dataStore.itineraries.append(itinerary)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            dataStore.updatePersistentStorage()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCalenderSegue" {
            let calendarVC = segue.destination as? ItineraryCalenderVC
            let index = tableView.indexPathForSelectedRow
            calendarVC?.itinerary = dataStore.itineraries[index!.row]
        } else if segue.identifier == "addItinerarySegue" {
            if let index = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: index, animated: true)
            }
        }
    }
}

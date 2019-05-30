//
//  ItineraryListVC.swift
//  TravelPlanner
//
//  Created by Liang Cheung on 5/15/19.
//  Copyright © 2019 LZCHEUNG. All rights reserved.
//

import UIKit

class ItineraryListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("userItineraries")
    
    @IBOutlet weak var tableView: UITableView!
    
    private var itineraries : [Itinerary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        do {
            let data = try Data(contentsOf: ItineraryListVC.archiveURL)
            let decoder = JSONDecoder()
            let tempArr = try decoder.decode([Itinerary].self, from: data)
            itineraries = tempArr
        } catch {
            print("Previous data not found")
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itineraries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItineraryCell", for: indexPath) as! ItineraryTVCell
        
        let itinerary = itineraries[indexPath.row]
        
        cell.setCellData(itinerary: itinerary)
        
        
        return cell
    }
    
    func updatePersistentStorage() {
        // persist data
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(itineraries)
            try jsonData.write(to: ItineraryListVC.archiveURL)

        } catch {
            print(error)
        }
    }
    
    @IBAction func saveToTripList(_ segue: UIStoryboardSegue) {
        if let editItineraryVC = segue.source as? EditItineraryVC, let itinerary = editItineraryVC.itinerary {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                itineraries[selectedIndexPath.row] = itinerary
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // update the tableView
                let indexPath = IndexPath(row: itineraries.count, section: 0)
                itineraries.append(itinerary)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            updatePersistentStorage()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCalenderSegue" {
            let calendarVC = segue.destination as? IterinaryCalendarVC
            let index = tableView.indexPathForSelectedRow
            calendarVC?.itinerary = itineraries[index!.row]
        }
    }
}

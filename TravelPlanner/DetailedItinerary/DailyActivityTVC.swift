//
//  DailyActivityTVC.swift
//  TravelPlanner
//
//  Created by Liang Cheung on 5/28/19.
//  Copyright © 2019 LZCHEUNG. All rights reserved.
//

import UIKit

class DailyActivityTVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dateFormatter = DateFormatter()
    var activities: Activities?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "h:mm a"
    }
    
    @IBAction func cancelAddActivity(_ sender: UIStoryboardSegue) {}
    
    @IBAction func saveNewActivity(_ sender: UIStoryboardSegue) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
            cell.coordinateLabel.text = "lat: \(String(activity.lat)) long: \(String(activity.long))"
            cell.timeLabel.text = "\(startTime) - \(endTime)"
            
            return cell
        }
        return cell
    }
    
    
}

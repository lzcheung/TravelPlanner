//
//  DetailedIterinaryVC.swift
//  TravelPlanner
//
//  Created by Liang Cheung on 5/27/19.
//  Copyright © 2019 LZCHEUNG. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ItineraryCalenderVC: UIViewController {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var expandDetailsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var itinerary: Itinerary?
    var selectedDate: Date?
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode   = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleInRangeCellStyle(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
    
    func handleInRangeCellStyle(cell: DateCell, cellState: CellState) {
        if  itinerary?.isDateInRange(date: cellState.date) ?? false {
            cell.tripIndicatorView.isHidden = false
        } else {
            cell.tripIndicatorView.isHidden = true
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.containerView.backgroundColor = .lightGray
        } else {
            cell.containerView.backgroundColor = .white
        }
    }
    
    func updateSelectedDate(cellState: CellState) {
        if let curItinerary = itinerary {
            if curItinerary.isDateInRange(date: cellState.date) {
                formatter.dateFormat = "MMM dd, yyyy"
                expandDetailsButton.isHidden = false
                selectedDateLabel.isHidden = false
                selectedDateLabel.text = formatter.string(from: cellState.date)
                tableView.isHidden = false
                tableView.reloadData()
            } else {
                selectedDateLabel.text = ""
                selectedDateLabel.isHidden = true
                expandDetailsButton.isHidden = true
                tableView.isHidden = true
            }
        } else {
            selectedDateLabel.text = ""
            selectedDateLabel.isHidden = true
            expandDetailsButton.isHidden = true
            tableView.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editItinerarySegue" {
            let destinationVC = segue.destination as! UINavigationController
            let editItineraryVC = destinationVC.viewControllers[0] as! EditItineraryVC
            editItineraryVC.itinerary = itinerary
        } else if segue.identifier == "toDetailActivitySegue" {
            let destinationVC = segue.destination as! DailyActivityTVC
            if let activities = itinerary?.getActivitiesByDate(date: selectedDate!) {
                destinationVC.activities = activities
            } else {
                let activities = itinerary?.createActivitiesAtDate(date: selectedDate!)
                destinationVC.activities = activities
            }
        }
    }
}

extension ItineraryCalenderVC: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        let startDate = itinerary?.startDate ?? formatter.date(from: "2019 01 01")!
        let endDate = itinerary?.endDate ?? Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate, generateInDates: .forAllMonths, generateOutDates: .tillEndOfRow)
    }
}

extension ItineraryCalenderVC: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        selectedDate = cellState.date
        configureCell(view: cell, cellState: cellState)
        updateSelectedDate(cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        selectedDateLabel.text = ""
        selectedDateLabel.isHidden = true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        formatter.dateFormat = "MMMM"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
}

extension ItineraryCalenderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let date = selectedDate, let activitiesWrapper = itinerary?.activities[date] {
            return activitiesWrapper.activities.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleActivitiesCell", for: indexPath)
        if let date = selectedDate, let activitiesWrapper = itinerary?.activities[date] {
            let activity = activitiesWrapper.get(index: indexPath.row)
            cell.textLabel?.text = "\(activity?.subtitle ?? "") \(activity?.name ?? "")"
        }
        return cell
    }
    
    
}

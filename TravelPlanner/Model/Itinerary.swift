//
//  Itinerary.swift
//  TravelPlanner
//
//  Created by Liang Cheung on 5/15/19.
//  Copyright © 2019 LZCHEUNG. All rights reserved.
//

import Foundation

class Itinerary : Codable {
    var name : String
    var location : String
    var startDate : Date
    var endDate : Date
    var activities : [Date : Activities]
    
    init (name: String, location: String, startDate: Date, endDate: Date) {
        self.name = name;
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.activities = [Date: Activities]()
    }
    
    func getTripDurationString(_ dateFormatter: DateFormatter) -> String {
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
    
    func isDateInRange(date: Date) -> Bool {
        return startDate.compare(date) != .orderedDescending && endDate.compare(date) != .orderedAscending
    }
    
    func createActivitiesAtDate(date: Date) -> Activities {
        let newActivities = Activities()
        activities[date] = newActivities
        return newActivities
    }
    
    func getActivitiesByDate(date: Date) -> Activities? {
        return activities[date]
    }
}

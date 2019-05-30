//
//  Activity.swift
//  TravelPlanner
//
//  Created by Liang Cheung on 5/28/19.
//  Copyright © 2019 LZCHEUNG. All rights reserved.
//

import Foundation
import CoreLocation

class Activities : Codable {
    // TODO need to sort by start times
    var activities : [Activity]
    
    init() {
        activities = []
    }
    
    func append(activity: Activity) {
        activities.append(activity)
    }
    
    func remove(at index: Int) {
        activities.remove(at: index)
    }
}

struct Activity : Codable {
    var name : String
    var lat : Double
    var long : Double
    var startTime: Date
    var endTime: Date
    
    init(name: String, lat: Double, long: Double, startTime: Date, endTime: Date) {
        self.name = name
        self.lat = lat
        self.long = long
        self.startTime = startTime
        self.endTime = endTime
    }
}

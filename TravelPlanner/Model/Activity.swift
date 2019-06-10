//
//  Activity.swift
//  TravelPlanner
//
//  Created by Liang Cheung on 5/28/19.
//  Copyright © 2019 LZCHEUNG. All rights reserved.
//

import Foundation
import MapKit

class Activities : Codable {
    // TODO need to sort by start times
    var activities : [Activity]
    
    init() {
        activities = []
    }
    
    func append(activity: Activity) {
        activities.append(activity)
    }
    
    func appendAtIndex(activity: Activity, index: Int) {
        activities[index] = activity
    }
    
    func remove(at index: Int) {
        activities.remove(at: index)
    }
    
    func get(index: Int) -> Activity? {
        return activities[index]
    }
}

class Activity : NSObject, Codable, MKAnnotation {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    var name : String
    var address : String
    var lat : Double
    var long : Double
    var startTime: Date
    var endTime: Date
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return "\(Activity.timeFormatter.string(from: startTime)) - \(Activity.timeFormatter.string(from: endTime))"
    }
    
    init(name: String, address: String, lat: Double, long: Double, startTime: Date, endTime: Date) {
        self.name = name
        self.address = address
        self.lat = lat
        self.long = long
        self.startTime = startTime
        self.endTime = endTime
    }
}

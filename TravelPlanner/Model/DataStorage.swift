//
//  DataStorage.swift
//  TravelPlanner
//
//  Created by Liang Cheung on 6/5/19.
//  Copyright © 2019 LZCHEUNG. All rights reserved.
//

import Foundation

class DataStorage {
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("userItineraries")
    static let instance = DataStorage()
    
    var itineraries: [Itinerary]
    
    private init() {
        do {
            let data = try Data(contentsOf: DataStorage.archiveURL)
            let decoder = JSONDecoder()
            let tempArr = try decoder.decode([Itinerary].self, from: data)
            itineraries = tempArr
        } catch {
            print("Previous data not found")
            itineraries = []
        }
    }
    
    func updatePersistentStorage() {
        // persist data
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(itineraries)
            try jsonData.write(to: DataStorage.archiveURL)
            
        } catch {
            print(error)
        }
    }
}

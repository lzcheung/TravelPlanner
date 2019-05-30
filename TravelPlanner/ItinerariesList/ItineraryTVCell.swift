//
//  ItineraryTVCell.swift
//  TravelPlanner
//
//  Created by Liang Cheung on 5/24/19.
//  Copyright © 2019 LZCHEUNG. All rights reserved.
//

import UIKit

class ItineraryTVCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setCellData(itinerary: Itinerary) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyy"
        
        nameLabel.text = itinerary.name
        locationLabel.text = itinerary.location
        dateLabel.text = itinerary.getTripDurationString(formatter)
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}

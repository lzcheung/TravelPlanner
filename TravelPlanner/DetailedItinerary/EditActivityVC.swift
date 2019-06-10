//
//  EditActivityVC.swift
//  TravelPlanner
//
//  Created by Liang Cheung on 5/31/19.
//  Copyright © 2019 LZCHEUNG. All rights reserved.
//

import UIKit
import MapKit

class EditActivityVC: UIViewController {
    @IBOutlet weak var placeTF: HoshiTextField!
    @IBOutlet weak var startTimeTF: HoshiTextField!
    @IBOutlet weak var endTimeTF: HoshiTextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var startTimePicker: UIDatePicker?
    var endTimePicker: UIDatePicker?
    var selectedLocation: MKPlacemark?
    var newActivity: Activity?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initDatePicker()
        saveButton.isEnabled = false
        
        placeTF.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }
    
    func initDatePicker() {
        startTimePicker = UIDatePicker()
        startTimePicker?.datePickerMode = .time
        startTimePicker?.addTarget(self, action: #selector(EditActivityVC.startTimeChanged(datePicker:)), for: .valueChanged)
        
        endTimePicker = UIDatePicker()
        endTimePicker?.datePickerMode = .time
        endTimePicker?.addTarget(self, action: #selector(EditActivityVC.endTimeChanged(datePicker:)), for: .valueChanged)
        
        startTimeTF.inputView = startTimePicker
        endTimeTF.inputView = endTimePicker
        
        if let selectedActivity = newActivity {
            placeTF.text = selectedActivity.name
            startTimeTF.text = Activity.timeFormatter.string(from: selectedActivity.startTime)
            endTimeTF.text = Activity.timeFormatter.string(from: selectedActivity.endTime)
        }
    }
    
    @objc func startTimeChanged(datePicker: UIDatePicker) {
        startTimeTF.text = Activity.timeFormatter.string(from: datePicker.date)
        toggleSaveButton()
    }
    
    @objc func endTimeChanged(datePicker: UIDatePicker) {
        endTimeTF.text = Activity.timeFormatter.string(from: datePicker.date)
        toggleSaveButton()
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        toggleSaveButton()
    }
    
    func toggleSaveButton() {
        if
            let name = placeTF?.text, !name.isEmpty,
            let startTime = startTimeTF.text, !startTime.isEmpty,
            let endTime = endTimeTF.text, !endTime.isEmpty,
            (selectedLocation != nil || newActivity != nil)
        {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func cancelEditActivity(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setSelectedLocation(_ sender: UIStoryboardSegue) {
        if let searchLocationVC = sender.source as? SearchLocationVC, let location = searchLocationVC.selectedPin {
            placeTF.text = location.name
            addressLabel.text = location.parseAddress()
            addressLabel.isHidden = false
            selectedLocation = location
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "saveActivitySegue" {
            if let activity = newActivity {
                activity.name = placeTF.text!
                activity.startTime = Activity.timeFormatter.date(from: startTimeTF.text!) ?? Date()
                activity.endTime = Activity.timeFormatter.date(from: endTimeTF.text!) ?? Date()
                if let lat = selectedLocation?.coordinate.latitude,
                    let long = selectedLocation?.coordinate.longitude {
                    activity.lat = lat
                    activity.long = long
                }
            } else if let name = placeTF.text,
                let lat = selectedLocation?.coordinate.latitude,
                let long = selectedLocation?.coordinate.longitude,
                let startTime = Activity.timeFormatter.date(from: startTimeTF.text!),
                let endTime = Activity.timeFormatter.date(from: endTimeTF.text!) {
                newActivity = Activity(name: name, address: selectedLocation?.parseAddress() ?? "",lat: lat, long: long, startTime: startTime, endTime: endTime)
            }
        }
    }
}

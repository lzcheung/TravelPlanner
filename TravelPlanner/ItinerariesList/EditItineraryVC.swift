//
//  EditItineraryVC.swift
//  TravelPlanner
//
//  Created by Liang Cheung on 5/26/19.
//  Copyright © 2019 LZCHEUNG. All rights reserved.
//

import UIKit

class EditItineraryVC: UIViewController {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var endDateTF: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private var dateFormatter: DateFormatter = DateFormatter()
    private var startDatePicker: UIDatePicker?
    private var endDatePicker: UIDatePicker?
    var itinerary: Itinerary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initDatePicker()
        setUpExistingValues()
    }
    
    func initDatePicker() {
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        startDatePicker = UIDatePicker()
        startDatePicker?.datePickerMode = .date
        startDatePicker?.addTarget(self, action: #selector(EditItineraryVC.startDateChanged(datePicker:)), for: .valueChanged)
        
        endDatePicker = UIDatePicker()
        endDatePicker?.datePickerMode = .date
        endDatePicker?.addTarget(self, action: #selector(endDateChanged(datePicker:)), for: .valueChanged)
        
        startDateTF.inputView = startDatePicker
        endDateTF.inputView = endDatePicker
    }
    
    func setUpExistingValues() {
        self.navigationItem.title = itinerary?.name ?? "Add Trip"
        
        nameTF.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        locationTF.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditItineraryVC.viewTapped(getRecognizer: )))
        
        view.addGestureRecognizer(tapGesture)
        
        saveButton.isEnabled = false
        
        if let selectedItinerary = itinerary {
            nameTF.text = selectedItinerary.name
            locationTF.text = selectedItinerary.location
            startDateTF.text = dateFormatter.string(from: selectedItinerary.startDate)
            endDateTF.text = dateFormatter.string(from: selectedItinerary.endDate)
        }
    }
    
    @objc func viewTapped(getRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func startDateChanged(datePicker: UIDatePicker) {
        startDateTF.text = dateFormatter.string(from: datePicker.date)
        
        toggleSaveButton()
    }
    
    @objc func endDateChanged(datePicker: UIDatePicker) {
        endDateTF.text = dateFormatter.string(from: datePicker.date)
        
        toggleSaveButton()
    }
    
    func toggleSaveButton() {
        guard
            let name = nameTF.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty,
            let location = locationTF.text?.trimmingCharacters(in: .whitespaces), !location.isEmpty,
            let startDate = startDateTF.text, !startDate.isEmpty,
            let endDate = endDateTF.text, !endDate.isEmpty
            else
        {
            saveButton.isEnabled = false
            return
        }
        // enable okButton if all conditions are met
        saveButton.isEnabled = true
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        toggleSaveButton()
    }
    
    @IBAction func performCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "saveItinerarySegue" {
            guard let startDate = dateFormatter.date(from: startDateTF.text!),
                let endDate = dateFormatter.date(from: endDateTF.text!) else {
                    let alert = UIAlertController(title: "Missing Date", message: "Please enter start and end date", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                    return false
            }
            if startDate.compare(endDate) == .orderedDescending  {
                let alert = UIAlertController(title: "Invalid Dates", message: "Start date must come before end date", preferredStyle: .alert)
    
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    
                self.present(alert, animated: true)
                return false
            }
            return true
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "saveItinerarySegue",
            let name = nameTF.text?.trimmingCharacters(in: .whitespaces),
            let location = locationTF.text?.trimmingCharacters(in: .whitespaces),
            let startDate = dateFormatter.date(from: startDateTF.text!),
            let endDate = dateFormatter.date(from: endDateTF.text!)
        {
            itinerary = Itinerary(name: name, location: location, startDate: startDate, endDate: endDate)
        }
    }

}

//
//  EditPrescriptionViewController.swift
//  Prescription Tracker
//
//  Created by Michel Bernanos on 18/01/2019.
//  Copyright © 2019 Michel Bernanos. All rights reserved.
//

import UIKit

protocol CanEdit {
    
    func dataToEdit(data: DrugMO)
    
}

class EditPrescriptionViewController: UIViewController {
    
    var delegate : CanEdit?
    var newPrescription : DrugMO!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var dosage: UITextField!
    @IBOutlet weak var unitsPerDay: UITextField!
    @IBOutlet weak var remaining: UITextField!
    @IBOutlet weak var myStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = newPrescription.name
        dosage.text = newPrescription.dosage
        unitsPerDay.text = String(newPrescription.unitsPerDay)
        remaining.text = String(newPrescription.remaining)
        myStepper.value = newPrescription.unitsPerDay
        myStepper.stepValue = 0.25

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeUnitsPerDay(_ sender: Any) {
        
        unitsPerDay.text = String(Double(myStepper.value))
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        newPrescription.dateCreated = Date()
        newPrescription.name = name.text!
        newPrescription.dosage = dosage.text!
        newPrescription.remaining = Double(remaining.text!)!
        newPrescription.unitsPerDay = Double(unitsPerDay.text!)!
        
        if delegate != nil {
            delegate?.dataToEdit(data: newPrescription)
            navigationController?.popToRootViewController(animated: true)
        } else {
            print("error passing data back")
            navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
}

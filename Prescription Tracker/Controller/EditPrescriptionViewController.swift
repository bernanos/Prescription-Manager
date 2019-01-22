//
//  EditPrescriptionViewController.swift
//  Prescription Tracker
//
//  Created by Michel Bernanos on 18/01/2019.
//  Copyright © 2019 Michel Bernanos. All rights reserved.
//

import UIKit

protocol CanEdit {
    
    func dataToEdit(data: Prescription)
    
}

class EditPrescriptionViewController: UIViewController {
    
    var delegate : CanEdit?
    var newPrescription = DrugMO()
    var rowForEdit : Int?
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var dosage: UITextField!
    @IBOutlet weak var unitsPerDay: UITextField!
    @IBOutlet weak var remaining: UITextField!
    @IBOutlet weak var myStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = newPrescription.name!
        dosage.text = newPrescription.dosage!
        unitsPerDay.text = String(newPrescription.unitsPerDay)
        remaining.text = String(newPrescription.remaining)
        myStepper.value = newPrescription.unitsPerDay

        // Do any additional setup after loading the view.
    }
    
    @IBAction func chageUnitsPerDay(_ sender: Any) {
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
}

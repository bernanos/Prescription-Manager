//
//  AddPrescriptionViewController.swift
//  Prescription Tracker
//
//  Created by Michel Bernanos on 18/01/2019.
//  Copyright © 2019 Michel Bernanos. All rights reserved.
//

import UIKit

protocol CanReceive {
    
    func dataReceived(data: Prescription)
    
}

class AddPrescriptionViewController: UIViewController {
    
    var delegate : CanReceive?
    var newPrescription = Prescription()

    @IBOutlet weak var drugNameTextField: UITextField!
    @IBOutlet weak var dosageTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var timesTextField: UITextField!
    @IBOutlet weak var myStepper: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myStepper.value = 1.0
        myStepper.minimumValue = 0.25
        myStepper.maximumValue = 10
        myStepper.stepValue = 0.25
        timesTextField.text = String(Int(myStepper.value))
        
    }
    
    @IBAction func changeTimesPerDay(_ sender: Any) {
        
        timesTextField.text = String(Double(myStepper.value))
        
    }

    
    @IBAction func savePrescription(_ sender: Any) {
        
        newPrescription.createDate = Date()
        newPrescription.name = drugNameTextField.text!
        newPrescription.dosage = dosageTextField.text!
        newPrescription.remaining = Double(quantityTextField.text!)
        newPrescription.unitsPerDay = Double(timesTextField.text!)
        
        if delegate != nil {
            delegate?.dataReceived(data: newPrescription)
            navigationController?.popToRootViewController(animated: true)
        } else {
            print("error passing data back")
            navigationController?.popToRootViewController(animated: true)
        }
        
        
        
    }

}

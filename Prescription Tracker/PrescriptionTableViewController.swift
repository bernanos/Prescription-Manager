//
//  PrescriptionTableViewController.swift
//  Prescription Tracker
//
//  Created by Michel Bernanos on 18/01/2019.
//  Copyright © 2019 Michel Bernanos. All rights reserved.
//

import UIKit

class PrescriptionTableViewController: UITableViewController, CanReceive {
    
    var prescriptionArray = [Prescription]()
    let defaults = UserDefaults.standard
    let cellNib = "PrescriptionTableViewCell"
    let cellID = "DetailedPrescriptionCell"
    let editSegueID = "EditPrescription"
    let addSegueID = "AddNewPrescription"
    let userDataKey = "PrescriptionList"

    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedData = defaults.array(forKey: userDataKey) as? [Prescription] {
            prescriptionArray = savedData
        }
        
        tableView.register(UINib(nibName: cellNib, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.rowHeight = 155.0
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return prescriptionArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PrescriptionTableViewCell
        cell.drugNameTextField.text = prescriptionArray[indexPath.row].name!
        cell.dosageTextField.text = prescriptionArray[indexPath.row].dosage!
        cell.amountLeftTextField.text = String( prescriptionArray[indexPath.row].remaining!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: editSegueID, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addSegueID {
            let destinationVC = segue.destination as! AddPrescriptionViewController
            destinationVC.delegate = self
        } else if segue.identifier == editSegueID {
            // Implement editting
        }
    }
    
    func dataReceived(data: Prescription) {
        print("dataReceived")
        prescriptionArray.append(data)
//        defaults.set(prescriptionArray, forKey: userDataKey)
        tableView.reloadData()
    }

}

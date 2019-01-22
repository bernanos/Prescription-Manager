//
//  PrescriptionTableViewController.swift
//  Prescription Tracker
//
//  Created by Michel Bernanos on 18/01/2019.
//  Copyright © 2019 Michel Bernanos. All rights reserved.
//

import UIKit
import CoreData

class PrescriptionTableViewController: UITableViewController, CanReceive {
    
    var prescriptionArray = [DrugMO]()
//    let defaults = UserDefaults.standard
    let cellNib = "PrescriptionTableViewCell"
    let cellID = "DetailedPrescriptionCell"
    let editSegueID = "EditPrescription"
    let addSegueID = "AddNewPrescription"
    let userDataKey = "PrescriptionList"
    
    // Creating context for managed object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

//        if let savedData = defaults.array(forKey: userDataKey) as? [Prescription] {
//            prescriptionArray = savedData
//        }
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.register(UINib(nibName: cellNib, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.rowHeight = 155.0
        
        loadData()
        
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return prescriptionArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PrescriptionTableViewCell
        cell.drugNameTextField.text = prescriptionArray[indexPath.row].name!
        cell.dosageTextField.text = prescriptionArray[indexPath.row].dosage!
        cell.amountLeftTextField.text = String(prescriptionArray[indexPath.row].remaining)
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
        let newPrescription = DrugMO(context: context)
        newPrescription.name = data.name!
        newPrescription.dosage = data.dosage!
        newPrescription.remaining = data.remaining!
        newPrescription.dateCreated = data.createDate!
        newPrescription.unitsPerDay = data.unitsPerDay!
        
        prescriptionArray.append(newPrescription)
        
        
        // Saving data into container (CoreData)
        do {
            try context.save()
        } catch {
            print("error: \(error)")
        }
//        defaults.set(prescriptionArray, forKey: userDataKey)
        tableView.reloadData()
    }
    
    func loadData() {
        
        // Reading data from container (CoreData)
        let request : NSFetchRequest<DrugMO> = DrugMO.fetchRequest()
        do {
            prescriptionArray =
                try context.fetch(request)
        } catch {
            print("error: \(error)")
        }
        
    }

}

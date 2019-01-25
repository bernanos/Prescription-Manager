//
//  PrescriptionTableViewController.swift
//  Prescription Tracker
//
//  Created by Michel Bernanos on 18/01/2019.
//  Copyright © 2019 Michel Bernanos. All rights reserved.
//

import UIKit
import CoreData

class PrescriptionTableViewController: UITableViewController, CanReceive, CanEdit {
    
    var prescriptionArray = [DrugMO]()
    let cellNib = "PrescriptionTableViewCell"
    let cellID = "DetailedPrescriptionCell"
    let editSegueID = "EditPrescription"
    let addSegueID = "AddNewPrescription"
    let userDataKey = "PrescriptionList"
    var rowForEdit : Int?
    
    // Creating context for managed object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.register(UINib(nibName: cellNib, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.rowHeight = 155.0
        
        // Loads initial data saved in the container
        loadData()
        
        if prescriptionArray.count > 0 {
            updateQuantities()
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return prescriptionArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PrescriptionTableViewCell
        cell.drugNameTextField.text = prescriptionArray[indexPath.row].name!
        cell.dosageTextField.text = prescriptionArray[indexPath.row].dosage!
        cell.amountLeftTextField.text = String(prescriptionArray[indexPath.row].remaining)
        if prescriptionArray[indexPath.row].remaining > 10 {
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.9786401391, blue: 0.3691126108, alpha: 1)
        } else if prescriptionArray[indexPath.row].remaining > 5 {
            cell.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        } else {
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rowForEdit = indexPath.row
        performSegue(withIdentifier: editSegueID, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // detal with deleting entry
            context.delete(prescriptionArray[indexPath.row])
            prescriptionArray.remove(at: indexPath.row)
            savePrescription()
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addSegueID {
            let destinationVC = segue.destination as! AddPrescriptionViewController
            destinationVC.delegate = self
        } else if segue.identifier == editSegueID {
            let destinationVC = segue.destination as! EditPrescriptionViewController
            destinationVC.delegate = self
            destinationVC.newPrescription = prescriptionArray[rowForEdit!]
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
        
        savePrescription()
        
        tableView.reloadData()
    }
    
    func dataToEdit(data: DrugMO) {
        
        print("dataReceived")

        prescriptionArray[rowForEdit!] = data
        
        savePrescription()
        
        tableView.reloadData()
    }
    
    func savePrescription() {
        // Saving data into container (CoreData)
        do {
            try context.save()
        } catch {
            print("error: \(error)")
        }
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
    
    func updateQuantities() {
        
        // Testing quantity update using future date
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 2
        dateComponents.day = 10
        let userCalendar = Calendar.current // user calendar
        let currentData = userCalendar.date(from: dateComponents)
        
        
        //let currentData = Date()
        var counter = 0
        for prescritpion in prescriptionArray {
            let daysSinceCreation = currentData!.timeIntervalSince(prescritpion.dateCreated!)/(24*60*60)
            prescritpion.remaining -= Double(Int(daysSinceCreation)) * prescritpion.unitsPerDay
            prescritpion.dateCreated = currentData
            prescriptionArray[counter] = prescritpion
            counter += 1
        }
    
    }

}

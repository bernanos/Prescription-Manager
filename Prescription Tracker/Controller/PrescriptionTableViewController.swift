//
//  PrescriptionTableViewController.swift
//  Prescription Tracker
//
//  Created by Michel Bernanos on 18/01/2019.
//  Copyright © 2019 Michel Bernanos. All rights reserved.
//

import UIKit
import CoreData

//TODO: delete coredata and import RealmSwift

class PrescriptionTableViewController: UITableViewController, CanReceive, CanEdit {
    
    //TODO: Initialise Realm object "let realm = try! Realm()
    
    //TODO: Change prescriptionArray to be a Results<Prescription> object (Real object)
    var prescriptionArray = [DrugMO]()
    
    let cellNib = "PrescriptionTableViewCell"
    let cellID = "DetailedPrescriptionCell"
    let editSegueID = "EditPrescription"
    let addSegueID = "AddNewPrescription"
    var rowForEdit : Int?
    
    //TODO: delete coredata context
    // Creating context for managed object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: cellNib, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.rowHeight = 155.0
        
        // Loads initial data saved in the container
        loadData()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: change implementation to check for realm object and to have a default value if realm object is nil
        return prescriptionArray.count
    }
    
    //TODO: change implementation to deal with case where realm object is nil
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PrescriptionTableViewCell
        cell.drugNameTextField.text = prescriptionArray[indexPath.row].name!
        cell.dosageTextField.text = prescriptionArray[indexPath.row].dosage!
        
        let currentDate = Date();
        if let creationDate = prescriptionArray[indexPath.row].dateCreated {
            let daysSinceCreation = currentDate.timeIntervalSince(creationDate)/(24*60*60)
            let totalNumberOfPills = prescriptionArray[indexPath.row].numberOfPillsBought
            let remaining = totalNumberOfPills - Double(Int(daysSinceCreation)) * prescriptionArray[indexPath.row].unitsPerDay
            cell.amountLeftTextField.text = String(remaining)
            if  remaining > 14 {
                cell.backgroundColor = #colorLiteral(red: 0, green: 0.9786401391, blue: 0.3691126108, alpha: 1)
            } else if remaining > 7 {
                cell.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
            } else {
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        }

        return cell
    }
    
    //TODO: change implementation to use realm pattern for editting entry
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rowForEdit = indexPath.row
        performSegue(withIdentifier: editSegueID, sender: self)
    }
    
    //TODO: change implementation to use realm deleting pattern
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
            
            //TODO: the following line can be changed to use tableView.indexPathForSelectedRow. Also, implement Realm pattern for newPrescription
            destinationVC.newPrescription = prescriptionArray[rowForEdit!]
        }
    }
    
    func dataReceived(data: Prescription) {
        
        print("dataReceived")
        let newPrescription = DrugMO(context: context)
        newPrescription.name = data.name!
        newPrescription.dosage = data.dosage!
        newPrescription.numberOfPillsBought = data.remaining!
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
    
    //TODO: Modify loadData to comply with Realm pattern
    func loadData() {
        
        // Reading data from container (CoreData)
        let request : NSFetchRequest<DrugMO> = DrugMO.fetchRequest()
        do {
            prescriptionArray = try context.fetch(request)
        } catch {
            print("error: \(error)")
        }
        
    }
    
}

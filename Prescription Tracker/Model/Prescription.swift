//
//  Prescription.swift
//  Prescription Tracker
//
//  Created by Michel Bernanos on 19/01/2019.
//  Copyright © 2019 Michel Bernanos. All rights reserved.
//

import Foundation

//TODO: import RealmSwift

class Prescription {
    
    var name : String?
    var dosage : String?
    var remaining : Double?
    var unitsPerDay : Double?
    var createDate : Date?
    
}

//TODO: edit this class to inherit from Object (realm) and setup propetries using @objc dynamic

//TODO: Delete DataModel.xcdatamodel

// There won't be any need to setup relationships, but revise how to do it

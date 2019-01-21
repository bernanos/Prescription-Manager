//
//  PrescriptionTableViewCell.swift
//  Prescription Tracker
//
//  Created by Michel Bernanos on 19/01/2019.
//  Copyright © 2019 Michel Bernanos. All rights reserved.
//

import UIKit

class PrescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var drugNameTextField: UITextField!
    @IBOutlet weak var dosageTextField: UITextField!
    @IBOutlet weak var amountLeftTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

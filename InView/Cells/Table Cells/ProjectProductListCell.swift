//
//  ProjectProductListCell.swift
//  InView
//
//  Created by Roger Vogel on 10/13/22.
//

import Foundation
import UIKit

class ProjectProductListCell: UITableViewCell {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var productIDTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitPriceTextField: UITextField!
    @IBOutlet weak var totalPriceTextField: UITextField!
    
    // MARK: - METHODS
    func setFields(category: String, id: String, description: String, qty: Int32, price: Double) {
        
        let formatter = NumberFormatter()
        let totalPrice = Double(qty) * price
        
        categoryTextField.text = category
        productIDTextField.text = id
        descriptionTextField.text = description
        
        formatter.setup(showDecimal: false, maxDecimal: 0, minDecimal: 0)
        quantityTextField.text = formatter.string(from: NSNumber(value: qty))!
   
        formatter.revertToDefault()
        unitPriceTextField.text = "$" + formatter.string(from: NSNumber(value: price))!
        totalPriceTextField.text = "$" + formatter.string(from: NSNumber(value: totalPrice))!
    }
}

//
//  ProjectProductListCell.swift
//  InView
//
//  Created by Roger Vogel on 10/13/22.
//

import Foundation
import UIKit
import ToggleGroup

class ProjectProductListCell: UITableViewCell {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var productIDTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitPriceTextField: UITextField!
    @IBOutlet weak var totalPriceTextField: UITextField!
    @IBOutlet weak var invoiceCheckbox: ToggleButton!
    @IBOutlet weak var unitDescriptionTextField: UITextField!
    
    // MARK: - PROPERTIES
    var myIndexPath: IndexPath?
    var theProduct: Product?
    var delegate: ProjectProductCellDelegate?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        invoiceCheckbox.initToggle(selectedImage: UIImage(systemName: "checkmark.circle.fill")!, unselectedImage: UIImage(systemName: "circle")!)
        invoiceCheckbox.setState(false)
    }
    
    // MARK: - METHODS
    func setFields(category: String, id: String, description: String, unitDescription: String, qty: Int32, price: Double) {
        
        let formatter = NumberFormatter()
        let totalPrice = Double(qty) * price
       
        categoryTextField.text = category
        productIDTextField.text = id
        descriptionTextField.text = description
        unitDescriptionTextField.text = unitDescription
        
        formatter.setup(showDecimal: false, maxDecimal: 0, minDecimal: 0)
        quantityTextField.text = formatter.string(from: NSNumber(value: qty))!
          
        formatter.revertToDefault()
        unitPriceTextField.text = "$" + formatter.string(from: NSNumber(value: price))!
        totalPriceTextField.text = "$" + formatter.string(from: NSNumber(value: totalPrice))!
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onInvoice(_ sender: Any) {
        
        invoiceCheckbox.toggle()
        
        if invoiceCheckbox.isOn { delegate!.invoiceProductWasSelected(indexPath: myIndexPath!)  }
        else {delegate!.invoiceProductWasDeselected(indexPath: myIndexPath!) }
    }
}

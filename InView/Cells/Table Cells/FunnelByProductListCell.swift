//
//  FunnelByProductListCell.swift
//  InView
//
//  Created by Roger Vogel on 2/13/23.
//

import UIKit

class FunnelByProductListCell: UITableViewCell {

    // MARK: - STORY BOARD CONNECTORS
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var infoButton: UIButton!
    
    // MARK: - PROPERTIES
    var theProductCategory: ProductCategory?
    var myIndexPath: IndexPath?
    var toolBar = Toolbar()
    var delegate: ReportsByProductListCellDelegate?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        categoryTextField.delegate = self
        valueTextField.delegate = self
        
        categoryTextField.setPadding(left: 8.0, right: 8.0)
        valueTextField.setPadding(left: 8.0, right: 8.0)
        
        toolBar.setup(parent: GlobalData.shared.activeView!)
        valueTextField.inputAccessoryView = toolBar
        valueTextField.roundAllCorners(value: 3)
    }

    @IBAction func onInfo(_ sender: Any) {
        
        delegate!.onDetailsButton(info: infoButton, indexPath: myIndexPath!)
    }
}

// MARK: - TEXT FIELD DELEGATE PROTOCOL
extension FunnelByProductListCell: UITextFieldDelegate {
 
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.backgroundColor = .white
        guard !textField.text!.isEmpty else { return true }
    
        textField.text = textField.text!.cleanedDollar
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let theValue: Int32 = textField.text!.isEmpty ? 0 : Int32(textField.text!.cleanedDollar)!
    
        delegate!.textFieldDidChange(info: infoButton, category: theProductCategory!, value: theValue, indexPath: myIndexPath!)
        
        if !textField.text!.isEmpty { textField.text = textField.text!.formattedDollarRounded }
    }
}


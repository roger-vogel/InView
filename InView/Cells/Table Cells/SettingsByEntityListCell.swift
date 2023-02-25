//
//  SettingsByEntityListCell.swift
//  InView
//
//  Created by Roger Vogel on 2/7/23.
//

import UIKit

class SettingsByEntityListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var entityTextField: UITextField!
    @IBOutlet weak var priorYearTextField: UITextField!
    
    // MARK: - PROPERTIES
    var theRow: Int?
    var toolBar = Toolbar()
    var delegate: EntityListCellDelegate?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
   
        super.awakeFromNib()
        
        entityTextField.setPadding(left: 8.0, right: 8.0)
        entityTextField.addLeftBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        entityTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
       
        priorYearTextField.delegate = self
        priorYearTextField.setPadding(left: 8.0, right: 8.0)
        priorYearTextField.addLeftBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        priorYearTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        priorYearTextField.addRightBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
    
        toolBar.setup(parent: self)
        priorYearTextField.inputAccessoryView = toolBar
    }
}

// MARK: - TEXT FIELD DELEGATE PROTOCOL
extension SettingsByEntityListCell: UITextFieldDelegate {
 
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let theValue: Int32 = textField.text!.isEmpty ? 0 : Int32(textField.text!.cleanedDollar)!
        delegate!.textFieldWillChange(value: theValue)
     
        textField.backgroundColor = .white
        guard !textField.text!.isEmpty else { return true }
    
        textField.text = textField.text!.cleanedDollar
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let theValue = textField.text!.isEmpty ? 0 : Int32(textField.text!)!
        delegate!.textFieldDidChange(value: theValue, forRow: theRow!)
        
        if !textField.text!.isEmpty { textField.text = textField.text!.formattedDollarRounded }
    }
}

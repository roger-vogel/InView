//
//  ReportsTotalSalesListCell.swift
//  InView
//
//  Created by Roger Vogel on 2/5/23.
//

import UIKit
import CustomControls
import Extensions

class ReportsTotalSalesListCell: UITableViewCell { 
    
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var monthToDateTextField: UITextField!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var previousYearTextField: UITextField!
    
    // MARK: - PROPERTIES
    var theMonth: Int?
    var toolBar = Toolbar()
    
    var delegate: SettingsGoalListCellDelegate?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        monthTextField.setPadding(left: 8.0, right: 8.0)
        monthTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        monthTextField.addLeftBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        
        monthToDateTextField.setPadding(left: 8.0, right: 8.0)
        monthToDateTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        monthToDateTextField.addLeftBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        
        goalTextField.setPadding(left: 8.0, right: 8.0)
        goalTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        goalTextField.addLeftBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        
        previousYearTextField.setPadding(left: 8.0, right: 8.0)
        previousYearTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        previousYearTextField.addLeftBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        previousYearTextField.addRightBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        
        toolBar.setup(parent: self)
        
        monthToDateTextField.delegate = self
        monthToDateTextField.inputAccessoryView = toolBar
    }
    
    @IBAction func onPrimaryAction(_ sender: Any) { endEditing(true) }
}

// MARK: - TEXT FIELD DELEGATE PROTOCOL
extension ReportsTotalSalesListCell: UITextFieldDelegate {
 
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let theValue: Int32 = textField.text!.isEmpty ? 0 : Int32(textField.text!.cleanedDollar)!
        var theValues = SettingValues()
        
        theValues.mtd = theValue
        delegate!.textFieldWillChange(values: theValues)
        
        textField.backgroundColor = .white
        guard !textField.text!.isEmpty else { return true }
    
        textField.text = textField.text!.cleanedDollar
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let theValue: Int32 = textField.text!.isEmpty ? 0 : Int32(textField.text!.cleanedDollar)!
        var theValues = SettingValues()
        
        theValues.mtd = theValue
        
        delegate!.textFieldDidChange(values: theValues, forMonth: theMonth!)
        
        if !textField.text!.isEmpty { textField.text = textField.text!.formattedDollarRounded }
    }
}

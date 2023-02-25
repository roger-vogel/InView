//
//  SettingsGoalsListCell.swift
//  InView
//
//  Created by Roger Vogel on 2/7/23.
//

import UIKit
import CustomControls

class SettingsGoalsListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var priorYearTextField: UITextField!
    
    // MARK: - PROPERTIES
    var theMonth: Int?
    var toolBar = Toolbar()
    
    var delegate: SettingsGoalListCellDelegate?
   
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
      
        super.awakeFromNib()
     
        monthTextField.setPadding(left: 8.0, right: 8.0)
        monthTextField.addLeftBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        monthTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
       
        goalTextField.delegate = self
        goalTextField.setPadding(left: 8.0, right: 8.0)
        goalTextField.addLeftBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        goalTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
    
        priorYearTextField.delegate = self
        priorYearTextField.setPadding(left: 8.0, right: 8.0)
        priorYearTextField.addLeftBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        priorYearTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        priorYearTextField.addRightBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
       
        toolBar.setup(parent: self)
        goalTextField.inputAccessoryView = toolBar
        priorYearTextField.inputAccessoryView = toolBar
    
    }
}

// MARK: - TEXT FIELD DELEGATE PROTOCOL
extension SettingsGoalsListCell: UITextFieldDelegate {
 
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let theValue: Int32 = textField.text!.isEmpty ? 0 : Int32(textField.text!.cleanedDollar)!
        var theValues = SettingValues()
        
        if textField.tag == 0 { theValues.goal = theValue }
        else { theValues.prior = theValue }
        
        delegate!.textFieldWillChange(values: theValues)
        
        textField.backgroundColor = .white
        guard !textField.text!.isEmpty else { return true }
    
        textField.text = textField.text!.cleanedDollar
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let theValue: Int32 = textField.text!.isEmpty ? 0 : Int32(textField.text!.cleanedDollar)!
        var theValues = SettingValues()
        
        if textField.tag == 0 { theValues.goal = theValue }
        else { theValues.prior = theValue }
        
        delegate!.textFieldDidChange(values: theValues, forMonth: theMonth!)
        
        if !textField.text!.isEmpty { textField.text = textField.text!.formattedDollarRounded }
    }
}

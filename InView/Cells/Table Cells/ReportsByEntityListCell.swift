//
//  ReportsByAccountListCell.swift
//  InView
//
//  Created by Roger Vogel on 2/13/23.
//

import UIKit
import AlertManager

class ReportsByEntityListCell: UITableViewCell {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var entityNameTextField: UITextField!
    @IBOutlet weak var ytdTextField: UITextField!
    @IBOutlet weak var priorYearTextField: UITextField!
    
    // MARK: - PROPERTIES
    var toolBar = Toolbar()
    var myIndexPath: IndexPath?
    var delegate: SettingsGoalListCellDelegate?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
      
        super.awakeFromNib()
       
        entityNameTextField.setPadding(left: 8.0, right: 8.0)
        entityNameTextField.addLeftBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        entityNameTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
       
        ytdTextField.delegate = self
        ytdTextField.setPadding(left: 8.0, right: 8.0)
        ytdTextField.addLeftBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        ytdTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
    
        priorYearTextField.delegate = self
        priorYearTextField.setPadding(left: 8.0, right: 8.0)
        priorYearTextField.addLeftBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        priorYearTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        priorYearTextField.addRightBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
       
        toolBar.setup(parent: self)
        ytdTextField.inputAccessoryView = toolBar
        priorYearTextField.inputAccessoryView = toolBar
    }
}

// MARK: - TEXT FIELD DELEGATE PROTOCOL
extension ReportsByEntityListCell: UITextFieldDelegate {
 
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        guard textField != priorYearTextField else {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupOK(aMessage: "To edit prior year totals, return to Settings")
            return false
        }
        
        textField.backgroundColor = .white
        guard !textField.text!.isEmpty else { return true }
    
        textField.text = textField.text!.cleanedDollar
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let theValue: Int32 = textField.text!.isEmpty ? 0 : Int32(textField.text!.cleanedDollar)!
    
        delegate!.textFieldDidChange(value: theValue, indexPath: myIndexPath!)
        
        if !textField.text!.isEmpty { textField.text = textField.text!.formattedDollarRounded }
    }
}

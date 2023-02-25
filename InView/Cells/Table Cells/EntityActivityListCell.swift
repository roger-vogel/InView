//
//  EntityActivityListCell.swift
//  InView
//
//  Created by Roger Vogel on 1/19/23.
//

import UIKit
import ToggleGroup
import Extensions
import CustomControls

class EntityActivityListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var checkButton: ToggleButton!
    @IBOutlet weak var activityDescriptionTextField: UITextField!
    @IBOutlet weak var disclosureImageView: UIButton!
    
    // MARK: - PROPERTIES
    var theActivity: Activity?
    var myIndexPath: IndexPath?
    weak var delegate: ActivityTableCellDelegate?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Set left padding
        activityDescriptionTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        activityDescriptionTextField.leftViewMode = .always
      
        // Set right padding
        activityDescriptionTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        activityDescriptionTextField.rightViewMode = .always
        
        // Set bprders
        activityDescriptionTextField.addTopBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        activityDescriptionTextField.addLeftBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        activityDescriptionTextField.addBottomBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        
        disclosureImageView.addTopBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        disclosureImageView.addRightBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        disclosureImageView.addBottomBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        
        activityDescriptionTextField.roundCorners(corners: .left, radius: 2)
        disclosureImageView.roundCorners(corners: .right, radius: 2)
        
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onPrimaryAction(_ sender: Any) { endEditing(true) }
        
    @IBAction func onEditingChanged(_ sender: Any) {
        
        theActivity!.activityDescription = activityDescriptionTextField.text!
        delegate!.activityDescriptionWasChanged(activity: theActivity!)
    }
    
    @IBAction func onCheckButton(_ sender: Any) {
        
        if !theActivity!.isCompleted {
            
            checkButton.setState(true)
            delegate!.activityWasSelected(activity: theActivity!)
            
        } else {
            
            checkButton.setState(false)
            delegate!.activityWasDeselected(activity: theActivity!)
        }
    }
}

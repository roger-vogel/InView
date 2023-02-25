//
//  EventListCell.swift
//  InView
//
//  Created by Roger Vogel on 12/30/22.
//

import UIKit
import Extensions
import ToggleGroup

class EventListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var checkButtonBorder: UIButton!
    @IBOutlet weak var checkButton: ToggleButton!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - PROPERTIES
    var theActivity: Activity?
    var myIndexPath: IndexPath?
    weak var delegate: ActivityTableCellDelegate?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
     
        super.awakeFromNib()
        
        checkButton.initToggle(isCheckBox: true)
        
        dayTextField.setPadding(left: 5, right: 5)
        timeTextField.setPadding(left: 5, right: 5)
        nameTextField.setPadding(left: 5, right: 5)
        
        dayTextField.addLeftBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        dayTextField.addBottomBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        dayTextField.addRightBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
       
        timeTextField.addBottomBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
       
        nameTextField.addLeftBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        nameTextField.addBottomBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        nameTextField.addRightBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
       
        dayTextField.roundCorners(corners: .left, radius: 2)
        nameTextField.roundCorners(corners: .right, radius: 2)
    }
    
    // MARK: - METHODS
    func addTopBorder() {
    
        dayTextField.addTopBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        timeTextField.addTopBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        nameTextField.addTopBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onCheckBox(_ sender: Any) {
        
        if !theActivity!.isCompleted {
            
            checkButton.setState(true)
            delegate!.activityWasSelected(activity: theActivity!)
            
        } else {
            
            checkButton.setState(false)
            delegate!.activityWasDeselected(activity: theActivity!)
        }
        
    }
}

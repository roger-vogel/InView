//
//  ActivityMoveTableCell.swift
//  InView
//
//  Created by Roger Vogel on 1/22/23.
//

import UIKit
import ToggleGroup

class MoveActivityListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var activityDateTextField: UITextField!
    @IBOutlet weak var activityDescriptionTextField: UITextField!
    
    // MARK: - PROPERTIES
    var theActivity: Activity?
    var myIndexPath: IndexPath?
    weak var delegate: ActivityTableCellDelegate?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
        super.awakeFromNib()
     
        // Set left padding
        activityDateTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        activityDateTextField.leftViewMode = .always
     
        activityDescriptionTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        activityDescriptionTextField.leftViewMode = .always
      
        // Set right padding
        activityDateTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        activityDateTextField.rightViewMode = .always
        
        activityDescriptionTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        activityDescriptionTextField.rightViewMode = .always
        
        // Set Border
        activityDateTextField.setBorder(width: 1.0, color: ThemeColors.teal.cgcolor)
        activityDateTextField.roundCorners(corners: .left, radius: 2)
        
        activityDescriptionTextField.addTopBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        activityDescriptionTextField.addRightBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        activityDescriptionTextField.addBottomBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        activityDateTextField.roundCorners(corners: .right, radius: 2)
    }
}

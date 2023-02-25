//
//  CalendarListCell.swift
//  InView
//
//  Created by Roger Vogel on 10/27/22.
//

import UIKit

class CalendarListCell: UITableViewCell {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - PROPERTIES
    var theActivity: Activity?
    var myIndexPath: IndexPath?
    weak var delegate: ActivityTableCellDelegate?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
     
        super.awakeFromNib()
        
        typeTextField.setPadding(left: 5, right: 5)
        timeTextField.setPadding(left: 5, right: 5)
        nameTextField.setPadding(left: 5, right: 5)
        
//      typeTextField.setBorder(width: 1.0, color: ThemeColors.teal.cgcolor)
//      timeTextField.addBottomBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
//      timeTextField.addTopBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
//      nameTextField.setBorder(width: 1.0, color: ThemeColors.teal.cgcolor)
//
//      typeTextField.roundCorners(corners: .left, radius: 2)
//      nameTextField.roundCorners(corners: .right, radius: 2)
    }
}

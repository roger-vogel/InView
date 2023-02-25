//
//  ActivityListCell.swift
//  InView
//
//  Created by Roger Vogel on 12/30/22.
//

import UIKit
import Extensions
import ToggleGroup

class ActivityListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var checkButton: ToggleButton!
    @IBOutlet weak var attachedToTextField: UITextField!
    @IBOutlet weak var checkBorderButton: UIButton!
    @IBOutlet weak var activityDescriptionTextField: UITextField!
    @IBOutlet weak var ellipsisImageView: UIImageView!
    @IBOutlet weak var ellipsisBorderButton: UIButton!
    
    // MARK: - PROPERTIES
    var theActivity: Activity?
    var myIndexPath: IndexPath?
    weak var delegate: ActivityTableCellDelegate?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        checkButton.initToggle(isCheckBox: true)
        
        attachedToTextField.setPadding(left: 5, right: 5)
        activityDescriptionTextField.setPadding(left: 5, right: 5)
        
        ellipsisBorderButton.addBottomBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        attachedToTextField.addLeftBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        attachedToTextField.addBottomBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        
        activityDescriptionTextField.addLeftBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        activityDescriptionTextField.addBottomBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        activityDescriptionTextField.addRightBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
    
        attachedToTextField.roundCorners(corners: .left, radius: 2)
        activityDescriptionTextField.roundCorners(corners: .right, radius: 2)
    }
    
    // MARK: - METHODS
    func addTopBorder() {
    
        attachedToTextField.addTopBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        ellipsisBorderButton.addTopBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        activityDescriptionTextField.addTopBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
    }
    
    @discardableResult func setActivity(activity: Activity) -> Int {
        
        theActivity = activity
        let attachmentCount = theActivity!.contacts!.count + theActivity!.companies!.count + theActivity!.projects!.count
        
        if attachmentCount > 1 {  ellipsisImageView.isHidden = false }
        else if attachmentCount == 1 {  ellipsisImageView.isHidden = true }
        else { ellipsisImageView.isHidden = true }
     
        return attachmentCount
    }
    
    // MARK: - ACTION HANDLERS
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

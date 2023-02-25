//
//  ProjectSelectorListCell.swift
//  InView
//
//  Created by Roger Vogel on 11/5/22.
//

import UIKit
import ToggleGroup

class ProjectSelectorListCell: UITableViewCell {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var checkBoxButton: ToggleButton!
    @IBOutlet weak var projectNameLabel: UILabel!
    
    // MARK: - PROPERTIES
    var projectIsSelected: Bool?
    var theProject: Project?
    weak var delegate: SelectorTableCellDelegate?
    
    func initToggle() {
        
        checkBoxButton.initToggle(isCheckBox: true,boxTint: ThemeColors.teal.uicolor)
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onSelector(_ sender: Any) {
        
        if projectIsSelected! {
            
            checkBoxButton.setState(false)
            delegate!.projectWasDeselected(project: theProject!)
            projectIsSelected = false
        }
        
        else {
            
            checkBoxButton.setState(true)
            delegate!.projectWasSelected(project: theProject!)
            projectIsSelected = true
        }
    }
}

//
//  SelectorListCell.swift
//  InView
//
//  Created by Roger Vogel on 10/3/22.
//

import UIKit
import ToggleGroup

class ContactSelectorListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var checkBoxButton: ToggleButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - PROPERTIES
    var contactIsSelected: Bool?
    var theContact: Contact?
    weak var delegate: SelectorTableCellDelegate?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
        
        super.awakeFromNib()
        photoImageView.frameInCircle()
    }
    
    func initToggle() {
        
        checkBoxButton.initToggle(isCheckBox: true, boxTint: ThemeColors.teal.uicolor)
    }

    // MARK: - ACTION HANDLERS
    @IBAction func onSelector(_ sender: Any) {
   
        if contactIsSelected! {
            
            checkBoxButton.setState(false)
            delegate!.contactWasDeselected(contact: theContact!)
            contactIsSelected = false
        }
        
        else {
            
            checkBoxButton.setState(true)
            delegate!.contactWasSelected(contact: theContact!)
            contactIsSelected = true
        }
    }
}

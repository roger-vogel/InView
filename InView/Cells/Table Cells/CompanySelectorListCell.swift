//
//  CompanySelectorListCell.swift
//  InView
//
//  Created by Roger Vogel on 1/6/23.
//

import UIKit
import ToggleGroup

class CompanySelectorListCell: UITableViewCell {

    @IBOutlet weak var checkBoxButton: ToggleButton!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyAddressLabel: UILabel!
    
    // MARK: - PROPERTIES
      var companyIsSelected: Bool?
      var theCompany: Company?
      weak var delegate: SelectorTableCellDelegate?

    override func awakeFromNib() {
    
        super.awakeFromNib()
    }
    
    func initToggle() {
        
        checkBoxButton.initToggle(isCheckBox: true, boxTint: ThemeColors.teal.uicolor)
    }

    @IBAction func onSelector(_ sender: Any) {
        
        if companyIsSelected! {
            
            checkBoxButton.setState(false)
            delegate!.companyWasDeselected(company: theCompany!)
            companyIsSelected = false
        }
        
        else {
            
            checkBoxButton.setState(true)
            delegate!.companyWasSelected(company: theCompany!)
            companyIsSelected = true
        }
    }
}

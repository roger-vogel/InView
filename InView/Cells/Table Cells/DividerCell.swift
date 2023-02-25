//
//  DividerCell.swift
//  InView
//
//  Created by Roger Vogel on 12/14/22.
//

import UIKit

class DividerCell: UITableViewCell {
 
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var titleTextField: UITextField!
    
    // MARK: - PROPERTIES
    var myIndex: Int?
    weak var delegate: DividerTableCellDelegate?
    
    // MARK: - ACTION HANDLERS
    @IBAction func onPrimaryAction(_ sender: Any) {
        
        endEditing(true)
        delegate!.titleHasChanged(forIndex: myIndex!, name: titleTextField.text!)
    }
}

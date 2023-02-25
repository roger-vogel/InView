//
//  DuplicateListCell.swift
//  InView
//
//  Created by Roger Vogel on 11/19/22.
//

import UIKit

class DuplicateListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var duplicatesLabel: UILabel!
    @IBOutlet weak var dividerLabel: UILabel!
    
    // MARK: - PROPERTIES
    var cellContact: Contact?
}

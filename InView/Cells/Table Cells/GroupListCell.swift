//
//  GroupListCell.swift
//  InView
//
//  Created by Roger Vogel on 10/5/22.
//

import UIKit

class GroupListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var groupNameLabel: UITextField!
    @IBOutlet weak var dividerLabel: UILabel!
    
    // MARK: - PROPERTIES
    var theGroup: Group?
}

//
//  ContactListCell.swift
//  InView
//
//  Created by Roger Vogel on 9/23/22.
//

import UIKit

class ContactListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UITextField!
    @IBOutlet weak var dividerLabel: UILabel!
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
 
        super.awakeFromNib()
        contactImageView.frameInCircle()
    }
}

//
//  GroupDetailsCell.swift
//  InView
//
//  Created by Roger Vogel on 10/25/22.
//

import UIKit

class GroupDetailsListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var labelFieldOne: UITextField!
    @IBOutlet weak var labelFieldTwo: UITextField!
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
    
        super.awakeFromNib()
        memberImageView.frameInCircle()
    }
}

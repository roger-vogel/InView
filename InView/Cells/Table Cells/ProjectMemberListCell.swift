//
//  ProjectMemberListCell.swift
//  InView
//
//  Created by Roger Vogel on 10/9/22.
//

import UIKit

class ProjectMemberListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactTitleLabel: UILabel!
    
    // MARK: - PROPERTIES
    var theContact: Contact?
    var parentController: ParentViewController?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
        
        contactImageView.frameInCircle()
        super.awakeFromNib()
    }

    // MARK: - ACTION HANDLERS
    @IBAction func onPhone(_ sender: Any) {  LaunchManager.shared.callContact(contact: theContact!) }
    
    @IBAction func onMessage(_ sender: Any) { LaunchManager.shared.messageContact(contact: theContact!) }
    
    @IBAction func onEmail(_ sender: Any) { LaunchManager.shared.emailContact(contact: theContact!) }
}

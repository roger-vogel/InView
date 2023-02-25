//
//  CompanyListCell.swift
//  InView
//
//  Created by Roger Vogel on 10/3/22.
//

import UIKit

class CompanyListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var companyNameLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var dividerLabel: UILabel!
    
    // MARK: PROPERTIES
    var theCompany: Company?
    var parentController: ParentViewController?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
 
        super.awakeFromNib()
        companyImageView.frameInCircle()
    }
}

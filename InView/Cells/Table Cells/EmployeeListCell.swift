//
//  EmployeeListCell.swift
//  InView
//
//  Created by Roger Vogel on 10/3/22.
//

import UIKit

class EmployeeListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var employeeImageView: UIImageView!
    @IBOutlet weak var employeeNameTextField: UITextField!
    @IBOutlet weak var employeeTitleTextField: UITextField!
    
    // MARK: - PROPERTIES
    var theContact: Contact?
    weak var delegate: EmployeeTableCellDelegate?
   
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
 
        super.awakeFromNib()
        employeeImageView.frameInCircle()
    }

    // MARK: - ACTION BUTTONS
    @IBAction func onPhoto(_ sender: Any) { delegate!.showEmployee(theContact!) }
    
    @IBAction func onPhone(_ sender: Any) { delegate!.callEmployee(theContact!) }

    @IBAction func onMessage(_ sender: Any) { delegate!.messageEmployee(theContact!) }

    @IBAction func onEmail(_ sender: Any) { delegate!.emailEmployee(theContact!) }
  
}

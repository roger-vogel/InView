//
//  DuplicateDetailsCell.swift
//  InView
//
//  Created by Roger Vogel on 11/19/22.
//

import UIKit
import ToggleGroup

class DuplicateDetailsCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var checkButton: ToggleButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var mergeLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var primaryStreetTextField: UITextField!
    @IBOutlet weak var subStreetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    @IBOutlet weak var homePhoneTextField: UITextField!
    @IBOutlet weak var workPhoneTextField: UITextField!
    @IBOutlet weak var customPhoneTextField: UITextField!
    
    @IBOutlet weak var personalEmailTextField: UITextField!
    @IBOutlet weak var workEmailTextField: UITextField!
    @IBOutlet weak var otherEmailTextField: UITextField!
    @IBOutlet weak var customEmailTextField: UITextField!
    
    // MARK: - PROPERTIES
    var myIndexPath: IndexPath?
    var cellContact: Contact?
    weak var delegate: DuplicateTableCellDelegate?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
        
        super.awakeFromNib()
        photoImageView.frameInCircle()
    }
    
    // MARK: - METHODS
    func setContact(withContact: Contact) {
        
        cellContact = withContact
        
        if withContact.hasPhoto { photoImageView.image = UIImage(data: Data(base64Encoded: withContact.photo!)!)! }
        else { photoImageView.image = GlobalData.shared.companyNoPhoto }
        
        nameTextField.text = withContact.firstName! + " " + withContact.lastName!
        titleTextField.text =         "Title:    " + withContact.title!
        companyTextField.text = withContact.company != nil ? "Company:  " + withContact.company!.name! : ""
        primaryStreetTextField.text = "Street:   " + withContact.primaryStreet!
        subStreetTextField.text =     "Street 2: " + withContact.subStreet!
        cityTextField.text =          "City:     " + withContact.city!
        stateTextField.text =         "State:    " + withContact.state!
        postalCodeTextField.text =    "Post Code " + withContact.postalCode!
       
        mobilePhoneTextField.text = "M: " + withContact.mobilePhone!.formattedPhone
        homePhoneTextField.text =   "H: " + withContact.homePhone!.formattedPhone
        workPhoneTextField.text =   "W: " + withContact.workPhone!.formattedPhone
        customPhoneTextField.text = "C: " + withContact.customPhone!.formattedPhone
        
        personalEmailTextField.text = "P: " + withContact.personalEmail!
        workEmailTextField.text =     "W: " + withContact.workEmail!
        otherEmailTextField.text =    "O: " + withContact.otherEmail!
        customEmailTextField.text =   "C: " + withContact.customEmail!
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onCheckButton(_ sender: Any) {
        
        if checkButton.isOn {
            
            checkButton.setState(false)
            delegate!.contactWasDeselected(contact: cellContact!, indexPath: myIndexPath!)
        }
        
        else {
            
            checkButton.setState(true)
            delegate!.contactWasSelected(contact: cellContact!, indexPath: myIndexPath!)
        }
    }
}

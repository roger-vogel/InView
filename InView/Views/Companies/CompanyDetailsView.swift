//
//  CompanyDetailsView.swift
//  InView
//
//  Created by Roger Vogel on 10/3/22.
//

import UIKit
import AlertManager
import ColorManager
import CustomControls

class CompanyDetailsView: ParentView {
   
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var companyPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var streetLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var quickNotesTextView: UITextView!
    @IBOutlet weak var marketLabel: UILabel!
    @IBOutlet weak var categoryLabel: UITextField!
    
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var invoiceButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var activitiesButton: UIButton!
    @IBOutlet weak var projectsButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var employeeTableView: UITableView!
    
    @IBOutlet weak var invoiceInfoView: UIView!
    @IBOutlet weak var poReferenceTextField: UITextField!
    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var termsTextField: UITextField!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var cancelInvoiceButton: RoundedBorderedButton!
    @IBOutlet weak var createInvoiceButton: RoundedBorderedButton!
    
    @IBOutlet weak var addContactView: UIView!
    @IBOutlet weak var existingContactButton: UIButton!
    @IBOutlet weak var newContactButton: UIButton!
    @IBOutlet weak var cancelContactButton: UIButton!
    
    // MARK: - PROPERTIES
    var photoImagePicker = UIImagePickerController()
    var termsPicker = UIPickerView()
    var toolbar = Toolbar()
    var theCompany: Company?
    var theEmployees = [Contact]()
    var invoiceOptions = InvoiceOptions()
    
    // MARK: - COMPUTED PROPERTIES
    var hasProjects: Bool {
        
        if theCompany!.projects!.count > 0 { return true }
        return false
    }
    
    var hasActivities: Bool {
        
        if theCompany!.activities != nil && theCompany!.activities!.count > 0 { return true }
        return false
    }
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        super.initView(inController: inController)
        
        quickNotesTextView.textContainerInset = UIEdgeInsets(top: 3.5, left: 2, bottom: 2, right: 2)
        companyPhoto.frameInCircle()
        
        discountTextField.delegate = self
        
        toolbar.setup(parent: self)
        quickNotesTextView.delegate = self
        quickNotesTextView.inputAccessoryView = toolbar
        
        photoImagePicker.delegate = self
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: employeeTableView.frame.width, height: 10))
        label.backgroundColor = ThemeColors.beige.uicolor
        
        employeeTableView.delegate = self
        employeeTableView.dataSource = self
        employeeTableView.isEditing = true
        employeeTableView.allowsSelectionDuringEditing = true
        employeeTableView.sectionHeaderTopPadding = 0
        employeeTableView.tableFooterView = label
        
        toolbar.onCompletion = self
        quickNotesTextView.delegate = self
        quickNotesTextView.inputAccessoryView = toolbar
        quickNotesTextView.setBorder(width: 1.0, color: ThemeColors.teal.cgcolor)
        quickNotesTextView.roundCorners(corners: .all)
        
        commentsTextView.delegate = self
        commentsTextView.inputAccessoryView = toolbar
        commentsTextView.roundCorners(corners: .all)
        
        termsPicker.delegate = self
        termsPicker.dataSource = self
        
        termsTextField.inputAccessoryView = toolbar
        termsTextField.inputView = termsPicker
        termsTextField.rightView = UIImageView(image: UIImage(named: "button.up.down"))
        termsTextField.rightView!.contentMode = .scaleAspectFit
        termsTextField.translatesAutoresizingMaskIntoConstraints = false
        termsTextField.rightView!.widthAnchor.constraint(equalToConstant: 20).isActive = true
        termsTextField.rightView!.heightAnchor.constraint(equalToConstant: termsTextField.frame.height * 0.95).isActive = true
        termsTextField.rightViewMode = .always
        
        addContactView.setBorder(width: 2.0, color: UIColor.white.cgColor)
        addContactView.roundAllCorners(value: 10)
        addContactView.isHidden = true
        addContactView.alpha = 0.0
        addContactView.layer.shadowColor = UIColor.black.cgColor
        addContactView.layer.shadowOpacity = 0.65
        addContactView.layer.shadowOffset = .zero
        
        invoiceInfoView.setBorder(width: 2.0, color: UIColor.white.cgColor)
        invoiceInfoView.roundAllCorners(value: 10)
        invoiceInfoView.isHidden = true
        invoiceInfoView.alpha = 0.0
        invoiceInfoView.layer.shadowColor = UIColor.black.cgColor
        invoiceInfoView.layer.shadowOpacity = 0.65
        invoiceInfoView.layer.shadowOffset = .zero
        
        existingContactButton.setBorder(width: 2.0, color: UIColor.white.cgColor)
        existingContactButton.roundAllCorners(value: 15)
        
        newContactButton.setBorder(width: 2.0, color: UIColor.white.cgColor)
        newContactButton.roundAllCorners(value: 15)
        
        cancelContactButton.setBorder(width: 1.0, color: ThemeColors.beige.cgcolor)
        cancelContactButton.roundAllCorners(value: 15)
        
        invoiceButton.roundAllCorners(value: 3)
    }
    
    func initializeOptions() {
        
        discountTextField.text = String(format: "%.02f", theCompany!.discount * 100).formattedPercent
        termsTextField.text = theCompany!.terms
        
        termsPicker.setRow(forKey: theCompany!.terms!, inData: GlobalData.shared.theTerms)
    }
    
    // MARK: - METHODS
    func setCompanyRecord(company: Company? = nil ) {
        
        if company != nil { theCompany = company! }
      
        if theCompany!.hasPhoto { companyPhoto.image = UIImage(data: Data(base64Encoded: theCompany!.photo!)!)! }
        else { companyPhoto.image = GlobalData.shared.companyNoPhoto}
        
        nameLabel.text = theCompany!.name!
        
        if parentController!.contactController.coreData!.addressIsIncomplete(theCompany: theCompany!) {
            
            streetLabel.text = "Address is incomplete"
            cityLabel.text = ""
                
        } else {
            
            streetLabel.text = theCompany!.primaryStreet! + " " + theCompany!.subStreet!
            cityLabel.text = theCompany!.city! + ", " + States.nameToAbbrev(name: theCompany!.state!) + " " + theCompany!.postalCode!
        }
        
        if theCompany!.phone!.isEmpty { phoneLabel.text = "No Phone Entered" }
        else { phoneLabel.text = theCompany!.phone!.formattedPhone }
       
        if theCompany!.quickNotes!.isEmpty {
            
            quickNotesTextView.text = "Enter notes here"
            quickNotesTextView.textColor = ColorManager(grayScalePercent: 70).uicolor
            
        } else {
            
            quickNotesTextView.text = theCompany!.quickNotes!
            quickNotesTextView.textColor = ThemeColors.darkGray.uicolor
        }
        
        if theCompany!.market != nil {
            
            marketLabel.text = theCompany!.market!.area == "" ? "Market Area: None Selected" : "Market Area: " + theCompany!.market!.area!
            
        } else { marketLabel.text = "Market Area: None Selected" }
        
        if theCompany!.category != nil {
            
           categoryLabel.text = theCompany!.category!.category == "" ? "No Category Selected" : "Category: " + theCompany!.category!.category!
            
        } else { categoryLabel.text = "Category: None Selected" }
        
        setTermsPicker()
        initializeOptions()
        reloadEmployeeTable()
        setActionButtonState()
   
    }
    
    func setTermsPicker() {
        
        let defaultInvoiceValues = parentController!.contactController.coreData!.defaultInvoiceValues!
        
        if defaultInvoiceValues.isEmpty {  termsTextField.text = GlobalData.shared.theTerms.first! }
        else if defaultInvoiceValues.first!.terms!.isEmpty { termsTextField.text = GlobalData.shared.theTerms.first! }
        else { termsPicker.setRow(forKey: defaultInvoiceValues.first!.terms!, inData: GlobalData.shared.theTerms) }
    }
    
    func setActionButtonState() {
        
        guard theCompany != nil else { return }
        guard theCompany!.projects != nil else { return }
        
        if theCompany!.phone == "" {
            
            phoneButton.alpha = 0.50
            phoneButton.isEnabled = false
            
        } else {
            
            phoneButton.alpha = 1.0
            phoneButton.isEnabled = true
        }
        
        if theEmployees.count == 0 {
            
            messageButton.alpha = 0.50
            messageButton.isEnabled = false
            
            emailButton.alpha = 0.50
            emailButton.isEnabled = false
            
        } else {
            
            messageButton.alpha = 1.0
            messageButton.isEnabled = true
            
            emailButton.alpha = 1.0
            emailButton.isEnabled = true
        }
        
        if theCompany!.website == "" {
            
            websiteButton.alpha = 0.50
            websiteButton.isEnabled = false
            
        } else {
            
            websiteButton.alpha = 1.0
            websiteButton.isEnabled = true
        }
        
        if theCompany!.primaryStreet == "No Address Entered" {
            
            mapButton.alpha = 0.50
            mapButton.isEnabled = false
            
        } else {
            
            mapButton.alpha = 1.0
            mapButton.isEnabled = true
        }
        
        if streetLabel.text == "Address is incomplete" {
            
            mapButton.alpha = 0.50
            mapButton.isEnabled = false
            
        } else {
            
            mapButton.alpha = 1.0
            mapButton.isEnabled = true
        }
        
        if InvoiceManager.shared.createInvoiceItems(company: theCompany!).isEmpty {
            
            invoiceButton.isEnabled = false
            invoiceButton.alpha = 0.50
            
        } else {
            
            invoiceButton.isEnabled = true
            invoiceButton.alpha = 1.0
        }
    }
    
    func createInvoiceNumber() {
        
        let countRecord = parentController!.contactController.coreData!.counterArray!.first!
        let count = countRecord.countValue + 1
       
        invoiceOptions.invoiceNumber = "INV-" + String(count)
        
        countRecord.countValue = count
        GlobalData.shared.saveCoreData()
    }
    
    // Get the company employees in an array
    func reloadEmployeeTable() {
        
        guard theCompany != nil else { return }
        
        theEmployees.removeAll()
        
        for setItem in theCompany!.employees! { theEmployees.append(setItem as! Contact) }
    
        theEmployees.sort { $0.lastName! < $1.lastName! }
        employeeTableView.reloadData()
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onPhoto(_ sender: Any) {
        
        if theCompany!.hasPhoto {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Photo Update", buttonTitles: ["Change Photo","Delete Photo","Cancel"], theStyle: [.default, .destructive, .cancel], theType: .actionSheet) { (choice) in
                
                switch choice {
                    
                    case 0:
                    
                        self.parentController!.present(self.photoImagePicker, animated: true, completion: nil)
                    
                    case 1:
                    
                        self.theCompany!.hasPhoto = false
                        self.theCompany!.photo = ""
                        self.companyPhoto.image = GlobalData.shared.companyNoPhoto
                  
                    default: break
                }
            }
        }
        
        else { parentController!.present(photoImagePicker, animated: true, completion: nil) }
    }
 
    @IBAction func onInvoice(_ sender: Any) {
        
        if parentController!.contactController.coreData!.defaultInvoiceValues!.isEmpty {
             
             AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aMessage: "You need to complete the invoice setup before you can create an invoice", buttonTitles: ["SETUP","CANCEL"], theStyle: [.default,.cancel], theType: .alert) { choice in
                 
                 if choice == 0 {
                     
                     GlobalData.shared.preselectedMenuOption = MenuOptions.shared.invoiceSetup
                     self.parentController!.companyController.companyListView.showView(withTabBar: true)
                     self.parentController!.companyController.companyListView.onMenu(self)
                 }
             }
             
             return
         }
        
        returnButton.isEnabled = false
        editButton.isEnabled = false
        sendButton.isEnabled = false
        
        let invoiceInfo = parentController!.contactController.coreData!.defaultInvoiceValues!.first!
        
        discountTextField.text = String(invoiceInfo.defaultDiscount * 100).formattedPercent
       // dueDateTextField.text = invoiceInfo.
        
        invoiceInfoView.isHidden = false
        bringSubviewToFront(invoiceInfoView)
        UIView.animate(withDuration:0.25, animations: { self.invoiceInfoView.alpha = 1.0 })
    }
    
    @IBAction func onPhone(_ sender: Any) { LaunchManager.shared.call(atNumber: theCompany!.phone!) }
  
    @IBAction func onMessage(_ sender: Any) { LaunchManager.shared.messageContacts(contacts: theEmployees) }
    
    @IBAction func onEmail(_ sender: Any) { LaunchManager.shared.emailContacts(contacts: theEmployees) }
    
    @IBAction func onLog(_ sender: Any) {
        
        parentController!.companyController.companyLogListView.setCompanyRecord(company: theCompany!)
        parentController!.companyController.companyLogListView.showView(withTabBar: false)
    }
    
    @IBAction func onActivities(_ sender: Any) {
        
        let activityList = parentController!.companyController.companyActivityListView
        
        activityList!.clear()
        activityList!.setCompany(theCompany)
        activityList!.showView(withTabBar: false)
    }
    
    @IBAction func onProjects(_ sender: Any) {
        
        parentController!.companyController.companyProjectListView.setCompany(theCompany!)
        parentController!.companyController.companyProjectListView.showView(withTabBar: false)
    }
    
    @IBAction func onBrowser(_ sender: Any) { LaunchManager.shared.launchBrowser(url: theCompany!.website!) }
    
    @IBAction func onMap(_ sender: Any) { LaunchManager.shared.launchMaps(company: theCompany!) }
    
    @IBAction func modifyEmployeeList(_ sender: Any) {
        
        returnButton.isEnabled = false
        editButton.isEnabled = false
        sendButton.isEnabled = false
        
        addContactView.isHidden = false
        bringSubviewToFront(addContactView)
        UIView.animate(withDuration:0.25, animations: { self.addContactView.alpha = 1.0 })
    }
   
    @IBAction func onEdit(_ sender: Any) {
        
        parentController!.companyController.companyEditView.setCompanyRecord(company: theCompany!)
        parentController!.companyController.companyEditView.showView(withTabBar: false)
    }
    
    @IBAction func onSend(_ sender: Any) {
        
        // Build vCard
        let begin = "BEGIN:VCARD\n"
        let version = "VERSION:4.0\n"
        let cardName = "FN:" + theCompany!.name! + "\n"
        let address = "ADR;TYPE=work:;" + theCompany!.subStreet! + ";" + theCompany!.primaryStreet! + ";" + theCompany!.city! + ";" + theCompany!.state! + ";" + theCompany!.postalCode! + ";;" + "\n"
        let workPhone = theCompany!.phone!.isEmpty ? "" : "TEL;TYPE=work:" + theCompany!.phone!.cleanedPhone + "\n"
        let website = theCompany!.website!.isEmpty ? "" : "URL:" + theCompany!.website! + "\n"
        let photo = theCompany!.hasPhoto ? "PHOTO;ENCODING=BASE64;TYPE=JPEG:" + theCompany!.photo! + "\n" : ""
      
        let fileString = begin + version + cardName + address + workPhone + website + photo + "END:VCARD"
        
        // Send email or message?
        AlertManager(controller: parentController!).popupWithCustomButtons(aTitle: "Send By", buttonTitles: ["EMAIL","TEXT","CANCEL"], theStyle: [.default,.default,.destructive], theType: .actionSheet) { choice in
            
            switch choice {
                
                case 0: self.parentController!.sendEmailWithAttachment(contentTitle: self.theCompany!.name!, fileType: "vcf", theData: Data(fileString.utf8))
                case 1: self.parentController!.sendMessageWithAttachment(contentTitle: self.theCompany!.name!, fileType: "vcf", theData: Data(fileString.utf8))
                    
                default: break
            }
        }
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        guard thelastTab != nil else  {
            
            parentController!.companyController.companyListView.showView()
            return
        }
        
        switch thelastTab {
        
            case Tabs.projects:
            
                parentController!.projectController.launchPrimaryView = false
                parentController!.projectController.projectCompanyView.setProjectRecord()
                parentController!.gotoTab(Tabs.projects, showingView: parentController!.projectController.projectCompanyView, withTabBar: false)
            
            case Tabs.groups:
            
                parentController!.groupController.launchPrimaryView = false
                parentController!.groupController.groupDetailsView.setGroupRecord()
                parentController!.gotoTab(Tabs.groups, showingView: parentController!.groupController.groupDetailsView, withTabBar: false)
                
            default: break
        }
        
        
       parentController!.companyController.companyListView.showView()
    }
    
    @IBAction func onExistingContact(_ sender: Any) {
        
        parentController!.companyController.employeeSelectionView.theCompany = theCompany!
        parentController!.companyController.employeeSelectionView.loadView(contacts: theEmployees)
        parentController!.companyController.employeeSelectionView.showView(withTabBar: false)
        
        addContactView.alpha = 0.0
        addContactView.isHidden = true
        
        returnButton.isEnabled = true
        editButton.isEnabled = true
        sendButton.isEnabled = true
    }
    
    @IBAction func onNewContact(_ sender: Any) {
        
        parentController!.contactController.contactEditView.setContactRecord(newContact: true, isFromCompany: theCompany!)
        parentController!.gotoTab(Tabs.contacts, showingView: parentController!.contactController.contactEditView, fade: false, withTabBar: false)
        
        addContactView.alpha = 0.0
        addContactView.isHidden = true
        
        returnButton.isEnabled = true
        editButton.isEnabled = true
        sendButton.isEnabled = true
    }
    
    @IBAction func onCreateInvoice(_ sender: Any) {
        
        let projectName = parentController!.contactController.coreData!.setToArray(projects: theCompany!.projects!).first!.name!
        
        invoiceOptions.poReference = poReferenceTextField.text!
        invoiceOptions.terms = termsTextField.text!
        invoiceOptions.discount = discountTextField.text!.cleanedValue
        invoiceOptions.comments = commentsTextView.text!
        invoiceOptions.projectName = projectName
        
        createInvoiceNumber()
        
        parentController!.companyController.companyInvoiceView.setCompany(company: theCompany!, options: invoiceOptions)
        parentController!.companyController.companyInvoiceView.showView(withTabBar: false)
        
        onCancelInvoice(self)
    }
    
    @IBAction func onCancelInvoice(_ sender: Any) {
        
        returnButton.isEnabled = true
        editButton.isEnabled = true
        sendButton.isEnabled = true
        
        invoiceInfoView.alpha = 0.0
        invoiceInfoView.isHidden = true
    }

    @IBAction func onCancel(_ sender: Any) {
        
        returnButton.isEnabled = true
        editButton.isEnabled = true
        sendButton.isEnabled = true
        
        addContactView.alpha = 0.0
        addContactView.isHidden = true
    }
}

// MARK: - EMPLOYEE CELL DELEGATE PROTOCOL
extension CompanyDetailsView: EmployeeTableCellDelegate {
    
    func showEmployee(_ employee: Contact) {
        
    }
  
    func callEmployee(_ employee: Contact) { LaunchManager.shared.callContact(contact: employee)}
    
    func messageEmployee(_ employee: Contact) { LaunchManager.shared.messageContact(contact: employee) }
    
    func emailEmployee(_ employee: Contact) { LaunchManager.shared.emailContact(contact: employee) }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension CompanyDetailsView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
         
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { theEmployees.count }
        
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 60 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeListStyle", for: indexPath) as! EmployeeListCell
        let employee = theEmployees[indexPath.row]
        
        cell.delegate = self
        cell.theContact = employee
        
        if employee.hasPhoto { cell.employeeImageView.image = UIImage(data: Data(base64Encoded: employee.photo!)!)}
        else { cell.employeeImageView.image = GlobalData.shared.contactNoPhoto }
        
        cell.employeeNameTextField.text = employee.firstName! + " " + employee.lastName!
        cell.employeeTitleTextField.text = employee.title! == "" ? "No title entered" : employee.title!
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return cell
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if parentController!.contactController.contactDetailsView!.parentController == nil {
            
            parentController!.contactController.contactDetailsView!.initView(inController: parentController!.contactController)
        }
      
        parentController!.contactController.launchPrimaryView = false
        parentController!.contactController.contactDetailsView.thelastTab = Tabs.companies
        parentController!.contactController.contactDetailsView.setContactRecord(contact: theEmployees[indexPath.row])
        parentController!.gotoTab(Tabs.contacts, showingView: parentController!.contactController.contactDetailsView, withTabBar: false)
    }
    
    // Allow row move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Move a row
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let itemToMove = theEmployees[sourceIndexPath.row]
        theEmployees.remove(at: sourceIndexPath.row)
        theEmployees.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    // Don't indent in edit mode
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { return false }
         
    // Show only drag bars
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {  return .none }
}

// MARK: - TEXT FIELD DELEGATE PROTOCOL
extension CompanyDetailsView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.text = textField.text!.cleanedPercent
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.text = textField.text!.formattedPercent
    }
}

// MARK: - TEXT VIEW DELEGATE PROTOCOL
extension CompanyDetailsView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView.text == "Enter notes here" {
            
            textView.text.removeAll()
            textView.textColor = .darkGray
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        guard theCompany != nil else { return true }
        guard theCompany!.quickNotes != nil else { return true }
        
        if quickNotesTextView.text == "Enter notes here" { quickNotesTextView.text.removeAll() }
        
        theCompany!.quickNotes = quickNotesTextView.text!
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()

        return true
    }
}

// MARK: - TOOL BAR DELEGATE PROTOCOL
extension CompanyDetailsView: ToolBarDelegate {
   
    func doneButtonTapped() {
        
        if quickNotesTextView.text.isEmpty {
            
            quickNotesTextView.text = "Enter notes here"
            quickNotesTextView.textColor = ColorManager(grayScalePercent: 70).uicolor
            
        } else { quickNotesTextView.textColor = ThemeColors.darkGray.uicolor }
    }
}

// MARK: - PICKER PROTOCOL
extension CompanyDetailsView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { return 30 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return GlobalData.shared.theTerms.count }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return GlobalData.shared.theTerms[row] }
 
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { termsTextField.text = GlobalData.shared.theTerms[row] }
}

// MARK: - IMAGE PICKER PROTOTOL
extension CompanyDetailsView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    // MARK: - IMAGE PICKER DELEGATE PROTOCOL
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as? UIImage
      
        parentController!.dismiss(animated: true, completion: { () -> Void in
            
            guard selectedImage != nil else { return }
            
            self.theCompany!.photo = selectedImage!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
            self.theCompany!.hasPhoto = true
            self.companyPhoto.image = selectedImage!
            
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        })
    }
}



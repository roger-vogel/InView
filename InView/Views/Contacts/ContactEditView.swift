//
//  ContactEditView.swift
//  InView
//
//  Created by Roger Vogel on 9/28/22.
//

import UIKit
import AlertManager

class ContactEditView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleNameLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    @IBOutlet weak var homePhoneTextField: UITextField!
    @IBOutlet weak var workPhoneTextField: UITextField!
    @IBOutlet weak var customPhoneTextField: UITextField!
    
    @IBOutlet weak var personalEmailTextField: UITextField!
    @IBOutlet weak var workEmailTextField: UITextField!
    @IBOutlet weak var otherEmailTextField: UITextField!
    @IBOutlet weak var customEmailTextField: UITextField!
    
    @IBOutlet weak var primaryStreetTextField: UITextField!
    @IBOutlet weak var subStreetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    
    // MARK: - PROPERTIES
    var selectedCompany: Company?
    var selectedCategory: ContactCategory?
    var theContact = Contact()
    var toolbar = Toolbar()
    var categoryPickerView = UIPickerView()
    var companyPickerView = UIPickerView()
    var isNewContact: Bool?
    var companyNames = [String]()
    var categoryNames = [String]()
    var isFromCompany: Company?
    var isFromProject: Project?
   
    // MARK: - COMPUTED PROPERTIES
     var categoryDictionary: [String:ContactCategory] {
         
         var theCategories = [String: ContactCategory]()
  
         categoryNames.removeAll()
       
         for category in parentController!.contactController.coreData!.contactCategories! {
             
             theCategories[category.category!] = category
             categoryNames.append(category.category!)
         }
         
         categoryNames.insert("No Category", at: 0)
         return theCategories
     }
     
     var companyDictionary: [String:Company] {
         
         var theCompanies = [String: Company]()
  
         companyNames.removeAll()
       
         for company in parentController!.contactController.coreData!.companies! {
             
             theCompanies[company.name!] = company
             companyNames.append(company.name!)
         }
         
         companyNames.sort { $0 < $1 }
         companyNames.insert("No Company", at: 0)
         return theCompanies
     }
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
      
        theScrollView = scrollView
        theContentHeightConstraint = contentHeightConstraint
        super.initView(inController: inController)
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        companyPickerView.delegate = self
        companyPickerView.dataSource = self
      
        toolbar.setup(parent: self)
        postalCodeTextField.inputAccessoryView = toolbar
        
        let phoneFields = [mobilePhoneTextField,homePhoneTextField,workPhoneTextField,customPhoneTextField]
        for field in phoneFields { field!.inputAccessoryView = toolbar }
            
        categoryTextField.inputView = categoryPickerView
        categoryTextField.inputAccessoryView = toolbar
        categoryTextField.rightView = UIImageView(image: UIImage(named: "button.up.down"))
        categoryTextField.rightView!.widthAnchor.constraint(equalToConstant: 20).isActive = true
        categoryTextField.rightView!.heightAnchor.constraint(equalToConstant: categoryTextField.frame.height * 0.95).isActive = true
        categoryTextField.rightViewMode = .always
        
        companyTextField.inputView = companyPickerView
        companyTextField.inputAccessoryView = toolbar
        companyTextField.rightView = UIImageView(image: UIImage(named: "button.up.down"))
        companyTextField.rightView!.contentMode = .scaleAspectFit
        companyTextField.translatesAutoresizingMaskIntoConstraints = false
        companyTextField.rightView!.widthAnchor.constraint(equalToConstant: 20).isActive = true
        companyTextField.rightView!.heightAnchor.constraint(equalToConstant: companyTextField.frame.height * 0.95).isActive = true
        companyTextField.rightViewMode = .always
    
        setTextFieldDelegates()
    }
    
    // MARK: - METHODS
    func setTextFieldDelegates() {
        
        let textFields = [
            firstNameTextField,
            lastNameTextField,
            titleTextField,
            companyTextField,
            mobilePhoneTextField,
            homePhoneTextField,
            workPhoneTextField,
            customPhoneTextField,
            personalEmailTextField,
            workEmailTextField,
            otherEmailTextField,
            customEmailTextField,
            primaryStreetTextField,
            subStreetTextField,
            cityTextField,
            stateTextField,
            postalCodeTextField,
            categoryTextField
        ]
        
        for field in textFields { field!.delegate = self }
    }
    
    func setContactRecord(contact: Contact? = nil, newContact: Bool? = false, isFromCompany: Company? = nil, isFromProject: Project? = nil) {
        
        self.isFromCompany = isFromCompany
        self.isFromProject = isFromProject
        
        if self.isFromCompany != nil {
            
            var theNames: [String]?
            
            theNames = parentController!.contactController.coreData!.companyNames
          
            companyTextField.text = isFromCompany!.name!
            companyPickerView.setRow(forKey: isFromCompany!.name!, inData: theNames!)
        }
        
        clearView()
        
        // Init dictionaries
        _ = categoryDictionary
        _ = companyDictionary
      
        isNewContact = newContact!
        
        if !isNewContact! {
            
            theContact = contact!
            titleNameLabel.text = theContact.firstName! + " " + theContact.lastName!
            firstNameTextField.text = theContact.firstName!
            lastNameTextField.text = theContact.lastName!
            titleTextField.text = theContact.title!
          
            mobilePhoneTextField.text = theContact.mobilePhone!.formattedPhone
            homePhoneTextField.text = theContact.homePhone!.formattedPhone
            workPhoneTextField.text = theContact.workPhone!.formattedPhone
            customPhoneTextField.text = theContact.customPhone!.formattedPhone
            
            personalEmailTextField.text = theContact.personalEmail!
            workEmailTextField.text = theContact.workEmail!
            otherEmailTextField.text = theContact.otherEmail!
            customEmailTextField.text = theContact.customEmail!
            
            primaryStreetTextField.text = theContact.primaryStreet!
            subStreetTextField.text = theContact.subStreet!
            cityTextField.text = theContact.city!
            stateTextField.text = theContact.state!
            postalCodeTextField.text = theContact.postalCode!
            
            if theContact.category != nil { categoryTextField.text = theContact.category!.category! }
            if theContact.company != nil { companyTextField.text = theContact.company!.name! }
        }
        
        else { titleNameLabel.text! = "New Contact" }
        
        setPickerData()
    }
 
    func setPickerData() {
        
        if categoryTextField.text!.isEmpty || theContact.category == nil {
            
            categoryTextField.text = "No Category"
            selectedCategory = nil
            categoryPickerView.selectRow(0, inComponent: 0, animated: false)
            
        } else {
            
            let index = categoryPickerView.setRow(forKey: theContact.category!.category!, inData: categoryNames)
            selectedCategory = categoryDictionary[categoryNames[index!]]
        }
            
        if companyTextField.text!.isEmpty || theContact.company == nil {
            
            companyTextField.text = "No Company"
            selectedCompany = nil
            companyPickerView.selectRow(0, inComponent: 0, animated: false)
            
        } else {
  
            let index = companyPickerView.setRow(forKey: theContact.company!.name!, inData: companyNames)
            selectedCompany = companyDictionary[companyNames[index!]]
        }
    }
    
    func clearView() {
        
        firstNameTextField.text!.removeAll()
        lastNameTextField.text!.removeAll()
        titleTextField.text!.removeAll()
        companyTextField.text!.removeAll()
        categoryTextField.text!.removeAll()
        
        mobilePhoneTextField.text!.removeAll()
        workPhoneTextField.text!.removeAll()
        homePhoneTextField.text!.removeAll()
        customPhoneTextField.text!.removeAll()
        
        personalEmailTextField.text!.removeAll()
        workEmailTextField.text!.removeAll()
        otherEmailTextField.text!.removeAll()
        customEmailTextField.text!.removeAll()
        
        primaryStreetTextField.text!.removeAll()
        subStreetTextField.text!.removeAll()
        cityTextField.text!.removeAll()
        stateTextField.text!.removeAll()
        postalCodeTextField.text!.removeAll()
        
        scrollView.scrollsToTop(animated: false)
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onNameChange(_ sender: Any) {
        
        if firstNameTextField.text!.isEmpty && lastNameTextField.text!.isEmpty { titleNameLabel.text = "New Contact" }
        else { titleNameLabel.text = firstNameTextField.text! + " " + lastNameTextField!.text! }
    }
    
    @IBAction func onAddCompany(_ sender: Any) {
        
        let editView = parentController!.companyController.companyEditView
        
        parentController!.companyController.companyEditView.setFromContact(true)
        parentController!.gotoTab(Tabs.companies, showingView: editView, fade: false, withTabBar: false)
    }
    
    @IBAction func onPrimaryAction(_ sender: Any) { dismissKeyboard()}
 
    @IBAction func onSave(_ sender: Any) {
        
        dismissKeyboard()
        
        if lastNameTextField.text!.isEmpty && firstNameTextField.text!.isEmpty {
            
            dismissKeyboard()
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButton(aTitle: "Incomplete Profile", aMessage: "To add a contact, you must enter at least a first name or a last name", buttonTitle: "OK", theStyle: .default, theType: .alert)
            return
        }
        
        guard States.isValidState(theState: stateTextField.text!) else {
            
            dismissKeyboard()
          
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButton(aTitle: "Invalid State", aMessage: "The state name or abbreviation you entered is invalid", buttonTitle: "OK", theStyle: .default, theType: .alert) {
                
                self.stateTextField.becomeFirstResponder()
            }
          
            return
        }
    
        if isNewContact! {
            
            let contact = Contact(context: GlobalData.shared.viewContext)
            
            contact.id = UUID()
            contact.timestamp = Date()
            contact.appId = UUID().description
            
            contact.firstName = firstNameTextField.text!
            contact.lastName = lastNameTextField.text!
            contact.title = titleTextField.text!
            
            if selectedCategory != nil { contact.category = selectedCategory! }
            if selectedCompany != nil { contact.company = selectedCompany! }
                
            contact.mobilePhone = mobilePhoneTextField.text!.cleanedPhone
            contact.homePhone = homePhoneTextField.text!.cleanedPhone
            contact.workPhone = workPhoneTextField.text!.cleanedPhone
            contact.customPhone = customPhoneTextField.text!.cleanedPhone
            
            contact.personalEmail = personalEmailTextField.text!
            contact.workEmail = workEmailTextField.text!
            contact.otherEmail = otherEmailTextField.text!
            contact.customEmail = customEmailTextField.text!
            
            contact.primaryStreet = primaryStreetTextField.text!
            contact.subStreet = subStreetTextField.text!
            contact.city = cityTextField.text!
            contact.state =  States.getStateName(theState: stateTextField.text!)
            contact.postalCode = postalCodeTextField.text!
            
            contact.hasPhoto = false
            contact.photo = ""
            contact.quickNotes = ""
            
            parentController!.contactController.coreData!.contacts!.append(contact)
            if isFromCompany != nil { isFromCompany!.addToEmployees(contact) }
            if isFromProject != nil { isFromProject!.addToTeam(contact) }
            
            GlobalData.shared.saveCoreData()
            parentController!.contactController.contactDetailsView.setContactRecord(contact: contact)
            
        } else {
   
            theContact.firstName = firstNameTextField.text!
            theContact.lastName = lastNameTextField.text!
            theContact.title = titleTextField.text!
            
            if selectedCategory != nil {
                
                if theContact.category != nil && theContact.category != selectedCategory { theContact.category!.removeFromContacts(theContact) }
             
                theContact.category = selectedCategory!
                if !selectedCategory!.contacts!.contains(theContact) { selectedCategory!.addToContacts(theContact) }
                
            } else if theContact.category != nil { theContact.category!.removeFromContacts(theContact) }
                
            if selectedCompany != nil {
                
                if theContact.company != nil && theContact.company != selectedCompany { theContact.company!.removeFromEmployees(theContact) }
             
                theContact.company = selectedCompany!
                if !selectedCompany!.employees!.contains(theContact) { selectedCompany!.addToEmployees(theContact) }
                
            } else if theContact.company != nil { theContact.company!.removeFromEmployees(theContact) }
            
            theContact.mobilePhone = mobilePhoneTextField.text!
            theContact.homePhone = homePhoneTextField.text!
            theContact.workPhone = workPhoneTextField.text!
            theContact.customPhone = customPhoneTextField.text!
            
            theContact.personalEmail = personalEmailTextField.text!
            theContact.workEmail = workEmailTextField.text!
            theContact.otherEmail = otherEmailTextField.text!
            theContact.customEmail = customEmailTextField.text!
            
            theContact.primaryStreet = primaryStreetTextField.text!
            theContact.subStreet = subStreetTextField.text!
            theContact.city = cityTextField.text!
            theContact.state = States.getStateName(theState: stateTextField.text!) 
            theContact.postalCode = postalCodeTextField.text!
            
            if isFromCompany != nil {isFromCompany!.addToEmployees(theContact) }
            if isFromProject != nil { isFromProject!.addToTeam(theContact) }
            
            GlobalData.shared.saveCoreData()
            parentController!.contactController.contactDetailsView.setContactRecord(contact: theContact)
        }
        
        onReturn(self)
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        dismissKeyboard()
        
        if isFromCompany != nil {
            
            parentController!.companyController.companyDetailsView.setCompanyRecord(company: isFromCompany!)
            parentController!.gotoTab(Tabs.companies, showingView: parentController!.companyController.companyDetailsView, withTabBar: false)
            
        } else if isFromProject != nil {
            
            parentController!.projectController.projectTeamView.reloadTeamTable()
            parentController!.gotoTab(Tabs.projects, showingView: parentController!.projectController.projectTeamView, withTabBar: false)
            
        } else {
            
            if lastNameTextField.text!.isEmpty { parentController!.contactController.contactListView.showView() }
            else { parentController!.contactController.contactDetailsView.showView(withTabBar: false) }
        }

        clearView()
    }
}

// MARK: - TEXT FIELD DELEGATE PROTOCOL
extension ContactEditView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //contentHeightConstraint.constant = 1300
        theViewInfocus = textField
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
            
            case mobilePhoneTextField: mobilePhoneTextField.text = textField.text!.formattedPhone
            case homePhoneTextField:homePhoneTextField.text = textField.text!.formattedPhone
            case workPhoneTextField: workPhoneTextField.text = textField.text!.formattedPhone
            case customPhoneTextField: customPhoneTextField.text = textField.text!.formattedPhone
           
            default: break
        }
        
        return true
    }
}

// MARK: -  PICKER PROTOCOL
extension ContactEditView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView,  rowHeightForComponent component: Int) -> CGFloat { return 30 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        

        if pickerView == categoryPickerView {
            
            _ = categoryDictionary
            return categoryNames.count
        }
        
        if pickerView == companyPickerView {
            
            _ = companyDictionary
            return companyNames.count
        }

        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == categoryPickerView { return categoryNames[row] }
        if pickerView == companyPickerView { return companyNames[row]  }
     
        return nil
    }
   
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == categoryPickerView {
            
            categoryTextField.text = categoryNames[row]
            
            if row == 0 { selectedCategory = nil }
            else { selectedCategory = categoryDictionary[categoryNames[row]] }
        }
        
        if pickerView == companyPickerView {
            
            companyTextField.text = companyNames[row]
            
            if row == 0 { selectedCompany = nil }
            else { selectedCompany = companyDictionary[companyNames[row]] }
            
        }
    }
}

//
//  CompanyEditView.swift
//  InView
//
//  Created by Roger Vogel on 10/3/22.
//

import UIKit
import AlertManager

class CompanyEditView: ParentView {
   
    // MARK: STORYBOARD CONNECTORS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var primaryStreetTextField: UITextField!
    @IBOutlet weak var subStreetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var marketTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    // MARK: - PROPERTIES
    var theCompany = Company()
    var toolbar = Toolbar()
    var marketPicker = UIPickerView()
    var categoryPicker = UIPickerView()
    var isNewCompany: Bool?
    var marketNames = [String]()
    var categoryNames = [String]()
    var selectedMarket: MarketArea?
    var selectedCategory: CompanyCategory?
    var isFromContact: Bool = false
    var isFromProject: Project?
    
    // MARK: - COMPUTED PROPERTIES
    var marketDictionary: [String: MarketArea] {
        
        var theMarkets = [String: MarketArea]()

        marketNames.removeAll()
    
        for area in parentController!.contactController.coreData!.marketAreas! {
            
            if area.area != "" {
                
                theMarkets[area.area!] = area
                marketNames.append(area.area!)
            }
        }
        
        marketNames.insert("No Category", at: 0)
        return theMarkets
    }
    
    var categoryDictionary: [String: CompanyCategory] {
        
        var theCategories = [String: CompanyCategory]()

        categoryNames.removeAll()
    
        for category in parentController!.contactController.coreData!.companyCategories! {
            
            if category.category != "" {
                
                theCategories[category.category!] = category
                categoryNames.append(category.category!)
            }
        }
        
        categoryNames.insert("No Category", at: 0)
        return theCategories
    }
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theScrollView = scrollView
        theContentHeightConstraint = contentHeightConstraint
        
        marketPicker.delegate = self
        marketPicker.dataSource = self
        marketTextField.inputView = marketPicker
        marketTextField.inputAccessoryView = toolbar
        marketTextField.rightView = UIImageView(image: UIImage(named: "button.up.down"))
        marketTextField.rightView!.contentMode = .scaleAspectFit
        marketTextField.translatesAutoresizingMaskIntoConstraints = false
        marketTextField.rightView!.widthAnchor.constraint(equalToConstant: 20).isActive = true
        marketTextField.rightView!.heightAnchor.constraint(equalToConstant: marketTextField.frame.height * 0.95).isActive = true
        marketTextField.rightViewMode = .always
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryTextField.inputView = categoryPicker
        categoryTextField.inputAccessoryView = toolbar
        categoryTextField.rightView = UIImageView(image: UIImage(named: "button.up.down"))
        categoryTextField.rightView!.contentMode = .scaleAspectFit
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false
        categoryTextField.rightView!.widthAnchor.constraint(equalToConstant: 20).isActive = true
        categoryTextField.rightView!.heightAnchor.constraint(equalToConstant: categoryTextField.frame.height * 0.95).isActive = true
        categoryTextField.rightViewMode = .always
        
        toolbar.setup(parent: self)
        phoneTextField.inputAccessoryView = toolbar
        postalCodeTextField.inputAccessoryView = toolbar
    
        marketTextField.inputView = marketPicker
        marketTextField.inputAccessoryView = toolbar
        
        categoryTextField.inputView = categoryPicker
        categoryTextField.inputAccessoryView = toolbar
        
        setTextFieldDelegates()
      
        super.initView(inController: inController)
    }
    
    // MARK: - METHODS
    func setTextFieldDelegates() {
        
        let textFields = [nameTextField,primaryStreetTextField,subStreetTextField,cityTextField,stateTextField,postalCodeTextField,phoneTextField,marketTextField,categoryTextField,websiteTextField]
        for field in textFields { field!.delegate = self }
    }
    
    func setCompanyRecord(company: Company? = nil, newCompany: Bool? = false) {
        
        clearView()
        
        isNewCompany = newCompany!
     
        if !isNewCompany! {
            
            theCompany = company!
            nameTextField.text = theCompany.name!
            primaryStreetTextField.text = theCompany.primaryStreet!
            subStreetTextField.text = theCompany.subStreet!
            cityTextField.text = theCompany.city!
            stateTextField.text = theCompany.state!
            postalCodeTextField.text = theCompany.postalCode!
            phoneTextField.text = theCompany.phone!
            websiteTextField.text = theCompany.website!
            
            if theCompany.market != nil { marketTextField.text = theCompany.market!.area! }
            if theCompany.category != nil { categoryTextField.text = theCompany.category!.category! }
        }
        
        else { titleLabel.text! = "New Company" }
        
        setPickerData()
    }
    
    func setPickerData() {
        
        _ = marketDictionary
     
        if marketTextField.text!.isEmpty { marketTextField.text = marketNames.first! }
        else { marketPicker.setRow(forKey: marketTextField.text!, inData: marketNames)}
        
        _ = categoryDictionary
     
        if categoryTextField.text!.isEmpty { categoryTextField.text = categoryNames.first! }
        else {categoryPicker.setRow(forKey: categoryTextField.text!, inData: categoryNames)}
    }
    
    func clearView() {  
        
        isFromContact = false
        titleLabel.text!.removeAll()
        nameTextField.text!.removeAll()
        primaryStreetTextField.text!.removeAll()
        subStreetTextField.text!.removeAll()
        cityTextField.text!.removeAll()
        stateTextField.text!.removeAll()
        postalCodeTextField.text!.removeAll()
        phoneTextField.text!.removeAll()
        marketTextField.text!.removeAll()
        websiteTextField.text!.removeAll()
        categoryTextField.text!.removeAll()
        
        scrollView.scrollsToTop(animated: false)
    }
    
    func setFromContact(_ state: Bool? = false) {
        
        isFromContact = state!
        isNewCompany = state!
    }
 
    // MARK: - ACTION HANDLERS
    @IBAction func onPrimaryAction(_ sender: Any) { dismissKeyboard() } 
    
    @IBAction func onNameChange(_ sender: UITextField) { titleLabel.text = sender.text! }
   
    @IBAction func onReturn(_ sender: Any) {
        
        dismissKeyboard()
        
        if isFromProject != nil {
            
            parentController!.projectController.projectCompanyView.reloadcompaniesTable()
            parentController!.gotoTab(Tabs.projects, showingView: parentController!.projectController.projectCompanyView, withTabBar: false)
      
        } else if !isFromContact {
            
            if nameTextField.text!.isEmpty { parentController!.companyController.companyListView.showView()}
            else { parentController!.companyController.companyDetailsView.showView(withTabBar: false) }
            
        } else {
            
            let controller = parentController!.contactController
            
            controller.refreshViews = false
            controller.launchPrimaryView = false
            controller.contactEditView.companyPickerView.reloadAllComponents()
            controller.contactEditView.showView(withFade: false)
            parentController!.gotoTab(Tabs.contacts)
        }
            
        clearView()
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        dismissKeyboard()
        
        guard !nameTextField.text!.isEmpty else {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButton(aTitle: "Incomplete Profile", aMessage: "To add a company, you must enter at least the company name", buttonTitle: "OK", theStyle: .default, theType: .alert)
            return
        }
        
        guard States.isValidState(theState: stateTextField.text!) else {
            
            dismissKeyboard()
          
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButton(aTitle: "Invalid State", aMessage: "The state name or abbreviation you entered is invalid", buttonTitle: "OK", theStyle: .default, theType: .alert) {
                
                self.stateTextField.becomeFirstResponder()
            }
          
            return
        }
         
        if isNewCompany! {
            
            let company = Company(context: GlobalData.shared.viewContext)
            
            company.id = UUID()
            company.appId = UUID().description
            company.timestamp = Date()
            
            company.name = nameTextField.text!
            company.primaryStreet = primaryStreetTextField.text!
            company.subStreet = subStreetTextField.text!
            company.city = cityTextField.text!
            company.state = States.getStateName(theState: stateTextField.text!)
            company.postalCode = postalCodeTextField.text!
            company.phone = phoneTextField.text!.cleanedPhone
            company.website = websiteTextField.text!
            company.hasPhoto = false
            company.photo = ""
            company.quickNotes = ""
            
            if selectedMarket != nil {
                
                company.market = selectedMarket!
                
                if !selectedMarket!.companies!.contains(company) { selectedMarket!.addToCompanies(company) }
            }
            
            if selectedCategory != nil {
                
                company.category = selectedCategory!
                if !selectedCategory!.companies!.contains(company) { selectedCategory!.addToCompanies(company) }
            }
            
            if isFromProject != nil { isFromProject!.addToCompanies(company) }
       
            parentController!.contactController.coreData!.companies!.append(company)
         
            GlobalData.shared.saveCoreData()
            
            if !isFromContact {
                
                parentController!.companyController.companyDetailsView.setCompanyRecord(company: company)
            }
        }
        
        else {
            
            theCompany.name = nameTextField.text!
            theCompany.primaryStreet = primaryStreetTextField.text!
            theCompany.website = websiteTextField.text!
        
            theCompany.subStreet = subStreetTextField.text!
            theCompany.city = cityTextField.text!
            theCompany.state = States.getStateName(theState: stateTextField.text!)
            theCompany.postalCode = postalCodeTextField.text!
            theCompany.phone = phoneTextField.text!
        
            if selectedMarket != nil {
                
                if theCompany.market != nil && theCompany.market != selectedMarket { theCompany.market!.removeFromCompanies(theCompany) }
                if !selectedMarket!.companies!.contains(theCompany) { selectedMarket!.addToCompanies(theCompany) }
            }
            
            if selectedCategory != nil {
                
                if theCompany.category != nil && theCompany.category != selectedCategory { theCompany.category!.removeFromCompanies(theCompany) }
                if !selectedCategory!.companies!.contains(theCompany) { selectedCategory!.addToCompanies(theCompany) }
            }
            
            theCompany.market = selectedMarket
            theCompany.category = selectedCategory
            
            if isFromProject != nil { isFromProject!.addToCompanies(theCompany) }
            
            GlobalData.shared.saveCoreData()
            parentController!.companyController.companyDetailsView.setCompanyRecord(company: theCompany)
           
        }
        
        onReturn(self)
    }
}

// MARK: - PICKER PROTOCOL
extension CompanyEditView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { return 30 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == marketPicker { return marketNames.count }
        else { return categoryNames.count }
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == marketPicker { return marketNames[row] }
        else { return categoryNames[row] }
    }
        
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == marketPicker {
            
            marketTextField.text = marketNames[row]
            
            if row == 0 {
                
                if selectedMarket != nil {
                    
                    if selectedMarket!.companies!.contains(theCompany) { selectedMarket!.removeFromCompanies(theCompany) }
                }
                
                selectedMarket = nil
                theCompany.market = nil
                
                
            }  else { selectedMarket = marketDictionary[marketNames[row]] }
           
        } else {
            
            categoryTextField.text = categoryNames[row]
            
            if row == 0 {
                
                if selectedCategory != nil {
                    
                    if selectedCategory!.companies!.contains(theCompany) { selectedCategory!.removeFromCompanies(theCompany) }
                  
                    selectedCategory = nil
                    theCompany.category = nil
                }
       
            } else {
                selectedCategory = categoryDictionary[categoryNames[row]] }
        }
    }
}

// MARK: - TEXT FIELD DELEGATE PROTOCOL
extension CompanyEditView:  UITextFieldDelegate {
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
    //    contentHeightConstraint.constant = 750
        theViewInfocus = textField
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == phoneTextField { phoneTextField.text = phoneTextField.text!.formattedPhone }
        return true
    }
}

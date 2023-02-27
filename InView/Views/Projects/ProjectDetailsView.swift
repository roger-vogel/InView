//
//  ProjectDetailView.swift
//  InView
//
//  Created by Roger Vogel on 10/7/22.
//

import UIKit
import AlertManager

class ProjectDetailsView: ParentView {

    // MARK: - STORYBOARD CONNECTORS

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var primaryStreetTextField: UITextField!
    @IBOutlet weak var subStreetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var marketTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var stageTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    
    @IBOutlet weak var contactsButton: UIButton!
    @IBOutlet weak var companiesButton: UIButton!
    @IBOutlet weak var activitiesButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var productsButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var documentsButton: UIButton!
    
    // MARK: - PROPERTIES
    var marketAreas = [String]()
    let startValues = ["Within 30 days","Within 60 days","Within 90 days","Within 120 days","Over 120 Days"]
    let statusValues = ["Open","In Progress","Delayed","Canceled","Closed"]
    let stageValues = ["Early Planning","Design","Sampling","Bidding","Construction","Complete"]

    var selectedProject: Project?
    var sortedDictionary = [String]()
    var theProject: Project?
    var toolbar = Toolbar()
    var companyPicker = UIPickerView()
    var marketPicker = UIPickerView()
    var statusPicker = UIPickerView()
    var startPicker = UIPickerView()
    var stagePicker = UIPickerView()
    
    var fromContact: Contact?
    var fromCompany: Company?
    var isNewProject: Bool?
    var isFromReports: Bool?
    var reportType: Int16?
    var isSaved: Bool?
    
    // MARK: -  COMPUTED PROPERTIES
    var startAsInt: Int64 { return 30 * (Int64(startPicker.selectedRow(inComponent: 0)) + 1) }

    var startAsString: String {
        
        switch theProject!.start {
          
            case 30: return "Within 30 Days"
            case 60: return "Within 60 Days"
            case 90: return "Within 90 Days"
            case 120: return "Within 120 Days"
            case 150: return "Over 120 Days"

            default: return ""
            
        }
    }
    
    var currentCompany: Company? {
        
        var theCompany: Company?
        
        for company in theProject!.companies! {
            
            theCompany = (company as! Company) // One company only for now
            break
        }
        
        return theCompany
    }
    
    var companyDictionary: [String:Company] {
        
        var theCompanies = [String: Company]()
 
        sortedDictionary.removeAll()
      
        for company in parentController!.contactController.coreData!.companies! {
            
            theCompanies[company.name!] = company
            sortedDictionary.append(company.name!)
        }
        
        sortedDictionary.insert("No Company Assigned", at: 0)
        return theCompanies
    }
    
    var hasActivities: Bool {
        
        if theProject!.activities != nil && theProject!.activities!.count > 0 { return true}
        return false
    }
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        stateTextField.delegate = self
        
        statusPicker.delegate = self
        statusPicker.dataSource = self
        startPicker.delegate = self
        startPicker.dataSource = self
        stagePicker.delegate = self
        stagePicker.dataSource = self
     
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
        
        statusTextField.inputView = statusPicker
        statusTextField.inputAccessoryView = toolbar
        statusTextField.rightView = UIImageView(image: UIImage(named: "button.up.down"))
        statusTextField.rightView!.contentMode = .scaleAspectFit
        statusTextField.translatesAutoresizingMaskIntoConstraints = false
        statusTextField.rightView!.widthAnchor.constraint(equalToConstant: 20).isActive = true
        statusTextField.rightView!.heightAnchor.constraint(equalToConstant: statusTextField.frame.height * 0.95).isActive = true
        statusTextField.rightViewMode = .always
        
        startTextField.inputView = startPicker
        startTextField.inputAccessoryView = toolbar
        startTextField.rightView = UIImageView(image: UIImage(named: "button.up.down"))
        startTextField.rightView!.contentMode = .scaleAspectFit
        startTextField.translatesAutoresizingMaskIntoConstraints = false
        startTextField.rightView!.widthAnchor.constraint(equalToConstant: 20).isActive = true
        startTextField.rightView!.heightAnchor.constraint(equalToConstant: startTextField.frame.height * 0.95).isActive = true
        startTextField.rightViewMode = .always
        
        stageTextField.inputView = stagePicker
        stageTextField.inputAccessoryView = toolbar
        stageTextField.rightView = UIImageView(image: UIImage(named: "button.up.down"))
        stageTextField.rightView!.contentMode = .scaleAspectFit
        stageTextField.translatesAutoresizingMaskIntoConstraints = false
        stageTextField.rightView!.widthAnchor.constraint(equalToConstant: 20).isActive = true
        stageTextField.rightView!.heightAnchor.constraint(equalToConstant: stageTextField.frame.height * 0.95).isActive = true
        stageTextField.rightViewMode = .always
        
        toolbar.setup(parent: self)
        postalCodeTextField.inputAccessoryView = toolbar
      
        super.initView(inController: inController)
    }
    
    // MARK: - METHODS
    func setProjectRecord(project: Project? = nil, fromContact: Contact? = nil, fromCompany: Company? = nil, isFromReport: Bool? = false, refreshOnly: Bool? = false) {
    
        self.isFromReports = isFromReport
       
        if project == nil && refreshOnly! { return }
        
        clear()
        
        self.fromContact = fromContact
        if fromContact != nil { thelastTab = Tabs.contacts }
       
        self.fromCompany = fromCompany
        if fromCompany != nil { thelastTab = Tabs.companies }
        
        if !refreshOnly! { theProject = project }
        
        if theProject == nil && !refreshOnly! {
            
            isSaved = false
            
            isNewProject = true
            
            theProject = Project(context: GlobalData.shared.viewContext)
            theProject!.id = UUID()
            theProject!.appId = UUID().description
            theProject!.timestamp = Date()
            
            setEditMode(true)
            
        } else if theProject != nil || isFromReport! {
   
            isNewProject = false
            isSaved = true
            
            projectNameTextField.text = theProject!.name!
            primaryStreetTextField.text = theProject!.primaryStreet == nil ? "" : theProject!.primaryStreet!
            subStreetTextField.text = theProject!.subStreet == nil ? "" : theProject!.subStreet!
            cityTextField.text = theProject!.city == nil ? "" : theProject!.city
            stateTextField.text = theProject!.state == nil ? "" : theProject!.state
            postalCodeTextField.text = theProject!.postalCode == nil ? "" : theProject!.postalCode
       
            marketTextField.text = theProject!.market == nil ? "" : theProject!.market!
            statusTextField.text = theProject!.status == nil ? "" : theProject!.status!
            stageTextField.text = theProject!.stage == nil ? "" : theProject!.stage!
            startTextField.text = startAsString
            
            setEditMode(false)
        }
        
        parentController!.contactController.coreData!.companies!.sort { $0.name! < $1.name!}
        
        _ = companyDictionary
        setupPickers()
        
       setActionButtonState()
    }
    
    func setActionButtonState() {
        
        // Save for later if necessary
    }
 
    func setEditMode(_ canEdit: Bool) {
        
        let fields = [projectNameTextField,primaryStreetTextField,subStreetTextField,cityTextField,stateTextField,postalCodeTextField,marketTextField,statusTextField,startTextField,stageTextField]
        
        // Set field state
        for field in fields {

            projectNameTextField.borderStyle = canEdit ? .roundedRect : .none
            
            field!.textColor = canEdit ? .label : .black
            field!.backgroundColor = canEdit ? .white : .clear
            field!.isEnabled = canEdit
        }
            
        // Set button state
        returnButton.isHidden = canEdit
        editButton.isHidden = canEdit
        saveButton.isHidden = !canEdit
        cancelButton.isHidden = !canEdit
        
    }
    
    func setupPickers() {
        
        marketAreas = parentController!.contactController.coreData!.marketAreasAsArray()
        marketAreas.insert("No Area Selected", at: 0)
        
        if isNewProject! {
            
            marketPicker.selectRow(0, inComponent: 0, animated: false)
            marketTextField.text = marketAreas.first!
            
            statusPicker.selectRow(0, inComponent: 0, animated: false)
            statusTextField.text = statusValues.first!
            
            startPicker.selectRow(0, inComponent: 0, animated: false)
            startTextField.text = startValues.first!
            
            stagePicker.selectRow(0, inComponent: 0, animated: false)
            stageTextField.text = stageValues.first!
            
        } else {
            
            marketPicker.setRow(forKey: theProject!.market!, inData: marketAreas)
            statusPicker.setRow(forKey: theProject!.status!, inData: statusValues)
            startPicker.setRow(forKey: startAsString, inData: startValues)
            stagePicker.setRow(forKey: theProject!.stage!, inData: stageValues)
        }
    }
 
    func clear(){
        
        thelastTab = nil
        
        projectNameTextField.text!.removeAll()
        primaryStreetTextField.text!.removeAll()
        subStreetTextField.text!.removeAll()
        cityTextField.text!.removeAll()
        stateTextField.text!.removeAll()
        postalCodeTextField.text!.removeAll()
        
        marketTextField.text!.removeAll()
        statusTextField.text!.removeAll()
        startTextField.text!.removeAll()
        stageTextField.text!.removeAll()
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onPrimaryAction(_ sender: Any) { dismissKeyboard() }
    
    @IBAction func onMap(_ sender: Any) {
        
        LaunchManager(parent: parentController!).launchMaps(project: theProject!)
    }
    
    @IBAction func onContacts(_ sender: Any) {
        
        parentController!.projectController.projectTeamView.setProjectRecord(project: theProject!)
        parentController!.projectController.projectTeamView.showView(withTabBar: false)
    }
    
    @IBAction func onCompanies(_ sender: Any) {
        
        parentController!.projectController.projectCompanyView.setProjectRecord(project: theProject!)
        parentController!.projectController.projectCompanyView.showView(withTabBar: false)
    }
    
    @IBAction func onActivities(_ sender: Any) {
       
        let activityList = parentController!.projectController.projectActivityListView
        
        activityList!.clear()
        activityList!.setProject(theProject)
        activityList!.showView(withTabBar: false)
    }
    
    @IBAction func onLogs(_ sender: Any) {
        
        parentController!.projectController.projectLogListView.setProjectRecord(project: theProject!)
        parentController!.projectController.projectLogListView.showView(withTabBar: false)
    }
    
    @IBAction func onProducts(_ sender: Any) {
        
        parentController!.projectController.projectProductListView.setProjectRecord(project: theProject!)
        parentController!.projectController.projectProductListView.showView(withTabBar: false)
    }
    
    @IBAction func onCamera(_ sender: Any) {
        
        parentController!.projectController.projectPhotoView.setProjectRecord(project: theProject!)
        parentController!.projectController.projectPhotoView.showView(withTabBar: false)
    }
    
    @IBAction func onDocuments(_ sender: Any) {
        
        parentController!.projectController.projectDocumentView.setProjectRecord(project: theProject!)
        parentController!.projectController.projectDocumentView.showView(withTabBar: false)
    }
    
    @IBAction func onEdit(_ sender: Any) { setEditMode(true) }

    @IBAction func onSave(_ sender: UIButton) {
        
        guard sender != cancelButton else {
            
            if theProject == nil { parentController!.projectController.projectListView.showView(atCompletion: { self.setEditMode(false) }) }
            else { self.setEditMode(false)  }
            
            onReturn(self)
            
            return
        }
        
        guard !projectNameTextField.text!.isEmpty else {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupOK(aTitle: "Incomplete Profile", aMessage: "To create a project, you must at least assign a name")
            return
        }
        
        guard States.isValidState(theState: stateTextField.text!) else {
            
            dismissKeyboard()
          
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButton(aTitle: "Invalid State/Province", aMessage: "Please enter a valid 2 letter state or province abbreviation", buttonTitle: "OK", theStyle: .default, theType: .alert) {
                
                self.stateTextField.becomeFirstResponder()
            }
          
            return
        }
        
        isSaved = true
        
        theProject!.name = projectNameTextField.text!
        theProject!.primaryStreet = primaryStreetTextField.text!
        theProject!.subStreet = subStreetTextField.text!
        theProject!.city = cityTextField.text!
        theProject!.state = stateTextField.text!
        theProject!.postalCode = postalCodeTextField.text!
        theProject!.market = marketTextField.text!
        theProject!.stage = stageTextField.text!
        theProject!.start = startAsInt
        theProject!.status = statusTextField.text!
        
        if theProject!.stage!.lowercased() == "complete" || theProject!.status!.lowercased() == "closed" {
            
            if theProject!.completionDate == nil { theProject!.completionDate = Date() }
            
        } else { theProject!.completionDate = nil }
        
        if fromContact != nil { theProject!.addToTeam(fromContact!) }
        if fromCompany != nil { theProject!.addToCompanies(fromCompany!) }
        if isNewProject! { parentController!.contactController.coreData!.projects!.append(theProject!) }

        GlobalData.shared.saveCoreData()
        setEditMode(false)
        
        onReturn(self)
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        if !isSaved! && theProject != nil { GlobalData.shared.viewContext.delete(theProject!) }
        
        if isFromReports != nil {
            
            if isFromReports! {
                
                if reportType == ReportTypes.funnelbyProject { parentController!.projectController.reportsFunnelProjectView.showView(withTabBar: false, atCompletion: { self.clear() }) }
                else if reportType == ReportTypes.funnelbyCompletedProjects { parentController!.projectController.reportsCompletedProjectView.showView(withTabBar: false, atCompletion: { self.clear() }) }
                else { parentController!.projectController.projectListView.showView(atCompletion: { self.clear() }) }
                
                return
            }
        }
    
        guard thelastTab != nil else {
            
            parentController!.projectController.projectListView.showView(withTabBar: true)
            return
        }
        
        switch thelastTab {
            
            case Tabs.contacts:
            
                parentController!.contactController.launchPrimaryView = false
                parentController!.contactController.contactProjectListView.setContact()
                parentController!.contactController.contactProjectListView.projectTableView.reloadData()
                parentController!.gotoTab(Tabs.contacts, showingView: parentController!.contactController.contactProjectListView, withTabBar: false)
            
            case Tabs.companies:
            
                parentController!.companyController.launchPrimaryView = false
                parentController!.companyController.companyProjectListView.setCompany()
                parentController!.companyController.companyProjectListView.projectTableView.reloadData()
                parentController!.gotoTab(Tabs.companies, showingView: parentController!.companyController.companyProjectListView, withTabBar: false)
            
            default: break
        }
    }
}

extension ProjectDetailsView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { return true }
 
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
       
        guard textField.text!.count <= 2 else {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButton(aTitle: "Invalid State", aMessage: "Please enter a valid 2 letter state abbreviation", buttonTitle: "OK", theStyle: .default, theType: .alert) {
                
                self.stateTextField.becomeFirstResponder()
            }
            
            return false
        }
        
        return true
    }
}

// MARK: -  PICKER PROTOCOL
extension ProjectDetailsView: UIPickerViewDelegate, UIPickerViewDataSource {
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView,  rowHeightForComponent component: Int) -> CGFloat { return 30 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
            
            case marketPicker: return marketAreas.count
            case startPicker: return startValues.count
            case statusPicker: return statusValues.count
            case stagePicker: return stageValues.count
            case companyPicker: return sortedDictionary.count
        
            default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
            
            case marketPicker: return marketAreas[row]
            case startPicker: return startValues[row]
            case statusPicker: return statusValues[row]
            case stagePicker: return stageValues[row]
            
            default: return ""
        }
    }
   
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
            
            case marketPicker:
                marketTextField.text = marketAreas[row]
            
            case startPicker:
                startTextField.text = startValues[row]
            
            case statusPicker:
                statusTextField.text = statusValues[row]
            
            case stagePicker:
                stageTextField.text = stageValues[row]
            if stageValues[row].lowercased() == "complete" || statusValues[row].lowercased() == "closed" { theProject!.completionDate = Date() }
                else { theProject!.completionDate = nil }
            
            default: break
        }
    }
}

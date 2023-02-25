//
//  SelectionView.swift
//  InView
//
//  Created by Roger Vogel on 10/9/22.
//

import UIKit

class ParentSelectionView: ParentView, SelectorTableCellDelegate  {

    var theTitleLabel: UILabel?
    var theSelectorTableView: UITableView?
    var theRecordCountLabel: UILabel?
    var theSearchTextField: UITextField?
    
    // MARK: - PROPERTIES
    var activityType: ActivityType?
    var theCompany: Company?
    var theContact: Contact?
    var theGroup: Group?
    var theActivity: Activity?
    var theProject: Project?
   
    var theSelectedContacts: [Contact]?
    var theSelectedCompanies: [Company]?
    var theSelectedProjects: [Project]?
   
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
     
        theSelectorTableView!.delegate = self
        theSelectorTableView!.dataSource = self
        
        theSelectorTableView!.sectionHeaderTopPadding = 10
        theSelectorTableView!.sectionIndexMinimumDisplayRowCount = 15
        theSelectorTableView!.separatorColor = ThemeColors.aqua.uicolor
        
        super.initView(inController: inController)
    }
    
    override func refresh() { theSelectorTableView!.reloadData() }
   
    // MARK: - METHODS
    func loadView(companies: [Company]? = nil, projects: [Project]? = nil, contacts: [Contact]? = nil, activityType: ActivityType? = .task) {
        
        self.activityType = activityType
        theSelectedCompanies = companies
        theSelectedProjects = projects
        theSelectedContacts = contacts
        setRecordCount()
        
        theSelectorTableView!.reloadData()
    }
    
    func setRecordCount() {
        
        if theSelectedContacts != nil {
            
            let description = theSelectedContacts!.count == 1 ? "Person Selected" : "People Selected"
            theRecordCountLabel!.text = String(format: "%d " + description, theSelectedContacts!.count )
            
        } else if theSelectedCompanies != nil {
            
            let description = theSelectedCompanies!.count == 1 ? "Company Selected" : "Companies Selected"
            theRecordCountLabel!.text = String(format: "%d " + description, theSelectedCompanies!.count )
            
        } else {
            
            let description = theSelectedProjects!.count == 1 ? "Project Selected" : "Projects Selected"
            theRecordCountLabel!.text = String(format: "%d " + description, theSelectedProjects!.count )
        }
    }
    
    // MARK: - SELECTOR TABLE CELL DELEGATE PROTOCOL
    func contactWasSelected(contact: Contact) { /* Placeholder for subview */ }
    func contactWasDeselected(contact: Contact) { /* Placeholder for subview */ }
    
    func companyWasSelected(company: Company) { /* Placeholder for subview */ }
    func companyWasDeselected(company: Company) { /* Placeholder for subview */ }
    
    func projectWasSelected(project: Project) { /* Placeholder for subview */ }
    func projectWasDeselected(project: Project) { /* Placeholder for subview */ }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ParentSelectionView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
         
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if theSelectedContacts != nil { return parentController!.contactController.coreData!.contacts!.count }
        else if theSelectedCompanies != nil { return parentController!.contactController.coreData!.companies!.count }
        else if theSelectedProjects != nil { return parentController!.contactController.coreData!.projects!.count}
        else { return 0 }
    }
    
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 80 }
   
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if theSelectedContacts != nil {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactSelectorListStyle", for: indexPath) as! ContactSelectorListCell
            let contact = parentController!.contactController.coreData!.contacts![indexPath.row]
            
            cell.delegate = self
            cell.initToggle()
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = ThemeColors.beige.uicolor
            cell.selectedBackgroundView = backgroundView
                    
            if contact.hasPhoto { cell.photoImageView.image = UIImage(data: Data(base64Encoded: contact.photo!)!)}
            else { cell.photoImageView.image = GlobalData.shared.contactNoPhoto }
            
            cell.nameLabel.text = contact.firstName! + " " + contact.lastName!
            cell.titleLabel.text = contact.title! == "" ? "No title entered" : contact.title!
            cell.theContact = contact
            
            if theSelectedContacts!.contains(contact) {
                
                cell.contactIsSelected = true
                cell.checkBoxButton.setState(true)
                
            } else {
            
                cell.contactIsSelected = false
                cell.checkBoxButton.setState(false)
            }
            
            return cell
            
        } else if theSelectedCompanies != nil {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "companySelectorListStyle", for: indexPath) as! CompanySelectorListCell
            let company = parentController!.contactController.coreData!.companies![indexPath.row]
            
            cell.delegate = self
            cell.initToggle()
            
            let backgroundView = UIView()
     
            backgroundView.backgroundColor = ThemeColors.beige.uicolor
            cell.selectedBackgroundView = backgroundView
            
            cell.companyNameLabel.text = company.name!
            
            if company.city! == "" {cell.companyAddressLabel.text = "No Address Entered" }
            else if company.state! == "" { cell.companyAddressLabel.text = company.city! }
            else { cell.companyAddressLabel.text = company.city! + ", " + company.state! }
          
            cell.theCompany = company
            
            if theSelectedCompanies!.contains(company) {
                
                cell.companyIsSelected = true
                cell.checkBoxButton.setState(true)
                
            } else {
            
                cell.companyIsSelected = false
                cell.checkBoxButton.setState(false)
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectSelectorListStyle", for: indexPath) as! ProjectSelectorListCell
            let project = parentController!.contactController.coreData!.projects![indexPath.row]
            
            cell.delegate = self
            cell.initToggle()
            
            let backgroundView = UIView()
     
            backgroundView.backgroundColor = ThemeColors.beige.uicolor
            cell.selectedBackgroundView = backgroundView
            
            cell.projectNameLabel.text = project.name!
            cell.theProject = project
            
            if theSelectedProjects!.contains(project) {
                
                cell.projectIsSelected = true
                cell.checkBoxButton.setState(true)
                
            } else {
            
                cell.projectIsSelected = false
                cell.checkBoxButton.setState(false)
            }
            
            return cell
        }
    }
}

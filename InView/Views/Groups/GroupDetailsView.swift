//
//  GroupDetailsView.swift
//  InView
//
//  Created by Roger Vogel on 10/5/22.
//

import UIKit

class GroupDetailsView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
   
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var memberTypeSelector: UISegmentedControl!
    
    var thePeopleMembers = [Contact]()
    var theCompanyMembers = [Company]()
    
    var theGroup: Group?
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        super.initView(inController: inController)
     
        membersTableView.delegate = self
        membersTableView.dataSource = self
        
        membersTableView.sectionHeaderTopPadding = 10
        membersTableView.sectionIndexMinimumDisplayRowCount = 15
        membersTableView.separatorColor = ThemeColors.aqua.uicolor

    }
    
    // MARK: - METHODS
    func setGroupRecord(group: Group? = nil) {
        
        if group != nil { theGroup = group! }
        
        groupNameTextField.text = theGroup!.name
        reloadMemberTable()
    }
    
    func reloadMemberTable() {
    
        thePeopleMembers.removeAll()
        theCompanyMembers.removeAll()
        
        for people in theGroup!.peopleMembers! { thePeopleMembers.append(people as! Contact) }
        for company in theGroup!.companyMembers! { theCompanyMembers.append(company as! Company) }
    
        thePeopleMembers.sort { $0.lastName! < $1.lastName! }
        theCompanyMembers.sort { $0.name! <  $1.name! }
       
        membersTableView.reloadData()
        
        messageButton.isEnabled = !thePeopleMembers.isEmpty
        emailButton.isEnabled = !thePeopleMembers.isEmpty
        
        let description = theGroup!.peopleMembers!.count == 1 ? "Member" : "Members"
        recordCountLabel.text = String(format: "%d " + description, theGroup!.peopleMembers!.count )
    }
      
    // MARK: ACTION HANDLERS
    @IBAction func onPrimaryAction(_ sender: Any) { dismissKeyboard() }
    
    @IBAction func onMemberType(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            messageButton.isEnabled = true
            messageButton.alpha = 1.0
            
            emailButton.isEnabled = true
            emailButton.alpha = 1.0
            
        } else {
            
            messageButton.isEnabled = false
            messageButton.alpha = 0.50
            
            emailButton.isEnabled = false
            emailButton.alpha = 0.50
        }
       
        reloadMemberTable()
        
    }
 
    @IBAction func onPlusMinus(_ sender: Any) {
        
        parentController!.groupController.memberSelectionView.theGroup = theGroup!
        
        if memberTypeSelector.selectedSegmentIndex == 0 { parentController!.groupController.memberSelectionView.loadView(contacts: thePeopleMembers) }
        else { parentController!.groupController.memberSelectionView.loadView(companies: theCompanyMembers) }
       
        parentController!.groupController.memberSelectionView.showView(withTabBar: false)
    }

    @IBAction func onMessage(_ sender: Any) { LaunchManager(parent: parentController!).messageContacts(contacts: thePeopleMembers) }
    
    @IBAction func onEmail(_ sender: Any) { LaunchManager(parent: parentController!).emailContacts(contacts: thePeopleMembers) }
     
    @IBAction func onReturn(_ sender: Any) {
        
        theGroup!.name = groupNameTextField.text!
        
        GlobalData.shared.saveCoreData()
        parentController!.groupController.groupListView.refresh()
        parentController!.groupController.groupListView.showView(withSetup: false)
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension GroupDetailsView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
  
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if memberTypeSelector.selectedSegmentIndex == 0 { return thePeopleMembers.count }
        else { return theCompanyMembers.count }
    }
        
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 70 }
   
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if memberTypeSelector.selectedSegmentIndex == 0 {
           
            let contact = thePeopleMembers[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupDetailsListStyle", for: indexPath) as! GroupDetailsListCell
         
            if contact.hasPhoto { cell.memberImageView.image = UIImage(data: Data(base64Encoded: contact.photo!)!)}
            else { cell.memberImageView.image = GlobalData.shared.companyNoPhoto }
            
            cell.labelFieldOne.text = contact.firstName! + " " + contact.lastName!
            cell.labelFieldTwo.text = contact.title!.isEmpty ? "No Title Entered" : contact.title!
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
          
            return cell
            
        } else {
            
            let company = theCompanyMembers[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupDetailsListStyle", for: indexPath) as! GroupDetailsListCell
          
            if company.hasPhoto { cell.memberImageView.image = UIImage(data: Data(base64Encoded: company.photo!)!)}
            else { cell.memberImageView.image = GlobalData.shared.companyNoPhoto }
            
            cell.labelFieldOne.text = company.name!
            
            if company.city!.isEmpty {
               
                cell.labelFieldTwo.text = "No Address Entered"
                
            } else {
            
                cell.labelFieldTwo.text  = company.city!
                if !company.state!.isEmpty { cell.labelFieldTwo.text! += (", " + company.state!) }
            }
      
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
          
            return cell
        }
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if memberTypeSelector.selectedSegmentIndex == 0 {
            
            let contactDetails = parentController!.contactController.contactDetailsView!
            
            if contactDetails.parentController == nil { contactDetails.initView(inController: parentController!.contactController) }
       
            parentController!.contactController.launchPrimaryView = false
            contactDetails.thelastTab = Tabs.groups
            contactDetails.setContactRecord(contact: thePeopleMembers[indexPath.row])
            
            parentController!.gotoTab(Tabs.contacts, showingView: contactDetails, withTabBar: false)
            
        } else {
            
            let companyDetails = parentController!.companyController.companyDetailsView!
            
            if companyDetails.parentController == nil { companyDetails.initView(inController: parentController!.companyController) }
       
            parentController!.companyController.launchPrimaryView = false
            companyDetails.thelastTab = Tabs.groups
            companyDetails.setCompanyRecord(company: theCompanyMembers[indexPath.row])
            
            parentController!.gotoTab(Tabs.companies, showingView: companyDetails, withTabBar: false)
        }
    }
}

//
//  ContactListView.swift
//  InView
//
//  Created by Roger Vogel on 9/23/22.
//

import UIKit
import AlertManager

class ContactListView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var addContactButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var editModeButton: UIButton!
    
    // MARK: - PROPERTIES
    var sectionTitles = [ContactSectionTitle]()
    var searchContacts = [Contact]()
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        super.initView(inController: inController)
     
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        contactsTableView.sectionHeaderTopPadding = 0
        contactsTableView.sectionIndexMinimumDisplayRowCount = 15
        contactsTableView.separatorStyle = .none
        
        theMenuButton = menuButton
    }
    
    override func setupView() {
        
        sectionTitles.removeAll()
        searchContacts.removeAll()
        
        if !parentController!.contactController.coreData!.contacts!.isEmpty {
            
            if searchTextField.text!.isEmpty {
                
                if GlobalData.shared.peopleSort == .last {
                    
                    for title in GlobalData.shared.indexTitles {
                        
                        let contacts = parentController!.contactController.coreData!.contacts!.filter { $0.lastName != nil && $0.lastName != "" && $0.lastName != "No Last Name" && String($0.lastName!.first!).uppercased() == title }
                    
                        if contacts.count > 0 {
                            
                            sectionTitles.append(ContactSectionTitle(title: title, theContacts: contacts))
                        }
                    }
                    
                    // Check for blanks
                    var blankContacts = [Contact]()
                    
                    for contact in parentController!.contactController.coreData!.contacts! {
                        
                        if contact.lastName! == "" {
                            
                            if contact.firstName! == "" { contact.lastName = "No Last Name" }
                            blankContacts.append(contact)
                        }
                    }
                    
                    if !blankContacts.isEmpty {
                        
                        sectionTitles.append(ContactSectionTitle(title: "No Last Name", theContacts: blankContacts))
                    }
                    
                } else {
                    
                    for title in GlobalData.shared.indexTitles {
                        
                        let contacts = parentController!.contactController.coreData!.contacts!.filter { $0.firstName != nil && $0.firstName != "" && $0.firstName != "No First Name" && String($0.firstName!.first!).uppercased() == title }
                    
                        if contacts.count > 0 {
                            
                            sectionTitles.append(ContactSectionTitle(title: title, theContacts: contacts))
                        }
                    }
                    
                    // Check for blanks
                    var blankContacts = [Contact]()
                    
                    for contact in parentController!.contactController.coreData!.contacts! {
                        
                        if contact.firstName! == "" {
                            
                            if contact.lastName! == "" { contact.lastName = "No First Name" }
                            blankContacts.append(contact)
                        }
                    }
                    
                    if !blankContacts.isEmpty {
                        
                        sectionTitles.append(ContactSectionTitle(title: "No First Name", theContacts: blankContacts))
                    }
                }
                
            } else {
          
                searchContacts = parentController!.contactController.coreData!.contacts!.filter { ($0.firstName! + $0.lastName!).uppercased().contains(searchTextField.text!.uppercased())}
            }

        } else {
            
            if contactsTableView.isEditing { onEditMode(editModeButton) }
        }
        
        for contacts in sectionTitles { contacts.sortSectionItems() }
        contactsTableView.reloadData()
      
        if searchTextField.text!.isEmpty {
           
            let description = parentController!.contactController.coreData!.contacts!.count == 1 ? "Person" : "People"
            recordCountLabel.text = String(format: "%d " + description, parentController!.contactController.coreData!.contacts!.count )
        }
        
        else {
            
            let description = searchContacts.count == 1 ? "Person" : "People"
            recordCountLabel.text = String(format: "%d " + description, searchContacts.count )
        }
    }
    
    override func refresh() { setupView() }
    
    // MARK: ACTION HANDLERS
    @IBAction func onSearchPrimaryAction(_ sender: Any) { dismissKeyboard() }
    
    @IBAction func onEditChange(_ sender: Any) { setupView() }
    
    @IBAction func onEditMode(_ sender: UIButton) {
        
        contactsTableView.isEditing = !contactsTableView.isEditing
        
        let buttonImage = contactsTableView.isEditing ? UIImage(systemName: "pencil.circle.fill") : UIImage(systemName: "pencil.circle")
        sender.setImage(buttonImage, for: .normal)
    }
    
    @IBAction func onPlus(_ sender: Any) {
    
        parentController!.contactController.contactEditView.setContactRecord(newContact: true)
        parentController!.contactController.contactEditView.showView(withTabBar: false)
    }
    
    @IBAction func onMenu(_ sender: Any) {
  
        menuButton.isHidden = true
        
        initMenu()
        theMenuView!.showMenu()
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ContactListView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if searchTextField.text!.isEmpty { return sectionTitles.count }
        return 1
    }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard !sectionTitles.isEmpty else { return searchContacts.count }
        
        if searchTextField.text!.isEmpty { return sectionTitles[section].contacts.count }
        return searchContacts.count
    }
  
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 70 }
    
    // View for headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard !sectionTitles.isEmpty else { return nil }
        
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 120))
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width-25, height: 28))
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 6.5, width: tableView.frame.size.width, height: 15))
        
        sectionHeaderView.addSubview(headerLabel)
        sectionHeaderView.backgroundColor = .clear
        
        sectionHeaderView.addSubview(backgroundView)
        backgroundView.backgroundColor = ThemeColors.brown.uicolor
        backgroundView.roundAllCorners(value: 5)
     
        sectionHeaderView.addSubview(headerLabel)
        headerLabel.textColor = ThemeColors.aqua.uicolor
        headerLabel.backgroundColor = .clear
        headerLabel.font = UIFont.systemFont(ofSize: 13)
        headerLabel.text = sectionTitles[section].indexTitle
        
        return sectionHeaderView
    }
    
    // Provide section index titles
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        guard !sectionTitles.isEmpty else { return nil }
      
        var indexTitles = [String]()
        for title in sectionTitles {
            
            if title.indexTitle!.count > 1 { indexTitles.append("    NN") }
            else { indexTitles.append("     " + title.indexTitle!) }
        }
        
        return indexTitles
    }

    // Provide section index for a given title
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int { return index }
      
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        var contact: Contact?
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactListStyle", for: indexPath) as! ContactListCell
    
        if searchTextField.text!.isEmpty { contact = sectionTitles[indexPath.section].contacts[indexPath.row] }
        else { contact = searchContacts[indexPath.row] }
        
        if contact!.hasPhoto { cell.contactImageView.image = UIImage(data: Data(base64Encoded: contact!.photo!)!)}
        else { cell.contactImageView.image = GlobalData.shared.contactNoPhoto }
        
        cell.contactNameLabel.text = contact!.firstName! + " " + contact!.lastName!
        
        if searchTextField.text!.isEmpty {
            
            if (indexPath.row == sectionTitles[indexPath.section].contacts.count-1) && (indexPath.section != sectionTitles.count-1) { cell.dividerLabel.isHidden = true }
            else { cell.dividerLabel.isHidden = false }
        }

        return cell
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact = searchTextField.text!.isEmpty ? sectionTitles[indexPath.section].contacts[indexPath.row] : searchContacts[indexPath.row]
        
        parentController!.contactController.contactDetailsView.setContactRecord(contact: contact)
        parentController!.contactController.contactDetailsView.showView(withTabBar: false)
    }
    
    // Allow row move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return false }
    
    // Allows editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Delete contact
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let contact = parentController!.contactController.coreData!.contacts![indexPath.row]
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Delete Contact", aMessage: "Are you sure you want to delete " + contact.firstName! + " " + contact.lastName! + "?", buttonTitles: ["CANCEL","DELETE"], theStyle: [.cancel,.destructive], theType: .actionSheet) { choice in
                
                if choice == 1 {
                    
                    let contact = self.sectionTitles[indexPath.section].contacts[indexPath.row]
                    let index = self.parentController!.contactController.coreData!.contactIndex(contact: contact)
                    
                    guard index != nil else { return }
                    self.parentController!.contactController.coreData!.contacts!.remove(at: index!)
                    
                    GlobalData.shared.viewContext.delete(contact)
                    GlobalData.shared.saveCoreData()
                    
                    if self.parentController!.contactController.coreData!.contacts!.isEmpty && self.contactsTableView.isEditing { self.onEditMode(self.editModeButton) }
                    self.setupView()
                }
            }
        }
    }
}

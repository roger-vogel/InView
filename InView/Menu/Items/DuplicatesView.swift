//
//  DuplicatesView.swift
//  InView
//
//  Created by Roger Vogel on 11/19/22.
//

import UIKit

class DuplicatesView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var duplicatesTableView: UITableView!
    
    // MARK: - PROPERTIES
    var theMenuViewController: MenuViewController?
    var workspace = [DuplicateContact]()
    var duplicateContactGroups = [DuplicateContactGroup]()
    weak var delegate: DuplicatesViewDelegate?

    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        duplicatesTableView.delegate = self
        duplicatesTableView.dataSource = self
        
        super.initView(inController: inController)
    }
    
    override func setupView() {
    
        // Initialize contact collections
        workspace.removeAll()
        duplicateContactGroups.removeAll()
        
        // Copy all contacts into the working space
        for contact in parentController!.contactController.coreData!.contacts! {
            
            workspace.append(DuplicateContact(theContact: contact, delete: false))
        }
        
        // Init an indexer for the workspace collection
        var workspaceIndex: Int = 0
       
        // Build groups of duplicate contacts
        while workspaceIndex < workspace.count {
             
            let duplicateIndices = findDuplicates(forContact: workspace[workspaceIndex].contact!)
        
            if duplicateIndices.count > 1 {
                
                // Create a collection of duplicate contacts and flag that each item has been processed
                var theContacts = [Contact]()
                for theIndex in duplicateIndices {
                    
                    theContacts.append(workspace[theIndex].contact!)
                    workspace[theIndex].flaggedToDelete = true
                }
              
                // Add the group of duplicate contacts to our list of groups
                duplicateContactGroups.append(DuplicateContactGroup(withContacts: theContacts))
                
                // Shrink workspace by removing the flagged contacts and prepare for next pass
                while !(workspace.filter {$0.flaggedToDelete == true }).isEmpty {
                    
                    for (index,value) in workspace.enumerated() {
                        
                        if value.flaggedToDelete! {
                            
                            workspace.remove(at: index)
                            break
                        }
                    }
                }
               
                workspaceIndex = 0
                
            } else { workspaceIndex += 1 }
        }
        
        duplicatesTableView.reloadData()
    }
    
    // MARK: - METHODS
    func findDuplicates(forContact: Contact) -> [Int] {
        
        var duplicates = [Int]()
        
        guard workspace.count > 1 else { return duplicates }
        
        let dupString = forContact.firstName! + forContact.lastName!
        
        for (index,_) in workspace.enumerated() {
            
            if (workspace[index].contact!.firstName! + workspace[index].contact!.lastName!) == dupString { duplicates.append(index) }
        }
        
        return duplicates
    }
 
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        delegate!.dismissMenuView()
        GlobalData.shared.activeController!.tabBarController!.tabBar.isHidden = false
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension DuplicatesView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return duplicateContactGroups.count }
  
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 80 }
    
    // Row highlight?
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "duplicateListStyle", for: indexPath) as! DuplicateListCell
        let theContact = duplicateContactGroups[indexPath.row].contacts!.first!
      
        cell.contactNameLabel.text = theContact.firstName! + " " + theContact.lastName!
        cell.duplicatesLabel.text = String(format: "%d records found", duplicateContactGroups[indexPath.row].contacts!.count)
        cell.cellContact = theContact
        
        return cell
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        let theDuplicateGroup = duplicateContactGroups[indexPath.row].contacts!
    
        GlobalData.shared.menuController!.duplicateDetailsView.setDuplicateGroup(duplicateGroup: theDuplicateGroup)
        GlobalData.shared.menuController!.duplicateDetailsView.showView(withTabBar: false)
    }
    
    // Allows editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
       
    }
}

// MARK: - DUPLICATE CONTACT STRUCTURES
extension DuplicatesView {
  
    struct DuplicateContact {
        
        var contact: Contact?
        var flaggedToDelete: Bool?
        
        init(theContact: Contact? = Contact(), delete: Bool? = false) {
            
            contact = theContact!
            flaggedToDelete = delete!
        }
    }

    struct DuplicateContactGroup {
        
        var contacts: [Contact]?
        init (withContacts: [Contact]? = [Contact]()) { contacts = withContacts! }
    }
}

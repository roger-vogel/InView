//
//  DuplicateDetailsView.swift
//  InView
//
//  Created by Roger Vogel on 11/19/22.
//

import UIKit
import AlertManager

class DuplicateDetailsView: ParentView {
 
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var mergeTableView: UITableView!
    @IBOutlet weak var mergeButton: UIButton!
    
    // MARK: - PROPERTIES
    var mergeTargetIndex: IndexPath?
    var deletedIndices = [Int]()
    var theDuplicateGroup: [Contact]?
    weak var delegate: DuplicateDetailsViewDelegate?
        
    // MARK: - METHODS
    func setDuplicateGroup(duplicateGroup: [Contact]) {
        
        deletedIndices.removeAll()
        
        mergeTableView.delegate = self
        mergeTableView.dataSource = self
        
        theDuplicateGroup = duplicateGroup
        mergeTableView.reloadData()
    }
  
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        mergeTargetIndex = nil
        hideView()
    }
  
    @IBAction func onMerge(_ sender: Any) {
        
        for (index,value) in theDuplicateGroup!.enumerated() {
            
            // This algorithm will merge the first found field, if any, into the corresponding missing field in the target record
            if index != mergeTargetIndex!.row {
                
                if theDuplicateGroup![mergeTargetIndex!.row].title == "" { theDuplicateGroup![mergeTargetIndex!.row].title = value.title }
                if theDuplicateGroup![mergeTargetIndex!.row].company == nil { theDuplicateGroup![mergeTargetIndex!.row].company = value.company }
                if theDuplicateGroup![mergeTargetIndex!.row].primaryStreet == "" { theDuplicateGroup![mergeTargetIndex!.row].primaryStreet! = value.primaryStreet! }
                if theDuplicateGroup![mergeTargetIndex!.row].subStreet == "" { theDuplicateGroup![mergeTargetIndex!.row].subStreet! = value.subStreet! }
                if theDuplicateGroup![mergeTargetIndex!.row].city == "" { theDuplicateGroup![mergeTargetIndex!.row].city! = value.city! }
                if theDuplicateGroup![mergeTargetIndex!.row].state == "" { theDuplicateGroup![mergeTargetIndex!.row].state! = value.state! }
                if theDuplicateGroup![mergeTargetIndex!.row].postalCode == "" { theDuplicateGroup![mergeTargetIndex!.row].postalCode! = value.postalCode! }
                if theDuplicateGroup![mergeTargetIndex!.row].mobilePhone == "" { theDuplicateGroup![mergeTargetIndex!.row].mobilePhone! = value.mobilePhone! }
                if theDuplicateGroup![mergeTargetIndex!.row].homePhone == "" { theDuplicateGroup![mergeTargetIndex!.row].homePhone! = value.homePhone! }
                if theDuplicateGroup![mergeTargetIndex!.row].workPhone == "" { theDuplicateGroup![mergeTargetIndex!.row].workPhone! = value.workPhone! }
                if theDuplicateGroup![mergeTargetIndex!.row].customPhone == "" { theDuplicateGroup![mergeTargetIndex!.row].customPhone! = value.customPhone! }
                if theDuplicateGroup![mergeTargetIndex!.row].personalEmail == "" { theDuplicateGroup![mergeTargetIndex!.row].personalEmail! = value.personalEmail! }
                if theDuplicateGroup![mergeTargetIndex!.row].workEmail == "" { theDuplicateGroup![mergeTargetIndex!.row].workEmail! = value.workEmail! }
                if theDuplicateGroup![mergeTargetIndex!.row].otherEmail == "" { theDuplicateGroup![mergeTargetIndex!.row].otherEmail! = value.otherEmail! }
                if theDuplicateGroup![mergeTargetIndex!.row].customEmail == "" { theDuplicateGroup![mergeTargetIndex!.row].customEmail! = value.customEmail! }
                
                if !theDuplicateGroup![mergeTargetIndex!.row].hasPhoto && value.hasPhoto {
                    
                    theDuplicateGroup![mergeTargetIndex!.row].hasPhoto = true
                    theDuplicateGroup![mergeTargetIndex!.row].photo = value.photo!
                }
            }
        }
        
        // Delete all the records accept the merge target
        for index in 0..<theDuplicateGroup!.count {
            
            if index != mergeTargetIndex!.row {
                
                GlobalData.shared.viewContext.delete(theDuplicateGroup![index])
                
                let coreDataIndex = parentController!.contactController.coreData!.contactIndex(contact: theDuplicateGroup![index])
                parentController!.contactController.coreData!.contacts?.remove(at: coreDataIndex!)
            }
        }
        
        // Clear duplicates group
        let mergedContact = theDuplicateGroup![mergeTargetIndex!.row]
        theDuplicateGroup!.removeAll()
        theDuplicateGroup!.append(mergedContact)
        
        // Save core data
        GlobalData.shared.saveCoreData()
      
        // Reload the duplicate table
        mergeTargetIndex = nil
        mergeTableView.reloadData()
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension DuplicateDetailsView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return theDuplicateGroup!.count }
        
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 300 }
    
    // Row highlight?
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return false }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "duplicateDetailsListStyle", for: indexPath) as! DuplicateDetailsCell
   
        cell.setContact(withContact: theDuplicateGroup![indexPath.row])
        cell.myIndexPath = indexPath
        cell.delegate = self
        
        if mergeTargetIndex != nil {
            
            if mergeTargetIndex == indexPath { cell.checkButton.setState(true) }
            else { cell.checkButton.setState(false) }
            
        } else {
            
            cell.checkButton.setState(false)
            if theDuplicateGroup!.count == 1 {
                
                cell.checkButton.isEnabled = false
                cell.mergeLabel.isEnabled = false
                cell.mergeLabel.alpha = 0.50
                mergeButton.isEnabled = false
            }
        }
      
        return cell
    }
    
    // Allows editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            AlertManager(controller: GlobalData.shared.menuController!).popupWithCustomButtons(buttonTitles: ["OK","CANCEL"], theStyle: [.default,.cancel]) { choice in
                
                if choice == 0 {
                    
                    let contact = self.theDuplicateGroup![indexPath.row]
                    
                    for (index,value) in GlobalData.shared.activeController!.contactController.coreData!.contacts!.enumerated() {
                        
                        if value.appId == contact.appId {
                            
                            GlobalData.shared.activeController!.contactController.coreData!.contacts!.remove(at: index)
                            break
                        }
                    }
                    
                    self.theDuplicateGroup!.remove(at: indexPath.row)
                    self.mergeTableView.reloadData()
                }
            }
        }
    }
}

// MARK: - DETAIL CELL DELEGATE PROTOCOL
extension DuplicateDetailsView: DuplicateTableCellDelegate {
    
    func contactWasSelected(contact: Contact, indexPath: IndexPath) {
        
        mergeTargetIndex = indexPath
        mergeButton.isEnabled = true
        mergeTableView.reloadData()
    }
    
    func contactWasDeselected(contact: Contact, indexPath: IndexPath) {
        
        mergeTargetIndex = nil
        mergeButton.isEnabled = false
        mergeTableView.reloadData()
    }
}

// MARK: - DUPLICATE CONTACT STRUCTURES
extension DuplicateDetailsView {
  
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

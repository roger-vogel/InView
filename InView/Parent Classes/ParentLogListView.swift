//
//  ParentLogView.swift
//  InView
//
//  Created by Roger Vogel on 10/23/22.
//

import UIKit
import AlertManager
import ColorManager
import DateManager

class ParentLogListView: ParentView {

    // MARK: STORYBOARD CONNECTORS
    var theNameLabel: UILabel?
    var theLogTableView: UITableView?
    var theRecordCountLabel: UILabel?
    var theSortButton: UIButton?
    var theEditModeButton: UIButton?
    
    // MARK: - PROPERTIES
    var currentSort: Sort = .descending
    var theLogEntries = [LogEntry]()
    var theContact: Contact?
    var theCompany: Company?
    var theProject: Project?
    var logOwner: Int?
    
    // MARK: - INITIALIZATION
    
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theLogTableView!.delegate = self
        theLogTableView!.dataSource = self
        
        theLogTableView!.isEditing = false
        theLogTableView!.allowsSelectionDuringEditing = false
        theLogTableView!.sectionHeaderTopPadding = 10
        theLogTableView!.sectionIndexMinimumDisplayRowCount = 15
        theLogTableView!.separatorColor = ThemeColors.deepAqua.uicolor
       
        super.initView(inController: inController)
    }
    
    // MARK: - METHODS
    func setContactRecord(contact: Contact) {
        
        theContact = contact
        theNameLabel!.text = theContact!.firstName! + " " + theContact!.lastName!
        reloadLogTable()
    }
    
    func setCompanyRecord(company: Company) {
        
        theCompany = company
        theNameLabel!.text = theCompany!.name!
        reloadLogTable()
    }
    
    func setProjectRecord(project: Project) {
        
        theProject = project
        theNameLabel!.text = theProject!.name!
        reloadLogTable()
    }
    
    func reloadLogTable() {
    
        theLogEntries.removeAll()
        
        switch logOwner! {
            
            case Tabs.contacts:
                for setItem in theContact!.logEntries! { theLogEntries.append(setItem as! LogEntry) }
            
            case Tabs.companies:
                for setItem in theCompany!.logEntries! { theLogEntries.append(setItem as! LogEntry) }
            
            case Tabs.projects:
                for setItem in theProject!.logEntries! { theLogEntries.append(setItem as! LogEntry) }
            
            default: break
        }
        
        switch currentSort {
                
            case .ascending:
            
                theLogEntries.sort { $0.timestamp! < $1.timestamp! }
                theSortButton!.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
            
            case .descending:
            
                theLogEntries.sort { $0.timestamp! > $1.timestamp! }
                theSortButton!.setImage(UIImage(systemName: "arrow.up.circle"), for: .normal)
            
            case .none:
            
                theSortButton!.setImage(UIImage(systemName: "arrow.up.circle"), for: .normal)
        }
       
        theLogTableView!.reloadData()
    
        let description = theLogEntries.count == 1 ? "Log Entry" : "Log Entries"
        theRecordCountLabel!.text = String(format: "%d " + description, theLogEntries.count )
    }
    
    func toggleEditMode(_ sender: UIButton) {
        
        guard !theLogEntries.isEmpty else { return }
        
        theLogTableView!.isEditing = !theLogTableView!.isEditing
        
        var buttonImage: UIImage?
        buttonImage = theLogTableView!.isEditing ? UIImage(systemName: "pencil.circle.fill") : UIImage(systemName: "pencil.circle")
        
        sender.setImage(buttonImage, for: .normal)
    }
    
    func doSort() {
        
        switch currentSort {
            
            case .ascending: currentSort = .descending
            case .descending: currentSort = .ascending
            case .none: currentSort = .descending
        }

        reloadLogTable()
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ParentLogListView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
   
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch logOwner! {
            
            case Tabs.contacts:
            
                guard theContact != nil else { return 0 }
                return theContact!.logEntries!.count
            
            case Tabs.companies:
            
                guard theCompany != nil else { return 0 }
                return theCompany!.logEntries!.count
            
            case Tabs.projects:
            
                guard theProject != nil else { return 0 }
                return theProject!.logEntries!.count
            
            default: return 0
        }
    }
   
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 30 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "logEntryListStyle", for: indexPath) as! LogEntryListCell
        let logEntry = theLogEntries[indexPath.row]
        
        cell.dateLabel.text = DateManager(date: logEntry.timestamp!).dateString
        cell.timeLabel.text = DateManager(date: logEntry.timestamp!).timeString
        cell.logEntryTextField.text = logEntry.notes!
        
        cell.backgroundColor = indexPath.row % 2 == 0 ? .white : ColorManager(grayScalePercent: 90).uicolor
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: self.frame.width)
      
        return cell
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        parentController!.projectController.projectLogEntryView.setLogEntry(project: theProject!, logEntry: theLogEntries[indexPath.row])
        parentController!.projectController.projectLogEntryView.showView(withTabBar: false)
    }
     
    // Allow row move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Move a row
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let itemToMove = theLogEntries[sourceIndexPath.row]
        theLogEntries.remove(at: sourceIndexPath.row)
        theLogEntries.insert(itemToMove, at: destinationIndexPath.row)
        
        currentSort = .none
        reloadLogTable()
    }
    
    // Indent in edit mode
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { return true }
         
    // Show delete and drag bars
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {  return .delete }
    
    // Allow editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Delete log entry
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let logEntry = theLogEntries[indexPath.row]
          
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Delete Log Entry", aMessage: "Are you sure you want to delete the log entry?", buttonTitles: ["CANCEL","DELETE"], theStyle: [.cancel,.destructive], theType: .actionSheet) { choice in
                
                if choice == 1 {
                    
                    for entry in self.theLogEntries {
                        
                        if entry.id == logEntry.id {
                            
                            self.theProject!.removeFromLogEntries(logEntry)
                            break
                        }
                    }
              
                    self.theLogEntries.remove(at: indexPath.row)
                    GlobalData.shared.saveCoreData()
                    
                    if self.theLogEntries.isEmpty { self.toggleEditMode(self.theEditModeButton!) }
                    
                    self.reloadLogTable()
                }
            }
        }
    }
}

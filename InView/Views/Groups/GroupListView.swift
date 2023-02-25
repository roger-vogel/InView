//
//  GroupListView.swift
//  InView
//
//  Created by Roger Vogel on 10/5/22.
//

import UIKit
import AlertManager

class GroupListView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var addGroupButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var editModeButton: UIButton!
   
    // MARK: - PROPERTIES
    var searchGroups = [Group]()
    var theGroups = [Group]()
    var isFirstLaunch: Bool = true
    
    // MARK: - COMPUTED PROPERTIES
    var groupCount: Int {
        
        var counter: Int = 0
        
        for group in theGroups {
            
            if !group.isDivider { counter += 1 }
        }
        
        return counter
    }
   
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        super.initView(inController: inController)
     
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        
        groupsTableView.sectionHeaderTopPadding = 0
        groupsTableView.sectionIndexMinimumDisplayRowCount = 15
        groupsTableView.separatorColor = .clear
        groupsTableView.isEditing = false
   
        theMenuButton = menuButton
    }
    
    override func setupView() {
        
        if isFirstLaunch {
            
            theGroups = parentController!.contactController.coreData!.groups!
            isFirstLaunch = false
        }
   
        refresh()
    }
    
    override func refresh() {
        
        reIndex()
        searchGroups.removeAll()
        
        if !theGroups.isEmpty {
            
            if !searchTextField.text!.isEmpty {
                
                searchGroups = parentController!.contactController.coreData!.groups!.filter { $0.name!.uppercased().contains(searchTextField.text!.uppercased())}
            }
        }
        
        if searchTextField.text!.isEmpty {
           
            let description = theGroups.count == 1 ? "Group" : "Groups"
            recordCountLabel.text = String(format: "%d " + description, groupCount )
            
        } else {
     
            let description = searchGroups.count == 1 ? "Group" : "Groups"
            recordCountLabel.text = String(format: "%d " + description, searchGroups.count )
        }
        
        groupsTableView.reloadData()
    }
  
    // MARK: - METHODS
    func reIndex() {
        
        for (index,value) in theGroups.enumerated() { value.sortOrder = Int32(index) }
    }
    
    func addRow(atIndex: Int? = nil, groupName: String? = nil) {
        
        let newGroup = Group(context: GlobalData.shared.viewContext)
       
        newGroup.id = UUID()
        newGroup.appId = UUID().description
        newGroup.timestamp = Date()
        
        if groupName != nil { newGroup.name = groupName! }
     
        if atIndex == nil {
            
            newGroup.isDivider = false
            newGroup.sortOrder = Int32(theGroups.count)
            theGroups.append(newGroup)
            parentController!.contactController.coreData!.groups!.append(newGroup)
            
        }  else {
            
            newGroup.isDivider = true
            newGroup.sortOrder = Int32(atIndex!)
            theGroups.insert(newGroup, at: atIndex!)
            parentController!.contactController.coreData!.groups!.insert(newGroup, at: atIndex!)
        }
    
        GlobalData.shared.saveCoreData()
        refresh()
    }
   
    func confirmGroupDeletion() {
        
        AlertManager(controller: GlobalData.shared.activeController!).popupWithTextField(aMessage: "Enter the group name:", aPlaceholder: "Group name", aDefault: "", buttonTitles: ["CANCEL","CREATE"], aStyle: [.cancel,.default]) { button, text in
        
            if button == 1 && !text.isEmpty { self.addRow() }
        }
    }
    
    func addDivider(aboveIndex: Int) { self.addRow(atIndex: aboveIndex) }
        
    func deleteRow(row: Int) -> UIContextualAction {
        
        let contextualAction = UIContextualAction(style: .normal, title: "Delete", handler: { (contextualAction: UIContextualAction, swipeButton: UIView, completionHandler: (Bool) -> Void) in
            
            let group = self.theGroups[row]
            
            if !group.isDivider {
               
                AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Delete Group", aMessage: "Are you sure you want to delete " + group.name! + "?", buttonTitles: ["CANCEL","DELETE"], theStyle: [.cancel,.destructive], theType: .actionSheet) { choice in
                    
                    if choice == 1 { self.doDelete(row: row, group: group) }
                }
                
            } else { self.doDelete(row: row, group: group) }
        })
        
        contextualAction.backgroundColor = .red
        return contextualAction
    }
    
    func doDelete(row: Int, group: Group) {
        
        let coreDataIndex = Int(theGroups[row].sortOrder)
        
        theGroups.remove(at: row)
        parentController!.contactController.coreData!.groups!.remove(at: coreDataIndex)
        
        GlobalData.shared.viewContext.delete(group)
        GlobalData.shared.saveCoreData()
 
        if parentController!.contactController.coreData!.groups!.isEmpty && groupsTableView.isEditing { onEditMode(editModeButton) }
       
        refresh()
    }
    
    func onGroupSwipe(index: Int) -> UIContextualAction {
        
        let contextualAction = UIContextualAction(style: .normal, title: "Insert\nDivider", handler: { (contextualAction: UIContextualAction, swipeButton: UIView, completionHandler: (Bool) -> Void) in
            
            self.addDivider(aboveIndex: index)
            return completionHandler(true)
        })
        
        contextualAction.backgroundColor = ThemeColors.teal.uicolor
        return contextualAction
    }
    
    // MARK: ACTION HANDLERS
    @IBAction func onEditMode(_ sender: UIButton) {
        
        groupsTableView.isEditing = !groupsTableView.isEditing
        
        var buttonImage: UIImage?
        buttonImage = groupsTableView.isEditing ? UIImage(systemName: "pencil.circle.fill") : UIImage(systemName: "pencil.circle")
        
        sender.setImage(buttonImage, for: .normal)
    }

    @IBAction func onSearchPrimaryAction(_ sender: Any) { dismissKeyboard() }
    
    @IBAction func onEditChange(_ sender: Any) { refresh() }
    
    @IBAction func onMenu(_ sender: Any) {
        
        menuButton.isHidden = true
        
        initMenu()
        theMenuView!.showMenu()
    }
    
    @IBAction func onPlus(_ sender: Any) {
        
        AlertManager(controller: GlobalData.shared.activeController!).popupWithTextField(aMessage: "Enter the group name:", aPlaceholder: "Group name", aDefault: "", buttonTitles: ["CANCEL","CREATE"], disabledButtons: [1], aStyle: [.cancel,.default]) { button, text in
            
            if button == 1 && !text.isEmpty { self.addRow(groupName: text) }
        }
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension GroupListView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
  
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if searchTextField.text!.isEmpty { return theGroups.count }
        return searchGroups.count
    }
  
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if theGroups[indexPath.row].isDivider { return 30 }
        else { return 54 }
    }
  
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        if theGroups[indexPath.row].isDivider { return false }
        return true
    }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if theGroups[indexPath.row].isDivider {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dividerStyle", for: indexPath) as! DividerCell
            
            cell.delegate = self
            cell.myIndex = indexPath.row
            
            if theGroups[indexPath.row].name != nil { cell.titleTextField.text = theGroups[indexPath.row].name }
           
            return cell
            
        } else {
            
            var group: Group?
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupListStyle", for: indexPath) as! GroupListCell
            
            if searchTextField.text!.isEmpty { group = theGroups[indexPath.row] }
            else { group = searchGroups[indexPath.row] }
            
            if group!.name != nil { cell.groupNameLabel.text = group!.name! }
            
            if indexPath.row < theGroups.count - 1 {
                
                if theGroups[indexPath.row + 1].isDivider { cell.dividerLabel.isHidden = true }
                else { cell.dividerLabel.isHidden = false }
            }
      
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: groupsTableView.frame.width)
            
            return cell
        }
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !theGroups[indexPath.row].isDivider else { return }
        
        let group = searchTextField.text!.isEmpty ? theGroups[indexPath.row] : searchGroups[indexPath.row]
        
        parentController!.groupController.groupDetailsView.setGroupRecord(group: group)
        parentController!.groupController.groupDetailsView.showView(withTabBar: false)
    }
    
    // Allow row move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Move a row
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemToMove = theGroups[sourceIndexPath.row]
      
        theGroups.remove(at: sourceIndexPath.row)
        theGroups.insert(itemToMove, at: destinationIndexPath.row)
            
        parentController!.contactController.coreData!.groups!.remove(at: sourceIndexPath.row)
        parentController!.contactController.coreData!.groups!.insert(itemToMove, at: destinationIndexPath.row)
        
        GlobalData.shared.saveCoreData()
        
        refresh()
    }
    
    // Indent in edit mode
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { return false }
         
    // Show delete and drag bars
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {  return .delete }
    
    // Allow delete and move
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Delete group
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Delete Group", aMessage: "Are you sure you want to delete " + theGroups[indexPath.row].name! + "?", buttonTitles: ["CANCEL","DELETE"], theStyle: [.cancel,.destructive], theType: .actionSheet) { choice in
                
                if choice == 1 {
                    
                    self.parentController!.contactController.coreData!.groups!.remove(at: indexPath.row)
                    
                    GlobalData.shared.viewContext.delete(self.theGroups[indexPath.row])
                    GlobalData.shared.saveCoreData()
                    
                    if self.parentController!.contactController.coreData!.groups!.isEmpty && self.groupsTableView.isEditing { self.onEditMode(self.editModeButton) }
                    self.refresh()
                }
            }
        }
    }
    
    // Trailing Swipes
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if !theGroups[indexPath.row].isDivider {
            
            return UISwipeActionsConfiguration(actions: [deleteRow(row: indexPath.row),onGroupSwipe(index: indexPath.row)])
            
        } else {
       
            return UISwipeActionsConfiguration(actions: [deleteRow(row: indexPath.row)])
        }
    }
}

extension GroupListView: DividerTableCellDelegate {
    
    func titleHasChanged(forIndex: Int, name: String) {
        
        theGroups[forIndex].name = name
     
        parentController!.contactController.coreData!.groups![Int(theGroups[forIndex].sortOrder)].name = name
        GlobalData.shared.saveCoreData()
    }
}

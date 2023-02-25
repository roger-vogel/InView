//
//  ProjectMembersView.swift
//  InView
//
//  Created by Roger Vogel on 10/9/22.
//

import UIKit

class ProjectTeamView: ParentView  {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var addContactView: UIView!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var plusMinusButton: UIButton!
    @IBOutlet weak var existingContactButton: UIButton!
    @IBOutlet weak var newContactButton: UIButton!
    @IBOutlet weak var cancelContactButton: UIButton!
    
    var theTeam = [Contact]()
    var theProject: Project?
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        teamTableView.delegate = self
        teamTableView.dataSource = self
        
        teamTableView.isEditing = true
        teamTableView.allowsSelectionDuringEditing = true
        teamTableView.sectionHeaderTopPadding = 10
        teamTableView.sectionIndexMinimumDisplayRowCount = 15
        teamTableView.separatorColor = ThemeColors.deepAqua.uicolor
     
        addContactView.setBorder(width: 2.0, color: UIColor.white.cgColor)
        addContactView.roundAllCorners(value: 10)
        addContactView.isHidden = true
        addContactView.alpha = 0.0
        
        addContactView.layer.shadowColor = UIColor.black.cgColor
        addContactView.layer.shadowOpacity = 0.65
        addContactView.layer.shadowOffset = .zero
        
        existingContactButton.setBorder(width: 2.0, color: UIColor.white.cgColor)
        existingContactButton.roundAllCorners(value: 15)
        
        newContactButton.setBorder(width: 2.0, color: UIColor.white.cgColor)
        newContactButton.roundAllCorners(value: 15)
        
        cancelContactButton.setBorder(width: 1.0, color: ThemeColors.beige.cgcolor)
        cancelContactButton.roundAllCorners(value: 15)
        
        super.initView(inController: inController)
    }
    
    // MARK: - METHODS
    func setProjectRecord(project: Project? = nil) {
        
        if project != nil { theProject = project }
        
        titleLabel.text = theProject!.name
        reloadTeamTable()
    }
    
    func reloadTeamTable() {
    
        theTeam.removeAll()
        
        for setItem in theProject!.team! { theTeam.append(setItem as! Contact) }
    
        theTeam.sort { $0.lastName! < $1.lastName! }
        teamTableView.reloadData()
    
        let description = theProject!.team!.count == 1 ?  "Team Member" : "Team Members"
        recordCountLabel.text = String(format: "%d " + description, theProject!.team!.count )
    }
   
    // MARK: - ACTION HANDLERS
    @IBAction func onPlusMinus(_ sender: Any) {
        
        returnButton.isEnabled = false
        plusMinusButton.isEnabled = false
        
        addContactView.isHidden = false
        UIView.animate(withDuration:0.25, animations: { self.addContactView.alpha = 1.0 })
    }
    
    @IBAction func onChooseContact(_ sender: Any) {
        
        parentController!.projectController.projectTeamSelectionView.theProject = theProject!
        parentController!.projectController.projectTeamSelectionView.loadView(contacts: theTeam)
        parentController!.projectController.projectTeamSelectionView.showView(withTabBar: false)
      
        addContactView.alpha = 0.0
        addContactView.isHidden = true
        
        returnButton.isEnabled = true
        plusMinusButton.isEnabled = true
    }
    
    @IBAction func onCreateContact(_ sender: Any) {
        
        parentController!.contactController.contactEditView.setContactRecord(newContact: true, isFromProject: theProject!)
        parentController!.gotoTab(Tabs.contacts, showingView: parentController!.contactController.contactEditView, fade: false, withTabBar: false)
        
        addContactView.alpha = 0.0
        addContactView.isHidden = true
        
        returnButton.isEnabled = true
        plusMinusButton.isEnabled = true
    }
    
    @IBAction func onCancelContact(_ sender: Any) {
        
        returnButton.isEnabled = true
        plusMinusButton.isEnabled = true
        
        addContactView.alpha = 0.0
        addContactView.isHidden = true
    }

    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.projectController.projectDetailsView.showView(withTabBar: false)
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ProjectTeamView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
         
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { theTeam.count }
        
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 120 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectTeamListStyle", for: indexPath) as! ProjectMemberListCell
        let contact = theTeam[indexPath.row]
        
        cell.theContact = contact
        cell.parentController = parentController!
        
        if contact.hasPhoto { cell.contactImageView.image = UIImage(data: Data(base64Encoded: contact.photo!)!)}
        else { cell.contactImageView.image = GlobalData.shared.contactNoPhoto }
        
        cell.contactNameLabel.text = contact.firstName! + " " + contact.lastName!
        cell.contactTitleLabel.text = contact.title! == "" ? "No title entered" : contact.title!
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return cell
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if parentController!.contactController.contactDetailsView!.parentController == nil {
            
            parentController!.contactController.contactDetailsView!.initView(inController: parentController!.contactController)
        }
      
        parentController!.contactController.launchPrimaryView = false
        parentController!.contactController.contactDetailsView!.thelastTab = Tabs.projects
        parentController!.contactController.contactDetailsView!.setContactRecord(contact: theTeam[indexPath.row])
        parentController!.gotoTab(Tabs.contacts, showingView: parentController!.contactController.contactDetailsView!, withTabBar: false)
    }
    
    // Allow row move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Move a row
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let itemToMove = theTeam[sourceIndexPath.row]
        theTeam.remove(at: sourceIndexPath.row)
        theTeam.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    // Don't indent in edit mode
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { return false }
         
    // Show only drag bars
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {  return .none }
}

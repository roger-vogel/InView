//
//  ProjectMemberSelectionView.swift
//  InView
//
//  Created by Roger Vogel on 10/9/22.
//

import UIKit

class ProjectTeamSelectionView: ParentSelectionView {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectorTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
  
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theTitleLabel = titleLabel
        theSelectorTableView = selectorTableView
        theRecordCountLabel = recordCountLabel
        theSearchTextField = searchTextField
     
        super.initView(inController: inController)
    }
    
    // MARK: - SELECTOR CELL DELEGATE PROTOCOL
    override func contactWasSelected(contact: Contact) {
        
        guard !theSelectedContacts!.contains(contact) else { return }
        
        theSelectedContacts!.append(contact)
        theProject!.addToTeam(contact)
        
        setRecordCount()
        GlobalData.shared.saveCoreData()
    }
    
    override func contactWasDeselected(contact: Contact) {
        
        guard theSelectedContacts!.contains(contact) else { return }
        
        theSelectedContacts = theSelectedContacts!.filter { $0 != contact }
        theProject!.removeFromTeam(contact)
        
        setRecordCount()
        GlobalData.shared.saveCoreData()
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.projectController.projectTeamView.reloadTeamTable()
        parentController!.projectController.projectTeamView.showView(withTabBar: false)
        
        // Save the change
        GlobalData.shared.saveCoreData()
    }
}

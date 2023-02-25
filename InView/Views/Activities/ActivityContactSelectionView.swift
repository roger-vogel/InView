//
//  ActivitySelectionView.swift
//  InView
//
//  Created by Roger Vogel on 10/27/22.
//

import UIKit

class ActivityContactSelectionView: ParentSelectionView {

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
        
        if !theSelectedContacts!.contains(contact) { theSelectedContacts!.append(contact) }
        setRecordCount()
    }
    
    override func contactWasDeselected(contact: Contact) {
        
        for (index,value) in theSelectedContacts!.enumerated() {
            
            if value == contact {
                
                theSelectedContacts!.remove(at: index)
                break
            }
        }
        
        setRecordCount()
    }
 
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        if activityType == .task {
            
            if theSelectedContacts != nil {
                parentController!.activityController.taskDetailsView.selectedContacts = theSelectedContacts!
            }
          
            parentController!.activityController.taskDetailsView.showView(withTabBar: false)

        }  else {
            
            if theSelectedContacts != nil {
                parentController!.activityController.eventDetailsView.selectedContacts = theSelectedContacts!
            }
            
            parentController!.activityController.eventDetailsView.showView(withTabBar: false)
        }
    }
}

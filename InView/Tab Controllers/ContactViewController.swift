//
//  ContactViewController.swift
//  InView
//
//  Created by Roger Vogel on 9/23/22.
//

import UIKit

class ContactViewController: ParentViewController {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet var contactListView: ContactListView!
    @IBOutlet var contactDetailsView: ContactDetailsView!
    @IBOutlet var contactEditView: ContactEditView!
    @IBOutlet var contactProjectListView: ContactProjectListView!
    @IBOutlet var contactLogListView: ContactLogListView!
    @IBOutlet var contactLogEntryView: ContactLogEntryView!
    @IBOutlet var contactActivityListView: ContactActivityListView!
    @IBOutlet var contactActivityMoveView: ContactActivityMoveView!
    
    // MARK: - PROPERTIES
    var coreData: CoreDataManager?
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addSubViews(subViews: [
            contactListView,
            contactDetailsView,
            contactEditView,
            contactProjectListView,
            contactLogListView,
            contactLogEntryView,
            contactActivityListView,
            contactActivityMoveView
        ])

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(false)
        
        if coreData == nil {
            
            coreData = CoreDataManager(parent: self, onCompletion: { self.contactListView.showView(withFade: false, withTabBar: true) })
            
        } else if launchPrimaryView {
            
            contactListView.showView(withFade: false)
           
        } else {
            
            if nonPrimaryView != nil {
                
                nonPrimaryView!.showView(withFade: true, withTabBar: false)
                nonPrimaryView = nil
            }
            
            launchPrimaryView = true
        }
    }
}

//
//  ContactProjectListView.swift
//  InView
//
//  Created by Roger Vogel on 10/20/22.
//

import UIKit

class ContactProjectListView: ParentProjectListView {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var projectTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
   
    // MARK: - INITIALIZATION AND OVERRIDES
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
    
        theTitleLabel = titleLabel
        theProjectTableView = projectTableView
        theRecordCountLabel = recordCountLabel
       
        super.initView(inController: inController)
    }

    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.contactController.contactDetailsView.showView(withTabBar: false)
    }
    
    @IBAction func onPlus(_ sender: Any) {
        
        let projectDetails = parentController!.projectController.projectDetailsView!
        if projectDetails.parentController == nil { projectDetails.initView(inController: parentController!.projectController) }
       
        projectDetails.thelastTab = Tabs.contacts
        projectDetails.setProjectRecord(fromContact: theContact!)
        parentController!.gotoTab(Tabs.projects, showingView: projectDetails)
    }
    
    @IBAction func onSend(_ sender: Any) {
        
    }
}

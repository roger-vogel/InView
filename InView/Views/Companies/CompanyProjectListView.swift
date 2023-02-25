//
//  CompanyProjectListView.swift
//  InView
//
//  Created by Roger Vogel on 10/21/22.
//

import UIKit

class CompanyProjectListView: ParentProjectListView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var projectTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
   
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
       
        theTitleLabel = titleLabel
        theProjectTableView = projectTableView
        theRecordCountLabel = recordCountLabel
        
        super.initView(inController: inController)
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.companyController.companyDetailsView.showView(withTabBar: false)
    }
    
    @IBAction func onPlus(_ sender: Any) {
        
        let projectDetails = parentController!.projectController.projectDetailsView!
        if projectDetails.parentController == nil { projectDetails.initView(inController: parentController!.projectController) }
       
        projectDetails.thelastTab = Tabs.companies
        projectDetails.setProjectRecord(fromCompany: theCompany!)
        parentController!.gotoTab(Tabs.projects, showingView: projectDetails)
    }
    
    @IBAction func onSend(_ sender: Any) {
    }
}

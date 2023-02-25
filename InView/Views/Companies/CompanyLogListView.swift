//
//  CompanyLogListView.swift
//  InView
//
//  Created by Roger Vogel on 10/23/22.
//

import UIKit

class CompanyLogListView: ParentLogListView {

    // MARK: STORYBOARD CONNECTORS
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var logTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var editModeButton: UIButton!
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        logOwner = Tabs.companies
        
        logTableView.delegate = self
        logTableView.dataSource = self
        
        logTableView.isEditing = false
        logTableView.allowsSelectionDuringEditing = false
        logTableView.sectionHeaderTopPadding = 10
        logTableView.sectionIndexMinimumDisplayRowCount = 15
        logTableView.separatorColor = ThemeColors.deepAqua.uicolor
              
        theLogTableView = logTableView
        theNameLabel = contactNameLabel
        theRecordCountLabel = recordCountLabel
        theSortButton = sortButton
        theEditModeButton = editModeButton
       
        super.initView(inController: inController)
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onSort(_ sender: UIButton) { doSort() }
    
    @IBAction func onPlus(_ sender: Any) {
        
        parentController!.companyController.companyLogEntryView.setLogEntry(company: theCompany!)
        parentController!.companyController.companyLogEntryView.showView(withTabBar: false)
    }
    
    @IBAction func onEditMode(_ sender: UIButton) { toggleEditMode(sender) }
    
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.companyController.companyDetailsView.setCompanyRecord(company: theCompany!)
        parentController!.companyController.companyDetailsView.showView(withTabBar: false)
        
    }
}

//
//  ProjectLogView.swift
//  InView
//
//  Created by Roger Vogel on 10/9/22.
//

import UIKit

class ProjectLogListView: ParentLogListView {

    // MARK: STORYBOARD CONNECTORS
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var logTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var editModeButton: UIButton!
   
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        logOwner = Tabs.projects
        
        logTableView.delegate = self
        logTableView.dataSource = self
        
        logTableView.isEditing = false
        logTableView.allowsSelectionDuringEditing = false
        logTableView.sectionHeaderTopPadding = 10
        logTableView.sectionIndexMinimumDisplayRowCount = 15
        logTableView.separatorColor = ThemeColors.deepAqua.uicolor
    
        theLogTableView = logTableView
        theNameLabel = projectNameLabel
        theRecordCountLabel = recordCountLabel
        theSortButton = sortButton
        theEditModeButton = editModeButton
       
        super.initView(inController: inController)
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onSort(_ sender: UIButton) { doSort() }
        
    @IBAction func onPlus(_ sender: Any) {
        
        parentController!.projectController.projectLogEntryView.setLogEntry(project: theProject!)
        parentController!.projectController.projectLogEntryView.showView(withTabBar: false)
    }
    
    @IBAction func onEditMode(_ sender: UIButton) { toggleEditMode(sender) }
         
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.projectController.projectDetailsView.setProjectRecord(project: theProject!)
        parentController!.projectController.projectDetailsView.showView(withTabBar: false)
        
    }
}

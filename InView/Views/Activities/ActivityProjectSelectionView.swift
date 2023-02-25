//
//  ActivityProjectSelectionView.swift
//  InView
//
//  Created by Roger Vogel on 10/27/22.
//

import UIKit

class ActivityProjectSelectionView: ParentSelectionView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var selectorTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theTitleLabel = titleLabel
        theSelectorTableView = selectorTableView
        theRecordCountLabel = recordCountLabel
        theSearchTextField = searchTextField
        
        super.initView(inController: inController)
    }
    
    // MARK: - SELECTOR CELL DELEGATE PROTOCOL
    override func projectWasSelected(project: Project) {
        
        if !theSelectedProjects!.contains(project) { theSelectedProjects!.append(project) }
        setRecordCount()
    }
  
    override func projectWasDeselected(project: Project) {
        
        for (index,value) in theSelectedProjects!.enumerated() {
            
            if value == project {
                
                theSelectedProjects!.remove(at: index)
                break
            }
        }
        
        setRecordCount()
    }
        
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        if activityType == .task {
            
            if theSelectedProjects != nil {
                parentController!.activityController.taskDetailsView.selectedProjects = theSelectedProjects!
            }
          
            parentController!.activityController.taskDetailsView.showView(withTabBar: false)

        }  else {
            
            if theSelectedProjects != nil {
                parentController!.activityController.eventDetailsView.selectedProjects = theSelectedProjects!
            }
            
            parentController!.activityController.eventDetailsView.showView(withTabBar: false)
        }
    }
}

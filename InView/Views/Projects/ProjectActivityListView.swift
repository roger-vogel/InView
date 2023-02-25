//
//  ProjectActivityListView.swift
//  InView
//
//  Created by Roger Vogel on 11/10/22.
//

import UIKit

class ProjectActivityListView: ParentActivityListView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var moveButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var activityTypeSegmentControl: UISegmentedControl!
    
    // MARK: - INITIALIZATION AND OVERRIDES
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
    
        theTitleLabel = titleLabel
        theActivityTableView = activityTableView
        theRecordCountLabel = recordCountLabel
        theEditButton = editButton
        thePlusButton = plusButton
        theMoveButton = moveButton
        theActivityTypeSegmentControl = activityTypeSegmentControl
       
        super.initView(inController: inController)
    }
 
    @IBAction func onType(_ sender: Any) {
        
        if activityTypeSegmentControl.selectedSegmentIndex == 2 { enableControls(false) }
        else { enableControls(true) }
        
        setProject(theProject!)
    }
    
    @IBAction func onMove(_ sender: Any) {
        
        parentController!.projectController.projectActivityMoveView.activityTypeSegmentControl.selectedSegmentIndex = theActivityTypeSegmentControl.selectedSegmentIndex
        parentController!.projectController.projectActivityMoveView.setTheEntity(forProject: theProject!)
        parentController!.projectController.projectActivityMoveView.showView()
    }
  
    @IBAction func onPlus(_ sender: Any) { addActivity() }
   
    @IBAction func onEdit(_ sender: Any) {
        
        isEditMode = !isEditMode
        editButton.tintColor = isEditMode ? ThemeColors.darkGray.uicolor : .white
        activityTableView.reloadData()
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        dismissKeyboard()
        
        enableEditMode(force: false)
        parentController!.projectController.projectDetailsView.showView(withTabBar: false)
    }
}

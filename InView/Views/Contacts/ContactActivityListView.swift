//
//  ContactActivityListView.swift
//  InView
//
//  Created by Roger Vogel on 11/7/22.
//

import UIKit

class ContactActivityListView: ParentActivityListView {
    
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
    
        setContact(theContact!)
    }
    
    @IBAction func onMove(_ sender: Any) {
        
        parentController!.contactController.contactActivityMoveView.activityTypeSegmentControl.selectedSegmentIndex = theActivityTypeSegmentControl.selectedSegmentIndex
        parentController!.contactController.contactActivityMoveView.setTheEntity(forContact: theContact!)
        parentController!.contactController.contactActivityMoveView.showView()
    }
    
    @IBAction func onPlus(_ sender: Any) { addActivity() }
       
    @IBAction func onEdit(_ sender: Any) { enableEditMode() }
  
    @IBAction func onReturn(_ sender: Any) {
        
        dismissKeyboard()
        
        enableEditMode(force: false)
        parentController!.contactController.contactDetailsView.showView(withTabBar: false)
    }
}

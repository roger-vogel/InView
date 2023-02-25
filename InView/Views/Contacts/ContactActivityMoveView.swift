//
//  ContactActivityMoveView.swift
//  InView
//
//  Created by Roger Vogel on 1/22/23.
//

import UIKit

class ContactActivityMoveView: ParentActivityMoveView {

    // MARK: - STORYBOARD OUTLETS
    @IBOutlet weak var activityMoveTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var moveButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var activityTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var moveMessageLabel: UILabel!
    @IBOutlet weak var popupCalendarView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var calendarMessageLabel: UILabel!
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        // Pass the outlets to the parent
        theActivityMoveTableView = activityMoveTableView
        theRecordCountLabel = recordCountLabel
        theReturnButton = returnButton
        theMoveButton = moveButton
        theDatePicker = datePicker
        theActivityTypeSegmentControl = activityTypeSegmentControl
        theMoveMessageLabel = moveMessageLabel
        thePopupCalendarView = popupCalendarView
        theCalendarMessageLabel = calendarMessageLabel
        
        super.initView(inController: inController)
    }
  
    // MARK: - METHODS
    func setContact(contact: Contact) { setTheEntity(forContact: contact) }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onActivityTypeSelector(_ sender: Any) {
        
        setRecordCount()
        activityMoveTableView.reloadData()
    }
    
    @IBAction func onDatePicker(_ sender: Any) { activityDate = datePicker.date }
  
    @IBAction func onDone(_ sender: Any) { saveMoveToDate() }
    
    @IBAction func onCancel(_ sender: Any) { closeCalendar() }
  
    @IBAction func onPlus(_ sender: Any) { }
  
    @IBAction func onEdit(_ sender: Any) { }
     
    @IBAction func onMove(_ sender: Any) {  moveActivity() }
      
    @IBAction func onReturn(_ sender: Any) {
        
        let listView = parentController!.contactController.contactActivityListView!
        listView.activityTypeSegmentControl.selectedSegmentIndex = activityTypeSegmentControl.selectedSegmentIndex
        listView.setActivities()
        listView.showView()
    }
}

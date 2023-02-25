//
//  ParentActivityMoveView.swift
//  InView
//
//  Created by Roger Vogel on 1/22/23.
//

import UIKit
import DateManager

class ParentActivityMoveView: ParentView {
    
    // MARK: - STORYBOARD CONNECTORS
    var theActivityMoveTableView: UITableView?
    var theRecordCountLabel: UILabel?
    var theMoveButton: UIButton?
    var theReturnButton: UIButton?
    var theActivityTypeSegmentControl: UISegmentedControl?
    var theMoveMessageLabel: UILabel?
    var thePopupCalendarView: UIView?
    var theDatePicker: UIDatePicker?
    var theCalendarMessageLabel: UILabel?
    
    // MARK: - PROPERTIES
    var activityDate: Date?
    var isEditMode = false
    var forContact: Contact?
    var forCompany: Company?
    var forProject: Project?
    var theTasks = [Activity]()
    var theEvents = [Activity]()
    var selectedActivities = [Activity]()
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theActivityMoveTableView!.delegate = self
        theActivityMoveTableView!.dataSource = self
        theActivityMoveTableView!.sectionHeaderTopPadding = 0
        theActivityMoveTableView!.allowsMultipleSelection = true
        theActivityMoveTableView!.separatorColor = .clear
        
        super.initView(inController: inController)
    }
    
    // MARK: - METHODS
    func setTheEntity(forContact: Contact? = nil, forCompany: Company? = nil, forProject: Project? = nil) {
        
        theMoveButton!.isEnabled = false
        thePopupCalendarView!.isHidden = true
        
        self.forContact = forContact
        self.forCompany = forCompany
        self.forProject = forProject
        
        if forContact != nil {
            
            theTasks = parentController!.contactController.coreData!.setToArray(activities: self.forContact!.activities!).filter { $0.isTask }
            theEvents = parentController!.contactController.coreData!.setToArray(activities: self.forContact!.activities!).filter { $0.isEvent }
        }
        
        else if forCompany != nil {
            
            theTasks = parentController!.contactController.coreData!.setToArray(activities: self.forCompany!.activities!).filter { $0.isTask }
            theEvents = parentController!.contactController.coreData!.setToArray(activities: self.forCompany!.activities!).filter { $0.isEvent }
        }
        
        else if forProject != nil {
            
            theTasks = parentController!.contactController.coreData!.setToArray(activities: self.forProject!.activities!).filter { $0.isTask }
            theEvents = parentController!.contactController.coreData!.setToArray(activities: self.forProject!.activities!).filter { $0.isEvent }
        }
        
        else {
            
            theTasks = parentController!.contactController.coreData!.activities!.filter { $0.isTask }
            theEvents = parentController!.contactController.coreData!.activities!.filter { $0.isEvent }
        }
        
        if theActivityTypeSegmentControl!.selectedSegmentIndex == 0 {
            
            if theTasks.count == 1 { theMoveMessageLabel!.text = "Select the task you would like to move" }
            else { theMoveMessageLabel!.text = "Select the tasks you would like to move" }
    
        } else {
            
            if theEvents.count == 1 { theMoveMessageLabel!.text = "Select the event you would like to move" }
            else { theMoveMessageLabel!.text = "Select the events you would like to move" }
        }
        
        setRecordCount()
        theActivityMoveTableView!.reloadData()
    }
    
    func setRecordCount() {
        
        if theActivityTypeSegmentControl!.selectedSegmentIndex == 0 {
            
            let description = theTasks.count == 1 ? "Task" : "Tasks"
            theRecordCountLabel!.text = String(format: "%d " + description, theTasks.count )
            
        } else {
            
            
            let description = theEvents.count == 1 ? "Event" : "Events"
            theRecordCountLabel!.text = String(format: "%d " + description, theEvents.count )
            
        }
        
    }
    
    func enableControls(_ state: Bool) {
        
        theActivityMoveTableView!.isScrollEnabled = state
        theReturnButton!.isEnabled = state
        theMoveButton!.isEnabled = state
    }
    
    func saveMoveToDate() {
        
        thePopupCalendarView!.isHidden = true
        enableControls(true)
        
        for activity in selectedActivities { activity.activityDate = activityDate! }
       
        GlobalData.shared.saveCoreData()
        setTheEntity(forContact: forContact, forCompany: forCompany, forProject: forProject)
    }
    
    func closeCalendar() {
        
        thePopupCalendarView!.isHidden = true
        enableControls(true)
        
        setupView()
    }
    
    func moveActivity() {
        
        if theActivityTypeSegmentControl!.selectedSegmentIndex == 0 {
            
            if selectedActivities.count == 1 { theCalendarMessageLabel!.text = "Select a New Date for this Task" }
            else { theCalendarMessageLabel!.text = "Select a New Date for the Selected Tasks" }
    
        } else {
            
            if selectedActivities.count == 1 { theCalendarMessageLabel!.text = "Select a New Date for this Event" }
            else { theCalendarMessageLabel!.text = "Select a New Date for the Selected Events" }
        }
        
        theDatePicker!.minimumDate = Date()
        
        if selectedActivities.count == 1 { theDatePicker!.date = selectedActivities.first!.activityDate! }
        else { theDatePicker!.date = Date() }
        
        thePopupCalendarView!.isHidden = false
        enableControls(false)
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ParentActivityMoveView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if theActivityTypeSegmentControl!.selectedSegmentIndex == 0 { return theTasks.count }
        else { return theEvents.count }
    }
  
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 30 }
   
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var activity: Activity?
        let activityCell = tableView.dequeueReusableCell(withIdentifier: "activityMoveListStyle", for: indexPath) as? MoveActivityListCell
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .clear
        activityCell!.selectedBackgroundView = selectedBackgroundView
        
        if theActivityTypeSegmentControl!.selectedSegmentIndex == 0 { activity = theTasks[indexPath.row] }
        else { activity = theEvents[indexPath.row] }
        
        activityCell!.activityDateTextField.text = DateManager(date: activity!.activityDate).shortDateString
        activityCell!.activityDescriptionTextField.text = activity!.activityDescription!
        activityCell!.myIndexPath = indexPath
        activityCell!.theActivity = activity
        activityCell!.delegate = self
    
        if isEditMode {
            
            activityCell!.activityDescriptionTextField.backgroundColor = .white
            activityCell!.activityDescriptionTextField.isEnabled = true
            
        } else {
            
            activityCell!.activityDescriptionTextField.backgroundColor = .clear
            activityCell!.activityDescriptionTextField.isEnabled = false
        }
       
        return activityCell!
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? MoveActivityListCell
        cell!.activityDescriptionTextField.backgroundColor = ThemeColors.mediumGray.uicolor
      
        if theActivityTypeSegmentControl!.selectedSegmentIndex == 0 {
        
            if !selectedActivities.contains(theTasks[indexPath.row]) { selectedActivities.append(theTasks[indexPath.row]) }
     
        } else {
            
            if !selectedActivities.contains(theEvents[indexPath.row]) { selectedActivities.append(theEvents[indexPath.row]) }
        }
        
        theMoveButton!.isEnabled = true
    }
    
    // Capture deselection
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? MoveActivityListCell
        cell!.activityDescriptionTextField.backgroundColor = .clear
        
        if theActivityTypeSegmentControl!.selectedSegmentIndex == 0 {
        
            if selectedActivities.contains(theTasks[indexPath.row]) {
                
                let index = selectedActivities.firstIndex(of: theTasks[indexPath.row])
                if index != nil { selectedActivities.remove(at: index!) }
            }
     
        } else {
            
            if !selectedActivities.contains(theEvents[indexPath.row]) {
                
                let index = selectedActivities.firstIndex(of: theEvents[indexPath.row])
                if index != nil { selectedActivities.remove(at: index!) }
            }
        }
        
        if theActivityMoveTableView?.indexPathsForSelectedRows == nil { theMoveButton!.isEnabled = false }
    }
    
    // Allow row move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return false }

    // Allows editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
}

// MARK: - ACTIVITY TABLE CELL DELEGATE PROTOCOL
extension ParentActivityMoveView: ActivityTableCellDelegate {
   
    func activityDescriptionWasChanged(activity: Activity) {
        
        let activityIndex = parentController!.contactController.coreData!.activityIndex(activity: activity)
        parentController!.contactController.coreData!.activities![activityIndex!].activityDescription = activity.activityDescription

        GlobalData.shared.saveCoreData()
    }

    func activityWasSelected(activity: Activity) {
        
        if !selectedActivities.contains(activity) { selectedActivities.append(activity) }
    }
    
    func activityWasDeselected(activity: Activity) {
        
        if selectedActivities.contains(activity) {
            
            let index = parentController!.contactController.coreData!.activityIndex(activity: activity)
            selectedActivities.remove(at: index!)
        }
    }
    
    func onDetailsButton(indexPath: IndexPath) { }
}

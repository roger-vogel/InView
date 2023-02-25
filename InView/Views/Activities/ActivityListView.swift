//
//  ActivityListView.swift
//  InView
//
//  Created by Roger Vogel on 10/24/22.
//

import UIKit
import AlertManager
import DateManager
import Extensions

class ActivityListView: ParentView {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var assignmentButton: UIButton!
    @IBOutlet weak var editModeButton: UIButton!
    @IBOutlet weak var activityTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var activityAndEventTableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var assignmentButtonTrailingContraint: NSLayoutConstraint!
    @IBOutlet weak var editButtonLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - PROPERTIES
    var sectionTitles = ["Past Due", "Today","This Week","Upcoming"]
    var pickerTitles = ["Assign To:","Today","This Week","Upcoming"]
    
    var todaysEvents = [ActivityElement]()
    var thisWeeksEvents = [ActivityElement]()
    var upcomingEvents = [ActivityElement]()
    var pastDueEvents = [ActivityElement]()
    
    var todaysTasks = [ActivityElement]()
    var thisWeeksTasks = [ActivityElement]()
    var upcomingTasks = [ActivityElement]()
    var pastDueTasks = [ActivityElement]()
    
    var completedActivities = [ActivityElement]()
    
    var assignmentIsSelected: Bool = false
    var selectedAssignment: TimeFrame?
    var reAssignTask: Bool = false
    var assignedTimeframe: TimeFrame?
    var activityIsSelected: Bool = false
    var selectedActivityCoreDataIndex: Int?
    
    var selectedRow: IndexPath?
    
    // MARK: - INITIALIZATION AND OVERRIDES
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        super.initView(inController: inController)
        
        activityAndEventTableView.delegate = self
        activityAndEventTableView.dataSource = self
        activityAndEventTableView.sectionHeaderTopPadding = 25
        activityAndEventTableView.allowsSelection = true
        activityAndEventTableView.separatorStyle = .none
        
        assignmentButtonTrailingContraint.constant = (calendarButton.frame.origin.x - 80)/2
        editButtonLeadingConstraint.constant = (calendarButton.frame.origin.x - 80)/2
        
        theMenuButton = menuButton
        
        activityTypeSegmentControl.selectedSegmentIndex = 0
    }
    
    // MARK: - METHODS
    override func setupView() {
        
        // Reset all containers
        todaysTasks.removeAll()
        thisWeeksTasks.removeAll()
        upcomingTasks.removeAll()
        pastDueTasks.removeAll()
        todaysEvents.removeAll()
        thisWeeksEvents.removeAll()
        upcomingEvents.removeAll()
        pastDueEvents.removeAll()
        completedActivities.removeAll()
        
        guard !parentController!.contactController.coreData!.activities!.isEmpty else {
            
            activityAndEventTableView.reloadData()
            return
        }
        
        // Task
        for activity in parentController!.contactController.coreData!.activities! {
            
            let theActivityDate = DateManager(date: activity.activityDate!)
            
            if activity.isTask {
                
                if activity.isCompleted {completedActivities.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isPast { pastDueTasks.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isToday { todaysTasks.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isThisWeek { thisWeeksTasks.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isUpcoming { upcomingTasks.append(ActivityElement(activity: activity, isSelected: false)) }
            }
        }
        
        // Events
        for activity in parentController!.contactController.coreData!.activities! {
            
            let theActivityDate = DateManager(date: activity.activityDate!)
            
            if activity.isEvent {
                
                if activity.isCompleted {completedActivities.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isPast { pastDueEvents.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isToday { todaysEvents.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isThisWeek { thisWeeksEvents.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isUpcoming { upcomingEvents.append(ActivityElement(activity: activity, isSelected: false)) }
            }
        }
        
        if !todaysTasks.isEmpty { todaysTasks.insert(ActivityElement(isHeader: true), at: 0) }
        if !thisWeeksTasks.isEmpty { thisWeeksTasks.insert(ActivityElement(isHeader: true), at: 0) }
        if !upcomingTasks.isEmpty { upcomingTasks.insert(ActivityElement(isHeader: true), at: 0) }
        if !pastDueTasks.isEmpty { pastDueTasks.insert(ActivityElement(isHeader: true), at: 0) }
        
        activityAndEventTableView.reloadData()
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onMenu(_ sender: Any) {
        
        menuButton.isHidden = true
        
        initMenu()
        theMenuView!.showMenu()
    }
    
    @IBAction func onMove(_ sender: UIButton) {
        
        let activityMoveView = parentController!.activityController.activityMoveView
        
        activityMoveView!.setTheEntity()
        activityMoveView!.activityTypeSegmentControl.selectedSegmentIndex = activityTypeSegmentControl.selectedSegmentIndex
        activityMoveView!.showView(withTabBar: false)
    }
    
    @IBAction func onCalendar(_ sender: Any) {

        parentController!.activityController.activityCalendarView.datePicker.date = Date()
        parentController!.activityController.activityCalendarView.showView()
    }
    
    @IBAction func onEditMode(_ sender: UIButton) {
        
        activityAndEventTableView.isEditing = !activityAndEventTableView.isEditing
        
        let buttonImage = activityAndEventTableView.isEditing ? UIImage(systemName: "pencil.circle.fill") : UIImage(systemName: "pencil.circle")
        sender.setImage(buttonImage, for: .normal)
    }
    
    @IBAction func onPlus(_ sender: Any) {
        
        if activityTypeSegmentControl.selectedSegmentIndex == 0 {
            
            parentController!.activityController.taskDetailsView.fromTab = Tabs.activites
            parentController!.activityController.taskDetailsView.setActivity()
            parentController!.activityController.taskDetailsView.showView(withTabBar: false)
            
        } else {
            
            parentController!.activityController.eventDetailsView.fromTab = Tabs.activites
            parentController!.activityController.eventDetailsView.setActivity()
            parentController!.activityController.eventDetailsView.showView(withTabBar: false)
            
        }
        
    }
    
    @IBAction func onSegment(_ sender: UISegmentedControl) { setupView() }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ActivityListView: UITableViewDelegate, UITableViewDataSource {
 
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if activityTypeSegmentControl.selectedSegmentIndex == 2 { return 1 }
        else { return sectionTitles.count }
    }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if activityTypeSegmentControl.selectedSegmentIndex == 0 {
           
            switch section {
                
                case Activities.today: return todaysTasks.count
                case Activities.thisWeek: return thisWeeksTasks.count
                case Activities.upcoming: return upcomingTasks.count
                case Activities.pastDue: return pastDueTasks.count
             
                default: return 0
            }
            
        } else if activityTypeSegmentControl.selectedSegmentIndex == 1 {
            
            switch section {
                
                case Activities.today: return todaysEvents.count
                case Activities.thisWeek: return thisWeeksEvents.count
                case Activities.upcoming: return upcomingEvents.count
                case Activities.pastDue: return pastDueEvents.count
           
             
                default: return 0
            }
            
        } else { return completedActivities.count }
    }
  
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if activityTypeSegmentControl.selectedSegmentIndex == 0 {
            
            if indexPath.row == 0 { return 40 }
            else { return 30 }
            
        } else { return 30 }
    }

    // View for headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard !sectionTitles.isEmpty else { return nil }
        guard activityTypeSegmentControl.selectedSegmentIndex != 2 else { return nil }
         
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 120))
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width-25, height: 28))
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 6.5, width: tableView.frame.size.width, height: 20))
        
        sectionHeaderView.addSubview(headerLabel)
        sectionHeaderView.backgroundColor = .clear
        
        sectionHeaderView.addSubview(backgroundView)
        backgroundView.backgroundColor = .clear
        backgroundView.roundAllCorners(value: 5)
     
        sectionHeaderView.addSubview(headerLabel)
        headerLabel.textColor = ThemeColors.aqua.uicolor
        headerLabel.backgroundColor = .clear
        headerLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
     
        headerLabel.text = sectionTitles[section]
        
        return sectionHeaderView
    }
      
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.row == 0 && activityTypeSegmentControl.selectedSegmentIndex == 0 { return false }
        if activityTypeSegmentControl.selectedSegmentIndex == 2 { return false }
         return true
    }

    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var dateDisplay: String?
        var activityElement: ActivityElement?
        
        if activityTypeSegmentControl.selectedSegmentIndex == 0 {
            
            if indexPath.section == Activities.today { activityElement = todaysTasks[indexPath.row] }
            else if indexPath.section == Activities.thisWeek { activityElement = thisWeeksTasks[indexPath.row] }
            else if indexPath.section == Activities.upcoming{ activityElement = upcomingTasks[indexPath.row] }
            else if indexPath.section == Activities.pastDue { activityElement = pastDueTasks[indexPath.row] }
            
            guard !activityElement!.isHeader! else {
                return tableView.dequeueReusableCell(withIdentifier: "activityHeaderStyle", for: indexPath) }
         
            let activityCell = tableView.dequeueReusableCell(withIdentifier: "activityListStyle", for: indexPath) as? ActivityListCell
            activityCell!.activityDescriptionTextField.text = activityElement!.activity!.activityDescription!
            activityCell!.checkButton.setState(activityElement!.activity!.isCompleted)
            activityCell!.myIndexPath = indexPath
            activityCell!.delegate = self
        
            activityCell!.attachedToTextField.backgroundColor = .clear
            activityCell!.activityDescriptionTextField.backgroundColor = .clear
            activityCell!.ellipsisBorderButton.backgroundColor = .clear
     
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = .clear
            activityCell!.selectedBackgroundView = selectedBackgroundView
            
            let entityCount = activityCell!.setActivity(activity: activityElement!.activity!)
            let contacts = parentController!.contactController.coreData!.setToArray(contacts: activityElement!.activity!.contacts!)
            let companies = parentController!.contactController.coreData!.setToArray(companies: activityElement!.activity!.companies!)
            let projects = parentController!.contactController.coreData!.setToArray(projects: activityElement!.activity!.projects!)
            
            if entityCount > 0 {
                
                if companies.count > 0 { activityCell!.attachedToTextField.text = companies.first!.name! }
                else if contacts.count > 0 { activityCell!.attachedToTextField.text = contacts.first!.firstName! + " " + contacts.first!.lastName! }
                else { activityCell!.attachedToTextField.text = projects.first!.name! }
                
            } else { activityCell!.attachedToTextField.text = "Unattached"}
  
            if indexPath.row == 1 { activityCell!.addTopBorder() }
            return activityCell!
            
        } else if activityTypeSegmentControl.selectedSegmentIndex == 1 {
            
            if indexPath.section == Activities.today { activityElement = todaysEvents[indexPath.row] }
            else if indexPath.section == Activities.thisWeek { activityElement = thisWeeksEvents[indexPath.row] }
            else if indexPath.section == Activities.upcoming{ activityElement = upcomingEvents[indexPath.row] }
            else if indexPath.section == Activities.pastDue{ activityElement = pastDueEvents[indexPath.row]}
       
            guard !activityElement!.isHeader! else {
                return tableView.dequeueReusableCell(withIdentifier: "activityHeaderStyle", for: indexPath) }
            
            let eventCell = tableView.dequeueReusableCell(withIdentifier: "eventListStyle", for: indexPath) as? EventListCell
            
            switch indexPath.section {
                
                case Activities.today: dateDisplay = ""
                case Activities.thisWeek: dateDisplay = DateManager(date: activityElement!.activity!.activityDate!).dayOfWeekString
                case Activities.upcoming: dateDisplay = DateManager(date: activityElement!.activity!.activityDate!).dayOfMonthString
                    
                default: break
            }
            
            eventCell!.dayTextField.text = dateDisplay
            eventCell!.nameTextField.text = activityElement!.activity!.activityDescription!
            eventCell!.delegate = self
            eventCell!.theActivity = activityElement!.activity!
            eventCell!.myIndexPath = indexPath
            
            eventCell!.dayTextField.backgroundColor = .clear
            eventCell!.timeTextField.backgroundColor = .clear
            eventCell!.nameTextField.backgroundColor = .clear
             
            if activityElement!.activity!.isAllDay { eventCell!.timeTextField.text = "All Day" }
            else {
                
                let startTime = DateManager(date: activityElement!.activity!.activityStartTime!)
                eventCell!.timeTextField.text = startTime.timeString
            }

            if indexPath.row == 0 { eventCell!.addTopBorder() }
            return eventCell!
            
        } else {
            
            activityElement = completedActivities[indexPath.row]
            let activityCell = tableView.dequeueReusableCell(withIdentifier: "activityListStyle", for: indexPath) as? ActivityListCell
          
            activityCell!.activityDescriptionTextField.text = activityElement!.activity!.activityDescription!
            activityCell!.checkButton.setState(activityElement!.activity!.isCompleted)
            activityCell!.myIndexPath = indexPath
            activityCell!.delegate = self
            
            let entityCount = activityCell!.setActivity(activity: activityElement!.activity!)
            let contacts = parentController!.contactController.coreData!.setToArray(contacts: activityElement!.activity!.contacts!)
            let companies = parentController!.contactController.coreData!.setToArray(companies: activityElement!.activity!.companies!)
            let projects = parentController!.contactController.coreData!.setToArray(projects: activityElement!.activity!.projects!)
            
            if entityCount > 0 {
                
                if companies.count > 0 { activityCell!.attachedToTextField.text = companies.first!.name! }
                else if contacts.count > 0 { activityCell!.attachedToTextField.text = contacts.first!.firstName! + " " + contacts.first!.lastName! }
                else { activityCell!.attachedToTextField.text = projects.first!.name! }
                
            } else { activityCell!.attachedToTextField.text = "Unattached"}
       
            if indexPath.row == 1 { activityCell!.addTopBorder() }
            return activityCell!
        }
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var activity: Activity?
        
        if activityTypeSegmentControl.selectedSegmentIndex == 0 {
            
            let cell = tableView.cellForRow(at: indexPath) as? ActivityListCell
            cell!.attachedToTextField.backgroundColor = ThemeColors.mediumGray.uicolor
            cell!.activityDescriptionTextField.backgroundColor = ThemeColors.mediumGray.uicolor
            cell!.ellipsisBorderButton.backgroundColor = ThemeColors.mediumGray.uicolor
            
            switch indexPath.section {
                
                case Activities.today:
                    activity = todaysTasks[indexPath.row].activity
                    
                case Activities.thisWeek:
                    activity = thisWeeksTasks[indexPath.row].activity
                    
                case Activities.upcoming:
                    activity = upcomingTasks[indexPath.row].activity
                
                case Activities.pastDue:
                    activity = pastDueTasks[indexPath.row].activity
                
                default: break
            }
            
            self.parentController!.activityController.taskDetailsView.fromTab = Tabs.activites
            self.parentController!.activityController.taskDetailsView.setActivity(activity: activity)
            self.parentController!.activityController.taskDetailsView.showView(withTabBar: false)
             
        } else {
            
            let cell = tableView.cellForRow(at: indexPath) as? EventListCell
            
            cell!.dayTextField.backgroundColor = ThemeColors.mediumGray.uicolor
            cell!.timeTextField.backgroundColor = ThemeColors.mediumGray.uicolor
            cell!.nameTextField.backgroundColor = ThemeColors.mediumGray.uicolor
        
            switch indexPath.section {
                
                case Activities.today:
                activity = todaysEvents[indexPath.row].activity
                
                case Activities.thisWeek:
                activity = thisWeeksEvents[indexPath.row].activity
                    
                case Activities.upcoming:
                    activity = upcomingEvents[indexPath.row].activity
                
                case Activities.pastDue:
                    activity = pastDueEvents[indexPath.row].activity
                
                default: break
            }
            
            self.parentController!.activityController.eventDetailsView.fromTab = Tabs.activites
            self.parentController!.activityController.eventDetailsView.setActivity(activity: activity)
            self.parentController!.activityController.eventDetailsView.showView(withTabBar: false)
        }
    }
    
    // Capture deselection
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        var activity: Activity?
        
        if activityTypeSegmentControl.selectedSegmentIndex == 0 {
            
            let cell = tableView.cellForRow(at: indexPath) as? ActivityListCell
            
            cell!.attachedToTextField.backgroundColor = .clear
            cell!.activityDescriptionTextField.backgroundColor = .clear
            cell!.ellipsisBorderButton.backgroundColor = .clear
            
            switch indexPath.section {
                
                case Activities.today:
                    activity = todaysTasks[indexPath.row].activity
                    
                case Activities.thisWeek:
                    activity = thisWeeksTasks[indexPath.row].activity
                    
                case Activities.upcoming:
                    activity = upcomingTasks[indexPath.row].activity
                
                case Activities.pastDue:
                    activity = pastDueTasks[indexPath.row].activity
                
                default: break
            }
            
            self.parentController!.activityController.taskDetailsView.fromTab = Tabs.activites
            self.parentController!.activityController.taskDetailsView.setActivity(activity: activity)
            self.parentController!.activityController.taskDetailsView.showView(withTabBar: false)
             
        } else {
            
            let cell = tableView.cellForRow(at: indexPath) as? EventListCell
            
            cell!.dayTextField.backgroundColor = .clear
            cell!.timeTextField.backgroundColor = .clear
            cell!.nameTextField.backgroundColor = .clear
            
            switch indexPath.section {
                
                case Activities.today:
                activity = todaysEvents[indexPath.row].activity
                
                case Activities.thisWeek:
                activity = thisWeeksEvents[indexPath.row].activity
                    
                case Activities.upcoming:
                    activity = upcomingEvents[indexPath.row].activity
                
                case Activities.pastDue:
                    activity = pastDueEvents[indexPath.row].activity
                
                default: break
            }
            
            self.parentController!.activityController.eventDetailsView.fromTab = Tabs.activites
            self.parentController!.activityController.eventDetailsView.setActivity(activity: activity)
            self.parentController!.activityController.eventDetailsView.showView(withTabBar: false)
        }
    }
    
    // Allow row move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return false }

    // Allows editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if activityTypeSegmentControl.selectedSegmentIndex == 0 {
            
            if indexPath.row == 0 { return false }
            else { return true }
            
        } else { return true }
    }

    // Delete activity
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Delete Activity", aMessage: "Are you sure you want to delete this activity?", buttonTitles: ["CANCEL","DELETE"], theStyle: [.cancel,.destructive], theType: .actionSheet) { choice in
                
                if choice == 1 {
                    
                    var activity: Activity?
                    
                    if self.activityTypeSegmentControl.selectedSegmentIndex == 0 {
                        
                        if indexPath.section == Activities.today { activity = self.todaysTasks[indexPath.row].activity! }
                        else if indexPath.section == Activities.thisWeek { activity = self.thisWeeksTasks[indexPath.row].activity! }
                        else if indexPath.section == Activities.upcoming { activity = self.upcomingTasks[indexPath.row].activity!  }
                        else { activity = self.pastDueTasks[indexPath.row].activity!}
                        
                    } else {
                        
                        if indexPath.section == Activities.today { activity = self.todaysEvents[indexPath.row].activity! }
                        else if indexPath.section == Activities.thisWeek { activity = self.thisWeeksEvents[indexPath.row].activity! }
                        else if indexPath.section == Activities.upcoming { activity = self.upcomingEvents[indexPath.row].activity!  }
                        else { activity = self.pastDueEvents[indexPath.row].activity!}
                    }
               
                    let coreDataIndex = self.parentController!.contactController.coreData!.activityIndex(activity: activity!)
                    self.parentController!.contactController.coreData!.activities!.remove(at: coreDataIndex!)
                    
                    GlobalData.shared.viewContext.delete(activity!)
                    GlobalData.shared.saveCoreData()
              
                    self.setupView()
                }
            }
        }
    }
}

// MARK: - PICKER DELGATE PROTOCOL
extension ActivityListView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView,  rowHeightForComponent component: Int) -> CGFloat { return 30 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return pickerTitles.count }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return pickerTitles[row] }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard row != 0 else { reAssignTask = false; return }
        
        switch row {
            
            case 1: selectedAssignment = .today
            case 2: selectedAssignment = .thisweek
            case 3: selectedAssignment = .upcoming
      
            default: break
        }
        
        reAssignTask = true
    }
}

// MARK: - ACTIVITY TABLE CELL DELEGATE PROTOCOL
extension ActivityListView: ActivityTableCellDelegate {
 
    func activityDescriptionWasChanged(activity: Activity) { }
  
    func activityWasSelected(activity: Activity) {
        
        activity.isCompleted = true
        setupView()
    }
    
    func activityWasDeselected(activity: Activity) {
        
        activity.isCompleted = false
        setupView()
    }
    
    func onDetailsButton(indexPath: IndexPath) {
        
        if activityTypeSegmentControl.selectedSegmentIndex == 0 {
            
            switch indexPath.section {
                
                case 0:
                    parentController!.activityController.taskDetailsView.setActivity(activity: todaysTasks[indexPath.row].activity)
                    
                case 1:
                    parentController!.activityController.taskDetailsView.setActivity(activity: thisWeeksTasks[indexPath.row].activity)
                    
                case 2:
                    parentController!.activityController.taskDetailsView.setActivity(activity: upcomingTasks[indexPath.row].activity)
               
                default: break
                
            }
            
        } else {
            
            switch indexPath.section {
                
                case 0:
                    parentController!.activityController.taskDetailsView.setActivity(activity: todaysEvents[indexPath.row].activity)
                    
                case 1:
                    parentController!.activityController.taskDetailsView.setActivity(activity: thisWeeksEvents[indexPath.row].activity)
                    
                case 2:
                    parentController!.activityController.taskDetailsView.setActivity(activity: upcomingEvents[indexPath.row].activity)
               
                default: break
                
            }
        }
            
        parentController!.activityController.taskDetailsView.showView(withTabBar: false)
    }
}

//
//  ParentActivityListView.swift
//  InView
//
//  Created by Roger Vogel on 11/7/22.
//

import UIKit
import CustomControls
import Extensions
import DateManager
import AlertManager

class ParentActivityListView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    var theTitleLabel: UILabel!
    var theActivityTableView: UITableView!
    var theRecordCountLabel: UILabel!
    var theActivityTypeSegmentControl: UISegmentedControl!
    var theMoveButton: UIButton!
    var theEditButton: UIButton!
    var thePlusButton: UIButton!
    
    // MARK: - PROPERTIES
    var isEditMode = false
    
    var theContact: Contact?
    var theCompany: Company?
    var theProject: Project?
    var theActivities = [Activity]()
    
    var sectionTitles = ["Past Due", "Today","This Week","Upcoming"]
    var filteredActivities: [Activity]?
 
    var todaysEvents = [ActivityElement]()
    var thisWeeksEvents = [ActivityElement]()
    var upcomingEvents = [ActivityElement]()
    var pastDueEvents = [ActivityElement]()
    
    var todaysTasks = [ActivityElement]()
    var thisWeeksTasks = [ActivityElement]()
    var upcomingTasks = [ActivityElement]()
    var pastDueTasks = [ActivityElement]()
    
    var completedActivites = [ActivityElement]()

    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
       
        theActivityTableView.delegate = self
        theActivityTableView.dataSource = self
        theActivityTableView.sectionHeaderTopPadding = 20
        theActivityTableView.allowsSelection = true
        theActivityTableView.separatorColor = .clear
        
        super.initView(inController: inController)
    }
    
    // MARK: - METHODS
    func setActivities() {
        
        guard filteredActivities != nil else { return }
        guard !filteredActivities!.isEmpty else {
            
            theMoveButton.isEnabled = false
            theEditButton.isEnabled = false
            
            return
        }
            
        // Reset all containers
        todaysTasks.removeAll()
        thisWeeksTasks.removeAll()
        upcomingTasks.removeAll()
        pastDueTasks.removeAll()
        todaysEvents.removeAll()
        thisWeeksEvents.removeAll()
        upcomingEvents.removeAll()
        pastDueEvents.removeAll()
        completedActivites.removeAll()
        
        theMoveButton.isEnabled = true
        theEditButton.isEnabled = true
        
        for activity in filteredActivities! {
            
            let theActivityDate = DateManager(date: activity.activityDate!)
            
            if activity.isTask {
                
                if activity.isCompleted {completedActivites.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isPast { pastDueTasks.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isToday { todaysTasks.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isThisWeek { thisWeeksTasks.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isUpcoming { upcomingTasks.append(ActivityElement(activity: activity, isSelected: false)) }
                
            } else {
                
                if activity.isCompleted {completedActivites.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isPast { pastDueEvents.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isToday { todaysEvents.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isThisWeek { thisWeeksEvents.append(ActivityElement(activity: activity, isSelected: false)) }
                else if theActivityDate.isUpcoming { upcomingEvents.append(ActivityElement(activity: activity, isSelected: false)) }
            }
        }
        
        setRecordCount()
        theActivityTableView.reloadData()
    }
    
    func setContact(_ contact: Contact) {
        
        theContact = contact
        
        theTitleLabel.text = "Activities Attached to This Person"
        theTitleLabel.shrinkWrap()
        
        filteredActivities = parentController!.contactController.coreData!.activities!.filter { $0.contacts!.contains(theContact!) }
        setActivities()
    }
    
    func setCompany(_ company: Company? = nil) {
        
        theCompany = company!
        
        theTitleLabel.text = "Activities Attached to This Company"
        theTitleLabel.shrinkWrap()
        
        filteredActivities = parentController!.contactController.coreData!.activities!.filter { $0.companies!.contains(theCompany!) }
        setActivities()
    }
    
    func setProject(_ project: Project? = nil) {
        
        theProject = project!
        
        theTitleLabel.text = "Activities Attached to This Project"
        theTitleLabel.shrinkWrap()
        
        filteredActivities = parentController!.contactController.coreData!.activities!.filter { $0.projects!.contains(theProject!) }
        setActivities()
    }
    
    func setRecordCount() {
        
        let description = theActivities.count == 1 ? "Activity" : "Activities"
        theRecordCountLabel.text = String(format: "%d " + description, pastDueTasks.count + todaysTasks.count + thisWeeksTasks.count + upcomingTasks.count )
    }
    
    func onDeleteSwipe(indexPath: IndexPath) -> UIContextualAction {
        
        let contextualAction = UIContextualAction(style: .normal, title: "Delete", handler: { (contextualAction: UIContextualAction, swipeButton: UIView, completionHandler: (Bool) -> Void) in
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Delete Activity", aMessage: "Are you sure you want to delete this activity?", buttonTitles: ["CANCEL","DELETE"], theStyle: [.cancel,.destructive], theType: .actionSheet) { choice in
                
                if choice == 1 {
                    
                    var activity: Activity?
                    
                    if self.theActivityTypeSegmentControl.selectedSegmentIndex == 0 {
                        
                        if indexPath.section == Activities.today { activity = self.todaysTasks[indexPath.row].activity! }
                        else if indexPath.section == Activities.thisWeek { activity = self.thisWeeksTasks[indexPath.row].activity! }
                        else if indexPath.section == Activities.upcoming { activity = self.upcomingTasks[indexPath.row].activity!  }
                        else { activity = self.pastDueTasks[indexPath.row].activity! }
                        
                    } else {
                        
                        if indexPath.section == Activities.today { activity = self.todaysEvents[indexPath.row].activity! }
                        else if indexPath.section == Activities.thisWeek { activity = self.thisWeeksEvents[indexPath.row].activity! }
                        else if indexPath.section == Activities.upcoming { activity = self.upcomingEvents[indexPath.row].activity!  }
                        else { activity = self.pastDueEvents[indexPath.row].activity! }
                        
                    }
               
                    let coreDataIndex = self.parentController!.contactController.coreData!.activityIndex(activity: activity!)
                    self.parentController!.contactController.coreData!.activities!.remove(at: coreDataIndex!)
                    
                    GlobalData.shared.viewContext.delete(activity!)
                    GlobalData.shared.saveCoreData()
              
                    self.setActivities()
                }
            }
        })
        
        contextualAction.backgroundColor = .red
        return contextualAction
    }
    
    func onDetailsSwipe(activity: Activity) -> UIContextualAction {
        
        let contextualAction = UIContextualAction(style: .normal, title: "Details", handler: { (contextualAction: UIContextualAction, swipeButton: UIView, completionHandler: (Bool) -> Void) in
            
            let fromTab: Int?
            
            if self.isEditMode { self.enableEditMode() }
      
            if self.theContact != nil { fromTab = Tabs.contacts }
            else if self.theCompany != nil { fromTab = Tabs.companies }
            else { fromTab = Tabs.projects }
            
            if activity.isTask {
                
                if self.parentController!.activityController.taskDetailsView.parentController == nil {
                    self.parentController!.activityController.taskDetailsView.initView(inController: self.parentController!.activityController)
                }
    
                self.parentController!.activityController.taskDetailsView.fromTab = fromTab
                self.parentController!.activityController.taskDetailsView.setActivity(activity: activity)
                self.parentController!.gotoTab(Tabs.activites, showingView: self.parentController!.activityController.taskDetailsView, fade: false, withTabBar: false)
                
            } else if activity.isEvent {
                
                if self.parentController!.activityController.eventDetailsView.parentController == nil {
                    self.parentController!.activityController.eventDetailsView.initView(inController: self.parentController!.activityController)
                }
                
                self.parentController!.activityController.eventDetailsView.fromTab = fromTab
                self.parentController!.activityController.eventDetailsView.setActivity(activity: activity)
                self.parentController!.gotoTab(Tabs.activites, showingView: self.parentController!.activityController.eventDetailsView, fade: false, withTabBar: false)
            }
            
            return completionHandler(true)
        })
        
        contextualAction.backgroundColor = ThemeColors.teal.uicolor
        return contextualAction
    }
    
    func addActivity() {
        
        let fromTab: Int?
        
        if self.isEditMode { self.enableEditMode() }
  
        if self.theContact != nil { fromTab = Tabs.contacts }
        else if self.theCompany != nil { fromTab = Tabs.companies }
        else { fromTab = Tabs.projects }
        
        if theActivityTypeSegmentControl.selectedSegmentIndex == 0 {
            
            if self.parentController!.activityController.taskDetailsView.parentController == nil {
                self.parentController!.activityController.taskDetailsView.initView(inController: self.parentController!.activityController)
            }

            self.parentController!.activityController.taskDetailsView.fromTab = fromTab
            self.parentController!.activityController.taskDetailsView.setActivity(forContact: theContact, forCompany: theCompany, forProject: theProject)
            self.parentController!.gotoTab(Tabs.activites, showingView: self.parentController!.activityController.taskDetailsView, fade: false, withTabBar: false)
            
        } else {
            
            if self.parentController!.activityController.eventDetailsView.parentController == nil {
                self.parentController!.activityController.eventDetailsView.initView(inController: self.parentController!.activityController)
            }

            self.parentController!.activityController.eventDetailsView.fromTab = fromTab
            self.parentController!.activityController.eventDetailsView.setActivity(forContact: theContact, forCompany: theCompany, forProject: theProject)
            self.parentController!.gotoTab(Tabs.activites, showingView: self.parentController!.activityController.eventDetailsView, fade: false, withTabBar: false)
            
        }
    }
    
    func enableEditMode(force: Bool? = nil) {
        
        if force != nil { isEditMode = force! }
        else { isEditMode = !isEditMode }
        
        theEditButton.tintColor = isEditMode ? ThemeColors.darkGray.uicolor : .white
        theActivityTableView.reloadData()
    }
    
    func enableControls(_ state: Bool) {
        
        theMoveButton.isEnabled = state
        thePlusButton.isEnabled = state
    }
    
    func clear() {
        
        theContact = nil
        theCompany = nil
        theProject = nil
    }
    
    func setReturnTab(forView: ParentView) { /* Placeholder */ }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ParentActivityListView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if theActivityTypeSegmentControl.selectedSegmentIndex == 2 { return 1 }
        else { return sectionTitles.count }
    }
        
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if theActivityTypeSegmentControl.selectedSegmentIndex == 0 {
           
            switch section {
                
                case Activities.today: return todaysTasks.count
                case Activities.thisWeek: return thisWeeksTasks.count
                case Activities.upcoming: return upcomingTasks.count
                case Activities.pastDue: return pastDueTasks.count
              
                default: return 0
            }
            
        } else if theActivityTypeSegmentControl.selectedSegmentIndex == 1 {
            
            switch section {
                
                case Activities.today: return todaysEvents.count
                case Activities.thisWeek: return thisWeeksEvents.count
                case Activities.upcoming: return upcomingEvents.count
                case Activities.pastDue: return pastDueEvents.count
               
                default: return 0
            }
            
        } else { return completedActivites.count }
    }
  
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 30 }

    // View for headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard !sectionTitles.isEmpty else { return nil }
        guard theActivityTypeSegmentControl.selectedSegmentIndex != 2 else { return nil }
         
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
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var activityElement: ActivityElement?
        let activityCell = tableView.dequeueReusableCell(withIdentifier: "entityActivityListStyle", for: indexPath) as? EntityActivityListCell
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .clear
        activityCell!.selectedBackgroundView = selectedBackgroundView
        
     //   tableView.deselectRow(at: indexPath, animated: false)
        
        if theActivityTypeSegmentControl.selectedSegmentIndex == 0 {
            
            if indexPath.section == Activities.today { activityElement = todaysTasks[indexPath.row] }
            else if indexPath.section == Activities.thisWeek { activityElement = thisWeeksTasks[indexPath.row] }
            else if indexPath.section == Activities.upcoming{ activityElement = upcomingTasks[indexPath.row] }
            else if indexPath.section == Activities.pastDue { activityElement = pastDueTasks[indexPath.row] }
            
        } else if theActivityTypeSegmentControl.selectedSegmentIndex == 1 {
            
            if indexPath.section == Activities.today { activityElement = todaysEvents[indexPath.row] }
            else if indexPath.section == Activities.thisWeek { activityElement = thisWeeksEvents[indexPath.row] }
            else if indexPath.section == Activities.upcoming{ activityElement = upcomingEvents[indexPath.row] }
            else if indexPath.section == Activities.pastDue{ activityElement = pastDueEvents[indexPath.row] }
            
        } else { activityElement = completedActivites[indexPath.row] }
         
        activityCell!.activityDescriptionTextField.text = activityElement!.activity!.activityDescription!
        activityCell!.checkButton.setState(activityElement!.activity!.isCompleted)
        activityCell!.myIndexPath = indexPath
        activityCell!.theActivity = activityElement!.activity
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
        
        let cell = tableView.cellForRow(at: indexPath) as? EntityActivityListCell
        
        if theActivityTypeSegmentControl!.selectedSegmentIndex == 0 {
            
            let detailsView = parentController!.activityController.taskDetailsView!
            
            if !detailsView.initIsComplete { detailsView.initView(inController: parentController!.activityController)}
            detailsView.setActivity(activity: cell!.theActivity, forContact: theContact, forCompany: theCompany, forProject: theProject)
           
            if theContact != nil { detailsView.fromTab = Tabs.contacts }
            else if theCompany != nil { detailsView.fromTab = Tabs.companies}
            else { detailsView.fromTab = Tabs.projects}
            
            parentController!.gotoTab(Tabs.activites, showingView: detailsView, withTabBar: false)

        } else {
            
            let detailsView = parentController!.activityController.eventDetailsView!
            
            if !detailsView.initIsComplete { detailsView.initView(inController: parentController!.activityController)}
            detailsView.setActivity(activity: cell!.theActivity, forContact: theContact, forCompany: theCompany, forProject: theProject)
            
            if theContact != nil { detailsView.fromTab = Tabs.contacts }
            else if theCompany != nil { detailsView.fromTab = Tabs.companies}
            else { detailsView.fromTab = Tabs.projects}
            
            parentController!.gotoTab(Tabs.activites, showingView: detailsView, withTabBar: false)
        }
    }
    
    // Capture deselection
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        

    }
    
    // Allow row move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return false }

    // Allows editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
        
    // Delete activity
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
//        if editingStyle == .delete {
//
//            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Delete Activity", aMessage: "Are you sure you want to delete this activity?", buttonTitles: ["CANCEL","DELETE"], theStyle: [.cancel,.destructive], theType: .actionSheet) { choice in
//
//                if choice == 1 {
//
//                    let activity = (tableView.cellForRow(at: indexPath) as! ActivityListCell).theActivity!
//                    let index = self.parentController!.contactController.coreData!.activityIndex(activity: activity)
//                    self.parentController!.contactController.coreData!.activities!.remove(at: index!)
//
//                    GlobalData.shared.viewContext.delete(activity)
//                    GlobalData.shared.saveCoreData()
//
//                    if self.parentController!.contactController.coreData!.activities!.isEmpty && self.activityAndEventTableView.isEditing { self.onEditMode(self.editModeButton) }
//                    self.setupList()
//                }
//            }
//        }
    }
}

// MARK: - ACTIVITY TABLE CELL DELEGATE PROTOCOL
extension ParentActivityListView: ActivityTableCellDelegate {
   
    func activityDescriptionWasChanged(activity: Activity) {
        
        let activityIndex = parentController!.contactController.coreData!.activityIndex(activity: activity)
        parentController!.contactController.coreData!.activities![activityIndex!].activityDescription = activity.activityDescription

        GlobalData.shared.saveCoreData()
    }

    func activityWasSelected(activity: Activity) {
        
        activity.isCompleted = true
        
        if theContact != nil { setContact(theContact!) }
        else if theCompany != nil { setCompany(theCompany) }
        else { setProject(theProject) }
    }
    
    func activityWasDeselected(activity: Activity) {
        
        activity.isCompleted = false
        
        if theContact != nil { setContact(theContact!) }
        else if theCompany != nil { setCompany(theCompany) }
        else { setProject(theProject) }
    }
    
    func onDetailsButton(indexPath: IndexPath) { }
}


/*
 
 let taskCount =  pastDueTasks.count + todaysTasks.count + thisWeeksTasks.count + upcomingTasks.count
 let eventCount = pastDueEvents.count + todaysEvents.count + thisWeeksEvents.count + upcomingEvents.count
 
 if taskCount > 0 { theActivityTypeSegmentControl.selectedSegmentIndex = 0 }
 else if taskCount == 0 && eventCount > 0 { theActivityTypeSegmentControl.selectedSegmentIndex = 1 }
 else if eventCount == 0 { theActivityTypeSegmentControl.selectedSegmentIndex = 0 }
 */

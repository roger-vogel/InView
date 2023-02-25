//
//  ActivityCalendarView.swift
//  InView
//
//  Created by Roger Vogel on 10/24/22.
//

import UIKit
import DateManager

class ActivityCalendarView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var calendarTableView: UITableView!
    
    // MARK: - PROPERTIES
    var theActivities = [Activity]()
   
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
    
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        
        calendarTableView.roundAllCorners(value: 5)
        calendarTableView.sectionHeaderTopPadding = 20
        calendarTableView.allowsMultipleSelection = true
        calendarTableView.separatorStyle =  .singleLine
        calendarTableView.separatorColor = ThemeColors.deepAqua.uicolor
        calendarTableView.allowsSelection = true
      
        super.initView(inController: inController)
    }
    
    override func setupView() { getActivitiesForDate(date: datePicker.date) }

    // MARK: - METHODS
    func getActivitiesForDate(date: Date) {
        
        theActivities.removeAll()
        
        for activity in parentController!.contactController.coreData!.activities! {
            
            let activityDateManager = DateManager(date: activity.activityDate)
            let calendarDateManager = DateManager(date: date)
        
            // If the activity occurs daily, add it
            if activity.frequency == "daily" { theActivities.append(activity) }
        
            // If the activity is on this date, add it
            else if activityDateManager.isSameDay(comparing: calendarDateManager) { theActivities.append(activity) }
            
            // If the activity is weekly and this is the day of the week, add it
            else if activity.frequency == "weekly" && activityDateManager.dayOfWeek == calendarDateManager.dayOfWeek { theActivities.append(activity) }
                
            // If the activity is monthly and this is the same day of month, add it
            else if activity.frequency == "monthly" && activityDateManager.dateComponents.day! == calendarDateManager.dateComponents.day! { theActivities.append(activity) }
         
            // If the repeats annually and this is the same day of the year, add it
            else if activity.frequency == "annually" {
                
                if activityDateManager.dateComponents.month! == calendarDateManager.dateComponents.month! &&
                   activityDateManager.dateComponents.day! == calendarDateManager.dateComponents.day! { theActivities.append(activity) }
            }
         
            // Else if the activity occurs on certain days of the week, add if it matches calendar date day of week
            else if activity.daysOfWeek!.containsSubstring(string: DateManager(date: date).dayOfWeekString.lowercased()) { theActivities.append(activity) }
                
            // Else if activity reoccures on days of month and calendar date is day of month, add it
            else if activity.daysOfMonth!.containsSubstring(string: DateManager(date: date).dayOfMonthNumberString) { theActivities.append(activity) }
        }
        
        calendarTableView.reloadData()
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onDateChange(_ sender: Any) { getActivitiesForDate(date: datePicker.date) }
  
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.activityController.activityListView.showView(withTabBar: false)
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ActivityCalendarView: UITableViewDelegate, UITableViewDataSource {
 
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return theActivities.count  }
          
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 43.5 }

    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }

    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCalendarStyle", for: indexPath) as! CalendarListCell
        let activity = theActivities[indexPath.row]
     

        cell.typeTextField.text = activity.isTask ? "Task" : "Event"
        
        if activity.isEvent { cell.timeTextField.text = DateManager(date: activity.activityDate).timeString }
        else { cell.timeTextField.text = "" }
        
        cell.nameTextField.text = activity.activityDescription
        
        return cell
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let activity = theActivities[indexPath.row]
        
        if activity.isTask {
            
            let detailsView = parentController!.activityController.taskDetailsView
            
            detailsView!.returnToCalendar = true
            detailsView!.setActivity(activity: activity)
            detailsView!.showView()
            
        } else {
            
            let detailsView = parentController!.activityController.eventDetailsView
            
            detailsView!.returnToCalendar = true
            detailsView!.setActivity(activity: activity)
            detailsView!.showView()
        }
    }
    
    // Allow row move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return false }

    // Allows editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
}

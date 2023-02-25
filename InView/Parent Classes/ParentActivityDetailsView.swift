//
//  ActivityDetailsView.swift
//  InView
//
//  Created by Roger Vogel on 1/7/23.
//

import UIKit
import ColorManager
import DateManager
import AlertManager
import ToggleGroup

class ParentActivityDetailsView: ParentView {
    
    // MARK: - PROPERTIES
    var theActivityNameLabel: UILabel?
    var theActivityDateTextField: UITextField?
    var theTaskTextView: UITextView?
    var theEventNameTextField: UITextField?
    var theEventLocationTextField: UITextField?
    
    var theTodayButton: ToggleButton?
    var theThisWeekButton: ToggleButton?
    var theUpcomingButton: ToggleButton?
    
    var theDatePicker: UIDatePicker?
    
    var theDailyCheckButton: ToggleButton?
    var theWeeklyCheckButton: ToggleButton?
    var theMonthlyCheckButton: ToggleButton?
    var theAnnualCheckButton: ToggleButton?
    
    var theSunButton: ToggleButton?
    var theMonButton: ToggleButton?
    var theTueButton: ToggleButton?
    var theWedButton: ToggleButton?
    var theThuButton: ToggleButton?
    var theFriButton: ToggleButton?
    var theSatButton: ToggleButton?
    var theCalendarView: ParentCalendarView?
    
    var theStartTimePicker: UIDatePicker?
    var theEndTimePicker: UIDatePicker?
    var theAllDaySwitch: UISwitch?
    
    var theAttachToLabel: UILabel?
    var theRecurringTaskLabelTopConstraint: NSLayoutConstraint?
    
    var theAttachToView: UIView?
    var theOccursOnceView: UIView?
    var theReoccursWeeklyView: UIView?
    var theReoccursMonthlyView: UIView?
    
    var theActivity: Activity?
    var aNewActivity: Activity?
    var activityType: ActivityType?
    var activityDate = Date()
    var frequencyButtons: [ToggleButton]?
    var calendarButtons: [ToggleButton]?
    var toolBar = Toolbar()
    var selectedContacts = [Contact]()
    var selectedCompanies = [Company]()
    var selectedProjects = [Project]()
    var frequencyGroup = ButtonGroupView()
    var dayOfWeekGroup = ButtonGroupView()
    
    var forContact: Contact?
    var forCompany: Company?
    var forProject: Project?

    var isNew: Bool = false
    var hasChanged: Bool?
    var fromTab: Int?
    var standardTopConstraint: CGFloat?
    
    var selectedDates: [Int] { return theCalendarView!.selectedDates }
    var selectedDateString: String {
        
        var dateString = ""
        
        for date in theCalendarView!.selectedDates { dateString += (String(date) + "|") }
        return dateString
    }
    var returnToCalendar: Bool = false
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        super.initView(inController: inController)
    
        standardTopConstraint = theRecurringTaskLabelTopConstraint!.constant
       
        // Initialize the calendar
        theCalendarView!.delegate = self
        theCalendarView!.initCalendar()
        theCalendarView!.roundAllCorners(value: 5)
       
        // Create the weekday borders
        theSunButton!.addRightBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        theMonButton!.addRightBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        theTueButton!.addRightBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        theWedButton!.addRightBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        theThuButton!.addRightBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        theFriButton!.addRightBorder(with: ThemeColors.teal.uicolor, andWidth: 1.0)
        
        // Create the button groups
        frequencyGroup.setGroup(toggleGroup: [theDailyCheckButton!,theWeeklyCheckButton!,theMonthlyCheckButton!,theAnnualCheckButton!], radioType: .unlocked)
        frequencyGroup.initToggleButtons(isCheckBox: true, withTint: .white)
    
        dayOfWeekGroup.setGroup(toggleGroup: [theSunButton!,theMonButton!,theTueButton!,theWedButton!,theThuButton!,theFriButton!,theSatButton!], radioType: .open)
        dayOfWeekGroup.initToggleButtons(toggleColors: ToggleColors(selectedForeground: ThemeColors.aqua.uicolor, selectedBackground: ColorManager(grayScalePercent: 85).uicolor, unselectedForeground: ThemeColors.aqua.uicolor, unselectedBackground: .white))
        
        // Unique to task
        if activityType == .task {
            
            toolBar.setup(parent: self)
            
            theTaskTextView!.inputAccessoryView = toolBar
            theTaskTextView!.roundAllCorners(value: 5.0)
        }
     
        theOccursOnceView!.roundAllCorners(value: 5)
        theReoccursWeeklyView!.roundAllCorners(value: 5)
        theReoccursMonthlyView!.roundAllCorners(value: 5)
    }
   
    func setActivity(activity: Activity? = nil, forContact: Contact? = nil, forCompany: Company? = nil, forProject: Project? = nil) {
        
        hasChanged = false
        
        self.forContact = forContact
        self.forCompany = forCompany
        self.forProject = forProject
        
        clearAll()
        theActivity = activity
        
        theDatePicker!.minimumDate = Date()
        
        if fromTab == Tabs.activites {
            
            theAttachToLabel!.isHidden = false
            theAttachToView!.isHidden = false
            theRecurringTaskLabelTopConstraint!.constant = standardTopConstraint!
            
        }  else {
            
            theAttachToLabel!.isHidden = true
            theAttachToView!.isHidden = true
            theRecurringTaskLabelTopConstraint!.constant = standardTopConstraint! - 70
        }
       
        if activity != nil {
            
            isNew = false
            
            // Task unique fields
            if activityType == .task {
                
                theActivityNameLabel!.text = "View/Edit Task"
                theTaskTextView!.text = activity!.activityDescription!
              
                if activity!.activityDate != nil {
                    
                    if DateManager(date: activityDate).isPast { theDatePicker!.date = Date() }
                    else { theDatePicker!.date = activity!.activityDate! }
                
                    activityDate = activity!.activityDate!
                    
                    let dateManager = DateManager(date: activity!.activityDate!)
                    
                    if dateManager.isToday { theTodayButton!.setState(true) }
                    else { theTodayButton?.setState(false) }
                    
                    theActivityDateTextField!.text = dateManager.shortDateString
                    
                    if DateManager(date: activity!.activityDate!).isToday { theTodayButton!.setState(true) }
                    
                } else { theDatePicker!.date = Date() }
                
                selectedContacts = parentController!.contactController.coreData!.setToArray(contacts: activity!.contacts!)
                selectedCompanies = parentController!.contactController.coreData!.setToArray(companies: activity!.companies!)
                selectedProjects = parentController!.contactController.coreData!.setToArray(projects: activity!.projects!)
            
            // Event unique fields
            } else {
                
                theActivityNameLabel!.text = "View/Edit Event"
                theEventNameTextField!.text = activity!.activityDescription!
                theEventLocationTextField!.text = activity!.location!
                theDatePicker!.date = activity!.activityDate!
                theStartTimePicker!.date = activity!.activityStartTime!
                theEndTimePicker!.date = activity!.activityEndTime!
                theAllDaySwitch!.isOn = activity!.isAllDay
                
                if theAllDaySwitch!.isOn {
                    
                    theStartTimePicker!.isEnabled = false
                    theStartTimePicker!.alpha = 0.30
                    
                    theEndTimePicker!.isEnabled = false
                    theEndTimePicker!.alpha = 0.30
                
                } else {
                    
                    theStartTimePicker!.isEnabled = true
                    theStartTimePicker!.alpha = 1.0
                    
                    theEndTimePicker!.isEnabled = true
                    theEndTimePicker!.alpha = 1.0
                }
            }
           
            // Set the frequency buttons
            if !theActivity!.frequency!.isEmpty {
                
                switch theActivity!.frequency! {
                    
                    case "daily": frequencyGroup.setSelection(theDailyCheckButton!)
                    case "weekly": frequencyGroup.setSelection(theWeeklyCheckButton!)
                    case "monthly": frequencyGroup.setSelection(theMonthlyCheckButton!)
                    case "annually": frequencyGroup.setSelection(theAnnualCheckButton!)
                        
                    default: break
                }
                
            // Set the day of week buttons
            } else if !theActivity!.daysOfWeek!.isEmpty {
                
                dayOfWeekGroup.clear()
                
                let daysOfWeek = theActivity!.daysOfWeek!.split(separator: "|")
                for day in daysOfWeek {
                    
                    switch day {
                        
                        case "sun": dayOfWeekGroup.setSelection(theSunButton!)
                        case "mon": dayOfWeekGroup.setSelection(theMonButton!)
                        case "tue": dayOfWeekGroup.setSelection(theTueButton!)
                        case "wed": dayOfWeekGroup.setSelection(theWedButton!)
                        case "thu": dayOfWeekGroup.setSelection(theThuButton!)
                        case "fri": dayOfWeekGroup.setSelection(theFriButton!)
                        case "sat": dayOfWeekGroup.setSelection(theSatButton!)
                            
                        default: break
                    }
                }
                
            } else if !theActivity!.daysOfMonth!.isEmpty {
                
                // Set the day of month buttons
                let daysOfMonth = theActivity!.daysOfMonth!.split(separator: "|")
                theCalendarView!.setCalendar(setToTrue: daysOfMonth)
            }
          
        } else {
            
            isNew = true
            
            aNewActivity = Activity(context: GlobalData.shared.viewContext)
            aNewActivity!.id = UUID()
            aNewActivity!.appId = UUID().description
            aNewActivity!.timestamp = Date()
            
            if activityType == .task {
                
                aNewActivity!.isTask = true
                aNewActivity!.isEvent = false
                
                theActivityNameLabel!.text = "Create New Task"
                theDatePicker!.date = Date()
                activityDate = theDatePicker!.date
                theActivityDateTextField!.text!.removeAll()
                theTodayButton!.setState(false)
                
            } else {
                
                aNewActivity!.isTask = false
                aNewActivity!.isEvent = true
                
                theActivityNameLabel!.text = "Create New Event"
           
                theDatePicker!.date = Date()
                theStartTimePicker!.date = Date()
                theEndTimePicker!.date = theStartTimePicker!.date.addingTimeInterval(TimeInterval(1800))
                theAllDaySwitch!.isOn = false
               
                activityDate = theDatePicker!.date
                enableDatePicker(theDatePicker!, state: true)
            }
        }
        
        setRecurringOptions()
    }
    
    // MARK: - METHODS
    func setRecurringOptions() {
        
        if frequencyGroup.toggledRadioButton != nil {
            
            frequencyGroup.enableGroup(true)
            dayOfWeekGroup.enableGroup(false)
            theCalendarView!.enableCalendar(false)
            
        } else if !dayOfWeekGroup.toggledButtons.isEmpty {
            
            frequencyGroup.enableGroup(false)
            dayOfWeekGroup.enableGroup(true)
            theCalendarView!.enableCalendar(false)
            
        } else if !theCalendarView!.selectedDates.isEmpty {
            
            frequencyGroup.enableGroup(false)
            dayOfWeekGroup.enableGroup(false)
            theCalendarView!.enableCalendar(true)
            
        } else {
            
            frequencyGroup.enableGroup(true)
            dayOfWeekGroup.enableGroup(true)
            theCalendarView!.enableCalendar(true)
        }
    }
    
    func enableDatePicker(_ picker: UIDatePicker, state: Bool) {
        
        picker.isEnabled = state
        
        if state { picker.alpha = 1.0 }
        else { picker.alpha = 0.30 }
    }
    
    // MARK: - ACTION HANDLERS
    func attachPeople() {
        
        dismissKeyboard()
        hasChanged = true
        
        if isNew {  parentController!.activityController.activityContactSelectionView.theActivity = aNewActivity }
        else { parentController!.activityController.activityContactSelectionView.theActivity = theActivity }
    
        parentController!.activityController.activityContactSelectionView.loadView(contacts: selectedContacts, activityType: activityType)
        parentController!.activityController.activityContactSelectionView.showView(withTabBar: false)
    }
    
    func attachCompanies() {
        
        dismissKeyboard()
        hasChanged = true
        
        if isNew { parentController!.activityController.activityCompanySelectionView.theActivity = aNewActivity }
        else { parentController!.activityController.activityCompanySelectionView.theActivity = theActivity }
      
        parentController!.activityController.activityCompanySelectionView.loadView(companies: selectedCompanies, activityType: activityType)
        parentController!.activityController.activityCompanySelectionView.showView(withTabBar: false)
    }
    
    func attachProjects() {
        
        dismissKeyboard()
        hasChanged = true
        
        if isNew { parentController!.activityController.activityProjectSelectionView.theActivity = aNewActivity }
        else { parentController!.activityController.activityProjectSelectionView.theActivity = theActivity }
      
        parentController!.activityController.activityProjectSelectionView.loadView(projects: selectedProjects, activityType: activityType)
        parentController!.activityController.activityProjectSelectionView.showView(withTabBar: false)
    }
    
    func saveNewActivity() {
    
        if selectedContacts.count > 0 { for contact in selectedContacts { aNewActivity!.addToContacts(contact) } }
        if selectedCompanies.count > 0 { for company in selectedCompanies { aNewActivity!.addToCompanies(company) } }
        if selectedProjects.count > 0 { for project in selectedProjects { aNewActivity!.addToProjects(project) } }
        
        // Unique to task
        if activityType == .task {
            
            aNewActivity!.activityDescription = theTaskTextView!.text!
            aNewActivity!.activityDate = activityDate
            aNewActivity!.isTask = true
            aNewActivity!.isEvent = false
        }
        
        // Unique to event
        else {
            
            aNewActivity!.activityDescription = theEventNameTextField!.text!
            
            aNewActivity!.activityDate = activityDate
            aNewActivity!.activityStartTime = theStartTimePicker!.date
            aNewActivity!.activityEndTime = theEndTimePicker!.date
            aNewActivity!.isAllDay = theAllDaySwitch!.isOn
            aNewActivity!.isEvent = true
            aNewActivity!.isTask = false
        }
        
        // Save frequency
        if frequencyGroup.toggledRadioButton != nil {
            
            switch frequencyGroup.toggledRadioButton {
                
                case theDailyCheckButton!: aNewActivity!.frequency = "daily"
                case theWeeklyCheckButton!: aNewActivity!.frequency = "weekly"
                case theMonthlyCheckButton!: aNewActivity!.frequency = "monthly"
                case theAnnualCheckButton!: aNewActivity!.frequency = "annually"
                    
                default: break
            }
        }
        
        // Save day of week
        if !dayOfWeekGroup.toggledButtons.isEmpty {
            
            for button in dayOfWeekGroup.toggledButtons {
                
                switch button {
                    
                    case theSunButton: aNewActivity!.daysOfWeek! += "sun|"
                    case theMonButton: aNewActivity!.daysOfWeek! += "mon|"
                    case theTueButton: aNewActivity!.daysOfWeek! += "tue|"
                    case theWedButton: aNewActivity!.daysOfWeek! += "wed|"
                    case theThuButton: aNewActivity!.daysOfWeek! += "thu|"
                    case theFriButton: aNewActivity!.daysOfWeek! += "fri|"
                    case theSatButton: aNewActivity!.daysOfWeek! += "sat|"
                        
                    default: break
                }
            }
        }
        
        // or save calendar
        else {
            
            var dateString = ""
            let selectedDates = theCalendarView!.selectedDates
            
            for date in selectedDates { dateString += ( String(date) + "|") }
            
            aNewActivity!.daysOfMonth = dateString
        }
        
        // If this access was from a contact, company, or project, automatically assign it
        if forContact != nil && !aNewActivity!.contacts!.contains(forContact! as Contact) { aNewActivity!.addToContacts(forContact!)}
        else if forCompany != nil && !aNewActivity!.companies!.contains(forCompany! as Company) { aNewActivity!.addToCompanies(forCompany!)}
        else if forProject != nil && !aNewActivity!.projects!.contains(forProject! as Project) { aNewActivity!.addToProjects(forProject!)}
        
        // Save the data
        GlobalData.shared.saveCoreData()
        parentController!.contactController.coreData!.activities!.append(aNewActivity!)
        
        aNewActivity = nil
        returnToPriorView()
        parentController!.updateActionButtons()
    }
   
    func updateActivity() {
        
        // Clear all attachments
        let activityContacts = parentController!.contactController.coreData!.setToArray(contacts: theActivity!.contacts!)
        for contact in activityContacts { theActivity!.removeFromContacts(contact) }
        
        let activityCompanies = parentController!.contactController.coreData!.setToArray(companies: theActivity!.companies!)
        for company in activityCompanies { theActivity!.removeFromCompanies(company) }
        
        let activityProjects = parentController!.contactController.coreData!.setToArray(projects: theActivity!.projects!)
        for project in activityProjects { theActivity!.removeFromProjects(project) }
        
        // Set new attachments
        if selectedContacts.count > 0 { for contact in selectedContacts { theActivity!.addToContacts(contact) } }
        if selectedCompanies.count > 0 { for company in selectedCompanies { theActivity!.addToCompanies(company) } }
        if selectedProjects.count > 0 { for project in selectedProjects { theActivity!.addToProjects(project) } }
        
        // Unique to task
        if activityType == .task {
            
            theActivity!.activityDescription = theTaskTextView!.text!
            theActivity!.activityDate = activityDate
            theActivity!.isTask = true
        }
        
        // Unique to event
        else {
            
            theActivity!.activityDescription = theEventNameTextField!.text!
            theActivity!.activityDate = activityDate
            theActivity!.activityStartTime = theStartTimePicker!.date
            theActivity!.activityEndTime = theEndTimePicker!.date
            theActivity!.isAllDay = theAllDaySwitch!.isOn
            theActivity!.isEvent = true
        }
        
        // Save frequency
        if frequencyGroup.toggledRadioButton != nil {
            
            switch frequencyGroup.toggledRadioButton {
                
                case theDailyCheckButton!: theActivity!.frequency = "daily"
                case theWeeklyCheckButton!: theActivity!.frequency = "weekly"
                case theMonthlyCheckButton!: theActivity!.frequency = "monthly"
                case theAnnualCheckButton!: theActivity!.frequency = "annually"
                    
                default: break
            }
            
        } else { theActivity!.frequency!.removeAll() }
            
        // Save day of week
        if !dayOfWeekGroup.toggledButtons.isEmpty {
            
            theActivity!.daysOfWeek! = ""
            
            for button in dayOfWeekGroup.toggledButtons {
                
                switch button {
                    
                    case theSunButton!: theActivity!.daysOfWeek! += "sun|"
                    case theMonButton!: theActivity!.daysOfWeek! += "mon|"
                    case theTueButton!: theActivity!.daysOfWeek! += "tue|"
                    case theWedButton!: theActivity!.daysOfWeek! += "wed|"
                    case theThuButton!: theActivity!.daysOfWeek! += "thu|"
                    case theFriButton!: theActivity!.daysOfWeek! += "fri|"
                    case theSatButton!: theActivity!.daysOfWeek! += "sat|"
                        
                    default: break
                }
            }

        }  else { theActivity!.daysOfWeek!.removeAll() }
        
        // Save calendar
        if !theCalendarView!.selectedDates.isEmpty {
            
            var dateString = ""
            let selectedDates = theCalendarView!.selectedDates
            
            for date in selectedDates { dateString += ( String(date) + "|") }
            theActivity!.daysOfMonth = dateString
            
        } else { theActivity!.daysOfMonth!.removeAll() }
        
        GlobalData.shared.saveCoreData()
        returnToPriorView()
        parentController!.updateActionButtons()
    }
    
    func validateActivity() {
        
        dismissKeyboard()
     
        // Task save
        if activityType == .task {
            
            // If task has changed, perform validity checks
            if hasChanged! {
                
                // Date validity check
                if theActivityDateTextField!.text!.isEmpty {
                    
                    AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aMessage: "An undated task can't be saved, do want to return without saving?", buttonTitles: ["YES","NO"], theStyle: [.destructive, .default], theType: .actionSheet) { choice in
                        
                        if choice == 0 { self.aNewActivity = nil; self.returnToPriorView() }
                        else { return }
                    }
                    
                // if Date is good, description validity check
                } else if theTaskTextView!.text.isEmpty {
                    
                    AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aMessage: "A saved task needs a description, do want to return without saving?", buttonTitles: ["YES","NO"], theStyle: [.destructive, .default], theType: .actionSheet) { choice in
                        
                        if choice == 0 { self.aNewActivity = nil; self.returnToPriorView() }
                        else { return }
                    }
                    
                // All is good, we can save
                } else {
                    
                    if isNew { saveNewActivity() }
                    else { updateActivity() }
                }
                
            // No change, just return
            } else { self.returnToPriorView() }
            
        // Event save
        } else {
            
            // Event validity checks
            if hasChanged! {
                
                // Title validity check
                if theEventNameTextField!.text!.isEmpty {
                    
                    AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aMessage: "An untitled event can't be saved, do want to return without saving?", buttonTitles: ["YES","NO"], theStyle: [.destructive, .default], theType: .actionSheet) { choice in
                        
                        if choice == 0 { self.aNewActivity = nil; self.returnToPriorView() }
                        else { return }
                    }
                    
                // All is good, we can save
                } else {
                    
                    if isNew { saveNewActivity() }
                    else { updateActivity() }
                    
                }
                
            } else { returnToPriorView() }
        }
    }
    
    func returnToPriorView() {
        
        dismissKeyboard()
        
        guard !returnToCalendar else {
            
            parentController!.activityController.activityCalendarView.showView()
            returnToCalendar = false
            return
        }
      
        switch fromTab {
            
            case Tabs.contacts:
                parentController!.contactController.contactActivityListView.setContact(forContact!)
                parentController!.gotoTab(Tabs.contacts, showingView: parentController!.contactController.contactActivityListView, fade: false, withTabBar: false)
                
            case Tabs.companies:
                parentController!.companyController.companyActivityListView.setCompany(forCompany!)
                parentController!.gotoTab(Tabs.companies, showingView: parentController!.companyController.companyActivityListView, fade: false, withTabBar: false)
                
            case Tabs.projects:
                parentController!.projectController.projectActivityListView.setProject(forProject!)
                parentController!.gotoTab(Tabs.projects, showingView: parentController!.projectController.projectActivityListView, fade: false, withTabBar: false)
                
            case Tabs.activites:
                parentController!.activityController.activityListView.showView(atCompletion: { self.theScrollView!.scrollsToTop(animated: false) })
                
            default: break
        }
    }
    
    func setFrequency(button: ToggleButton) {
        
        hasChanged = true
        frequencyGroup.toggle(button: button)
        setRecurringOptions()
    }
    
    func setDayofWeek(button: ToggleButton) {
        
        hasChanged = true
        dayOfWeekGroup.toggle(button: button)
        setRecurringOptions()
    }
    
    func clearAll() {
        
        hasChanged = false
        frequencyGroup.clear()
        dayOfWeekGroup.clear()
        theCalendarView!.resetCalendar()
        
        theDatePicker!.date = Date()
        
        if activityType == .task { theTaskTextView!.text!.removeAll() }
        else {
            
            theEventNameTextField!.text!.removeAll()
            theEventLocationTextField!.text!.removeAll()
            theStartTimePicker!.date = Date()
            theEndTimePicker!.date = theStartTimePicker!.date.addingTimeInterval(TimeInterval(1800))
        }
    }
}

// MARK: - CALENDAR VIEW DELEGATE PROTOCOL
extension ParentActivityDetailsView: CalendarViewDelegate {
 
    func dayWasSelected(day: Int) {
        
        hasChanged = true
        setRecurringOptions()
        
    }
   
    func dayWasDeselected(day: Int) {
        
        hasChanged = true
        setRecurringOptions()
        
    }
}

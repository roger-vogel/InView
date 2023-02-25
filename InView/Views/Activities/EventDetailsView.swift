//
//  EventDetailView.swift
//  InView
//
//  Created by Roger Vogel on 1/7/23.
//

import UIKit
import ColorManager
import DateManager
import AlertManager
import ToggleGroup

class EventDetailsView: ParentActivityDetailsView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventLocationTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var dailyCheckButton: ToggleButton!
    @IBOutlet weak var weeklyCheckButton: ToggleButton!
    @IBOutlet weak var monthlyCheckButton: ToggleButton!
    @IBOutlet weak var annualCheckButton: ToggleButton!
    
    @IBOutlet weak var sunButton: ToggleButton!
    @IBOutlet weak var monButton: ToggleButton!
    @IBOutlet weak var tueButton: ToggleButton!
    @IBOutlet weak var wedButton: ToggleButton!
    @IBOutlet weak var thuButton: ToggleButton!
    @IBOutlet weak var friButton: ToggleButton!
    @IBOutlet weak var satButton: ToggleButton!
    @IBOutlet weak var calendarView: ParentCalendarView!
    
    @IBOutlet weak var eventTimeView: UIView!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var allDaySwitch: UISwitch!
    
    @IBOutlet weak var occursOnceView: UIView!
    @IBOutlet weak var reoccursWeeklyView: UIView!
    @IBOutlet weak var reoccursMonthlyView: UIView!
    
    @IBOutlet weak var attachToLabel: UILabel!
    @IBOutlet weak var attachToView: UIView!
    @IBOutlet weak var recurringTaskLabelTopConstraint: NSLayoutConstraint!
    
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        activityType = .event
        
        eventNameTextField.delegate = self
        eventLocationTextField.delegate = self
        
        theScrollView = scrollView
        theContentHeightConstraint = contentHeightConstraint
        
        theActivityNameLabel = activityNameLabel
        theEventNameTextField = eventNameTextField
        theEventLocationTextField = eventLocationTextField
   
        theDatePicker = datePicker
        theDatePicker!.minimumDate = Date()
        theStartTimePicker = startTimePicker
        theEndTimePicker = endTimePicker
        theAllDaySwitch = allDaySwitch
            
        theDailyCheckButton = dailyCheckButton
        theWeeklyCheckButton = weeklyCheckButton
        theMonthlyCheckButton = monthlyCheckButton
        theAnnualCheckButton = annualCheckButton
        
        theSunButton = sunButton
        theMonButton = monButton
        theTueButton = tueButton
        theWedButton = wedButton
        theThuButton = thuButton
        theFriButton = friButton
        theSatButton = satButton
        
        theAttachToLabel = attachToLabel
        theAttachToView = attachToView
        theCalendarView = calendarView
        theOccursOnceView = occursOnceView
        theReoccursWeeklyView = reoccursWeeklyView
        theReoccursMonthlyView = reoccursMonthlyView
        theRecurringTaskLabelTopConstraint = recurringTaskLabelTopConstraint
        
        super.initView(inController: inController)
    }

    @IBAction func onAllDay(_ sender: UISwitch) {
        
        hasChanged = true
        
        if sender.isOn {
            
            enableDatePicker(startTimePicker, state: false)
            enableDatePicker(endTimePicker, state: false)
            
        } else {
            
            enableDatePicker(startTimePicker, state: true)
            enableDatePicker(endTimePicker, state: true)
        }
        
    }
    
    @IBAction func onDatePicker(_ sender: UIDatePicker) {
        
        hasChanged = true
        activityDate = sender.date
    }
    
    @IBAction func onPrimaryAction(_ sender: Any) { dismissKeyboard() }
   
    @IBAction func onPerson(_ sender: Any) { attachPeople() }
        
    @IBAction func onCompany(_ sender: Any) { attachCompanies() }
        
    @IBAction func onProject(_ sender: Any) { attachProjects() }
        
    @IBAction func onSave(_ sender: Any) { validateActivity() }
        
    @IBAction func onFrequency(_ sender: ToggleButton) {
        
        hasChanged = true
        setFrequency(button: sender)
        
    }
        
    @IBAction func onWeekly(_ sender: ToggleButton) {
        
        hasChanged = true
        setDayofWeek(button: sender)
    }
}

// MARK: - TEXT FIELD DELEGATE PROTOCOL
extension EventDetailsView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        hasChanged = true
        theViewInfocus = textField
        return true
    }
}

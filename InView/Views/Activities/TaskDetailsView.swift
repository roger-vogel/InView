//
//  ActivityDetailsView.swift
//  InView
//
//  Created by Roger Vogel on 10/24/22.
//

import UIKit
import ColorManager
import DateManager
import AlertManager
import ToggleGroup
import CustomControls

class TaskDetailsView: ParentActivityDetailsView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
 
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var taskTextView: UITextView!
    
    @IBOutlet weak var popupCalendarView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var activityDateTextField: UITextField!
    @IBOutlet weak var todayButton: ToggleButton!
    @IBOutlet weak var calendarButton: RoundedBorderedButton!
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
    
    @IBOutlet weak var occursOnceView: UIView!
    @IBOutlet weak var reoccursWeeklyView: UIView!
    @IBOutlet weak var reoccursMonthlyView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var attachToLabel: UILabel!
    @IBOutlet weak var attachToView: UIView!
    @IBOutlet weak var recurringTaskLabelTopConstraint: NSLayoutConstraint!
    
    // MARK: - PROPERTIES
    
    var groupStates: [Bool]?
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        activityType = .task
        taskTextView.delegate = self
    
        theScrollView = scrollView
        theContentHeightConstraint = contentHeightConstraint
       
        todayButton.initToggle(isCheckBox: true, boxTint: ThemeColors.teal.uicolor)
        theTodayButton = todayButton
        
        calendarButton.setBorderColor(color: ThemeColors.teal)
        activityDateTextField.setBorder(width: 1.0, color: ThemeColors.teal.cgcolor)
        
        theActivityDateTextField = activityDateTextField
        theActivityNameLabel = activityNameLabel
        theTaskTextView = taskTextView
        
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
        
        popupCalendarView.isHidden = true
        popupCalendarView.roundAllCorners(value: 16)
        theDatePicker = datePicker
        calendarButton.setRadius(value: 3)
        
        bringSubviewToFront(popupCalendarView)
  
        super.initView(inController: inController)
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onToday(_ sender: Any) {
        
        hasChanged = true
        
        todayButton.toggle()
        
        activityDate = Date()
        datePicker.date = activityDate
        
        if todayButton.isOn { activityDateTextField.text = DateManager(date: activityDate).shortDateString }
        else { activityDateTextField.text!.removeAll() }
    }
  
    @IBAction func onCalendar(_ sender: Any) {
        
        hasChanged = true
        
        todayButton.setState(false)
        groupStates = [frequencyGroup.isEnabled,dayOfWeekGroup.isEnabled,calendarView.isEnabled]
  
        frequencyGroup.enableGroup(false)
        dayOfWeekGroup.enableGroup(false)
        calendarView.enableCalendar(false)
        
        saveButton.isEnabled = false
        saveButton.alpha = 0.50
        scrollView.isScrollEnabled = false
        
        datePicker.isHidden = false
        popupCalendarView.isHidden = false
        
       // addGestureRecognizer(userTap!)
    }
        
    @IBAction func onDatePicker(_ sender: UIDatePicker) {
        
        hasChanged = true
        
        activityDate = sender.date
        activityDateTextField.text = DateManager(date: sender.date).shortDateString
        
        if DateManager(date: activityDate).isToday {
            
            todayButton.setState(true) 
        }
    }
      
    @IBAction func onDone(_ sender: Any) {
        
        frequencyGroup.enableGroup(groupStates![0])
        dayOfWeekGroup.enableGroup(groupStates![1])
        calendarView.enableCalendar(groupStates![2])
        
        saveButton.isEnabled = true
        saveButton.alpha = 1.0
        scrollView.isScrollEnabled = true
        popupCalendarView.isHidden = true
    }
    
    @IBAction func onPerson(_ sender: Any) { attachPeople() }
        
    @IBAction func onCompany(_ sender: Any) { attachCompanies() }
        
    @IBAction func onProject(_ sender: Any) { attachProjects() }
        
    @IBAction func onSave(_ sender: Any) { validateActivity() }
        
    @IBAction func onWeekly(_ sender: ToggleButton) { setDayofWeek(button: sender) }

    @IBAction func onFrequency(_ sender: ToggleButton) { setFrequency(button: sender) }
}

extension TaskDetailsView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    
        hasChanged = true
        theViewInfocus = textView
        return true
    }
}

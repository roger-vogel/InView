//
//  ParentCalendarView.swift
//  InView
//
//  Created by Roger Vogel on 1/4/23.
//

import UIKit
import ToggleGroup

class ParentCalendarView: UIView {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var d01: ToggleButton!
    @IBOutlet weak var d02: ToggleButton!
    @IBOutlet weak var d03: ToggleButton!
    @IBOutlet weak var d04: ToggleButton!
    @IBOutlet weak var d05: ToggleButton!
    @IBOutlet weak var d06: ToggleButton!
    @IBOutlet weak var d07: ToggleButton!
    @IBOutlet weak var d08: ToggleButton!
    @IBOutlet weak var d09: ToggleButton!
    @IBOutlet weak var d10: ToggleButton!
    @IBOutlet weak var d11: ToggleButton!
    @IBOutlet weak var d12: ToggleButton!
    @IBOutlet weak var d13: ToggleButton!
    @IBOutlet weak var d14: ToggleButton!
    @IBOutlet weak var d15: ToggleButton!
    @IBOutlet weak var d16: ToggleButton!
    @IBOutlet weak var d17: ToggleButton!
    @IBOutlet weak var d18: ToggleButton!
    @IBOutlet weak var d19: ToggleButton!
    @IBOutlet weak var d20: ToggleButton!
    @IBOutlet weak var d21: ToggleButton!
    @IBOutlet weak var d22: ToggleButton!
    @IBOutlet weak var d23: ToggleButton!
    @IBOutlet weak var d24: ToggleButton!
    @IBOutlet weak var d25: ToggleButton!
    @IBOutlet weak var d26: ToggleButton!
    @IBOutlet weak var d27: ToggleButton!
    @IBOutlet weak var d28: ToggleButton!
    @IBOutlet weak var d29: ToggleButton!
    @IBOutlet weak var d30: ToggleButton!
    @IBOutlet weak var d31: ToggleButton!
    
    // MARK: - PROPERTIES
    struct ButtonImages { var selected = UIImage(); var unselected = UIImage() }
    weak var delegate: CalendarViewDelegate?
    
    // MARK: - COMPUTED PROPERTIES
    var selectedDates: [Int] {
        
        var theSelections = [Int]()
        
        for (index,value) in buttons.enumerated() { if value.isOn { theSelections.append(index+1) }}
        return theSelections
    }
    
    // MARK: - PROPERTIES
    var isEnabled: Bool = true
    var buttons = [ToggleButton]()
    var buttonImages = [ButtonImages]()
  
    // MARK: - INITIALIZATION
    func initCalendar() {
        
        buttons = createButtonArray()
        buttonImages = createImageArray()
    }
    
    // MARK: - METHODS
    func enableCalendar(_ state: Bool) {
        
        isEnabled = state
        for button in buttons { button.isEnabled = state }
    }
    
    func setCalendar(setToTrue: [Int]) {
        
        resetCalendar()
        for (_,value) in setToTrue.enumerated() { buttons[value-1].setState(true) }
    }
    
    func setCalendar(setToTrue: [String]) {
        
        var dayArray = [Int]()
        for day in setToTrue { dayArray.append(Int(day)!) }
       
        resetCalendar()
        for (_,value) in dayArray.enumerated() { buttons[value-1].setState(true) }
    }
    
    func setCalendar(setToTrue: [Substring]) {
        
        var dayArray = [Int]()
        for day in setToTrue { dayArray.append(Int(day)!) }
       
        resetCalendar()
        for (_,value) in dayArray.enumerated() { buttons[value-1].setState(true) }
    }
    
    func resetCalendar() {
        
        for button in buttons { button.setState(false) }
    }
    
    func createButtonArray() -> [ToggleButton] {
        
        var buttons = [ToggleButton]()
        
        buttons.append(d01)
        buttons.append(d02)
        buttons.append(d03)
        buttons.append(d04)
        buttons.append(d05)
        buttons.append(d06)
        buttons.append(d07)
        buttons.append(d08)
        buttons.append(d09)
        buttons.append(d10)
        buttons.append(d11)
        buttons.append(d12)
        buttons.append(d13)
        buttons.append(d14)
        buttons.append(d15)
        buttons.append(d16)
        buttons.append(d17)
        buttons.append(d18)
        buttons.append(d19)
        buttons.append(d20)
        buttons.append(d21)
        buttons.append(d22)
        buttons.append(d23)
        buttons.append(d24)
        buttons.append(d25)
        buttons.append(d26)
        buttons.append(d27)
        buttons.append(d28)
        buttons.append(d29)
        buttons.append(d30)
        buttons.append(d31)
      
        for (index,value) in buttons.enumerated() {
            
            let selectedImageName = "button." + String(index+1) + ".selected.png"
            let unselectedImageName = "button." + String(index+1) + ".unselected.png"
          
            let theSelectedImage = UIImage(named: selectedImageName)!
            let theUnselectedImage = UIImage(named: unselectedImageName)!
            
            value.initToggle(selectedImage: theSelectedImage, unselectedImage: theUnselectedImage)
        }
        
        return buttons
    }
    
    func createImageArray() -> [ButtonImages] {
        
        var buttonImages = [ButtonImages]()
        
        for day in 1...31 {
            
            let selectedImage = UIImage(named: "button." + String(day) + ".selected.png")!
            let unselectedImage = UIImage(named: "button." + String(day) + ".unselected.png")!
            
            buttonImages.append(ButtonImages(selected: selectedImage, unselected: unselectedImage))
        }
        
        return buttonImages
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onDaySelection(_ sender: ToggleButton) {
        
        buttons[sender.tag-1].toggle()
        
        if buttons[sender.tag-1].isOn { delegate!.dayWasSelected(day: sender.tag) }
        else {delegate!.dayWasDeselected(day: sender.tag) }
    }
}
        

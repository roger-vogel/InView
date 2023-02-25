//
//  SortPreferencesView.swift
//  InView
//
//  Created by Roger Vogel on 11/17/22.
//

import UIKit
import ToggleGroup

class SortPreferencesView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var firstNameCheckButton: ToggleButton!
    @IBOutlet weak var lastNameCheckButton: ToggleButton!
    @IBOutlet weak var companyCheckButton: ToggleButton!
    @IBOutlet weak var cityCheckButton: ToggleButton!
    @IBOutlet weak var marketCheckButton: ToggleButton!
  
    // MARK: - PROPERTIES
    var peopleGroup = ButtonGroupView()
    var companyGroup = ButtonGroupView()
    var toggleButtons: [ToggleButton]?
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        super.initView(inController: inController)
        
        toggleButtons = [firstNameCheckButton,lastNameCheckButton,companyCheckButton,cityCheckButton,marketCheckButton]
      
        peopleGroup.setGroup(toggleGroup: [firstNameCheckButton,lastNameCheckButton], radioType: .locked)
        companyGroup.setGroup(toggleGroup: [companyCheckButton,cityCheckButton,marketCheckButton], radioType: .locked)
    }
    
    // MARK: - METHODS
    override func setupView() {
        
        for button in toggleButtons! { button.initToggle(isCheckBox: true, boxTint: ThemeColors.teal.uicolor) }
     
        switch GlobalData.shared.peopleSort {
            
            case .first: firstNameCheckButton.setState(true)
            case .last: lastNameCheckButton.setState(true)
        }
        
        switch GlobalData.shared.companySort {
            
            case .name: companyCheckButton.setState(true)
            case .city: cityCheckButton.setState(true)
            case .market: marketCheckButton.setState(true)
        }
    }
    
    // MARK: - ACTION HANDLERS

    @IBAction func onPeopleCheckButton(_ sender: ToggleButton) {
        
        peopleGroup.toggle(button: sender)
        
        switch sender.tag {
            
            case 0: GlobalData.shared.peopleSort = .first
            case 1: GlobalData.shared.peopleSort = .last
            
            default: break
        }
        
        parentController!.contactController.coreData!.defaultSorts!.first!.forPeople = Int16(GlobalData.shared.peopleSort.rawValue)
        GlobalData.shared.saveCoreData()
    }
    
    @IBAction func onCompanyCheckButton(_ sender: ToggleButton) {
     
        companyGroup.toggle(button: sender)
        
        switch sender.tag {
            
            case 0: GlobalData.shared.companySort = .name
            case 1: GlobalData.shared.companySort = .city
            case 2: GlobalData.shared.companySort = .market
                
            default: break
        }
        
        parentController!.contactController.coreData!.defaultSorts!.first!.forCompany = Int16(GlobalData.shared.companySort.rawValue)
        GlobalData.shared.saveCoreData()
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.contactController.contactListView.setupView()
        parentController!.companyController.companyListView.setupView()
        parentController!.dismiss(animated: true)
        GlobalData.shared.activeController!.tabBarController!.tabBar.isHidden = false
    }
}

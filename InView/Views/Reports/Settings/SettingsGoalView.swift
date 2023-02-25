//
//  SettingsGoalView.swift
//  InView
//
//  Created by Roger Vogel on 2/7/23.
//

import UIKit

struct SettingValues { var mtd: Int32? = nil; var goal: Int32? = nil; var prior: Int32? = nil }

class SettingsGoalView: ParentView {
    
    // MARK: - STORY BOARD CONNECTORS
    @IBOutlet weak var goalsTableView: UITableView!
    @IBOutlet weak var goalTotalTextField: UITextField!
    @IBOutlet weak var priorYearTotalTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    // MARK: - PROPERTIES
    var goalTotal: Int32 = 0
    var priorYearTotal: Int32 = 0
    var coreData: CoreDataManager?
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theScrollView = scrollView
        theContentHeightConstraint = contentHeightConstraint
        theViewInfocus = goalsTableView
        
        super.initView(inController: inController)
        
        coreData = parentController!.contactController.coreData!
        
        goalsTableView.delegate = self
        goalsTableView.dataSource = self
        goalsTableView.addTopBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
    }
    
    override func setupView() {
        
        goalTotal = 0
        priorYearTotal = 0
        
        for goal in parentController!.contactController.coreData!.goals! {
            
            goalTotal += goal.goal
            priorYearTotal += goal.priorYear
        }
        
        goalTotalTextField.text = goalTotal == 0 ? "" : String(goalTotal).formattedDollarRounded
        priorYearTotalTextField.text = priorYearTotal == 0 ? "" : String(priorYearTotal).formattedDollarRounded
    
        goalsTableView.reloadData()
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
      
        dismissKeyboard()
        parentController!.projectController.reportsMenuView.showView()
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension SettingsGoalView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return coreData!.goals!.count
    }
          
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 30 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return false }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "setupGoalsListStyle", for: indexPath) as! SettingsGoalsListCell
        let theGoal = coreData!.goals![indexPath.row]
        
        cell.delegate = self
        cell.theMonth = indexPath.row
        cell.monthTextField.text = GlobalData.shared.months[indexPath.row]
        
        cell.goalTextField.backgroundColor = .white
        cell.priorYearTextField.backgroundColor = .white
        
        cell.goalTextField.text = theGoal.goal == 0 ? "" : String(theGoal.goal).formattedDollarRounded
        cell.priorYearTextField.text = theGoal.priorYear == 0 ? "" : String(theGoal.priorYear).formattedDollarRounded
     
        return cell
    }
}

extension SettingsGoalView: SettingsGoalListCellDelegate {
  
    func textFieldWillChange(values: SettingValues) {
        
        if values.goal != nil { goalTotal -= values.goal! }
        else { priorYearTotal -= values.prior! }
    }
    
    func textFieldDidChange(values: SettingValues, forMonth: Int) {
        
        if values.goal != nil {
            
            goalTotal += values.goal!
            goalTotalTextField.text! = goalTotal == 0 ? "" : String(goalTotal).formattedDollarRounded
            coreData!.goals![forMonth].goal = values.goal!
            
        } else {
            
            priorYearTotal += values.prior!
            priorYearTotalTextField.text! = priorYearTotal == 0 ? "" : String(priorYearTotal).formattedDollarRounded
            coreData!.goals![forMonth].priorYear = values.prior!
        }
        
        GlobalData.shared.saveCoreData()
    }
}

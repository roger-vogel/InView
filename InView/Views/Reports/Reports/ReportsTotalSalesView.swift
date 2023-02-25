//
//  TotalSalesReportView.swift
//  InView
//
//  Created by Roger Vogel on 2/5/23.
//

import UIKit
import CustomControls
import Extensions
import DateManager

class ReportsTotalSalesView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var totalYTDTextField: RoundedTextField!
    @IBOutlet weak var totalGoalTextField: RoundedTextField!
    @IBOutlet weak var totalPriorYearTextField: RoundedTextField!
    @IBOutlet weak var byMonthTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataEntrySelector: UISegmentedControl!
    
    // MARK: - PROPERTIES
    var yearToDate: Int32 = 0
    var goalTotal: Int32 = 0
    var priorYearTotal: Int32 = 0
   
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theScrollView = scrollView
        theContentHeightConstraint = contentHeightConstraint
        theViewInfocus = byMonthTableView
        
        super.initView(inController: inController)
        
        totalYTDTextField.setBorder(width: 1.0, color: ThemeColors.aqua.cgcolor)
        totalGoalTextField.setBorder(width: 1.0, color: ThemeColors.aqua.cgcolor)
        totalPriorYearTextField.setBorder(width: 1.0, color: ThemeColors.aqua.cgcolor)
        
        byMonthTableView.delegate = self
        byMonthTableView.dataSource = self
        byMonthTableView.addTopBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
    }
    
    override func setupView() {
        
        resetTotals()
       
        for goal in parentController!.contactController.coreData!.goals! {
        
            goalTotal += goal.goal
            priorYearTotal += goal.priorYear
        }
        
        let isManual = parentController!.contactController.coreData!.reportForType(type: ReportTypes.byGoals)!.isManual
        
        if isManual { for goal in parentController!.contactController.coreData!.goals! { yearToDate += goal.monthToDate } }
        else { for month in 0..<12 { yearToDate += monthToDate(month: Int16(month))} }
     
        totalYTDTextField.text = yearToDate == 0 ? "" : String(yearToDate).formattedDollarRounded
        totalGoalTextField.text = goalTotal == 0 ? "" : String(goalTotal).formattedDollarRounded
        totalPriorYearTextField.text = priorYearTotal == 0 ? "" : String(priorYearTotal).formattedDollarRounded
        
        let report = parentController!.contactController.coreData!.reportForType(type: ReportTypes.byGoals)
        dataEntrySelector.selectedSegmentIndex = report!.isManual ? 1 : 0
       
        byMonthTableView.reloadData()
    }
    
    // MARK: - METHODS
    func resetTotals() {
        
        yearToDate = 0
        goalTotal = 0
        priorYearTotal = 0
    }
    
    func monthToDate(month: Int16) -> Int32 {
        
        var mtd: Int32 = 0
    
        let completedProjects = parentController!.contactController.coreData!.projects!.filter {
            
            $0.stage != nil &&
            $0.status != nil &&
            ($0.stage!.lowercased() == "complete" || $0.status!.lowercased() == "closed") &&
            $0.completionDate != nil &&
            DateManager(date: $0.completionDate).isIn(month: month)
        }
    
        for project in completedProjects {  mtd += productSalesFor(project: project) }
      
        return mtd
    }
    
    func productSalesFor(project: Project) -> Int32 {
        
        var sales: Int32 = 0
        
        for aProduct in project.products! {
            
            let product = aProduct as! Product
            sales += Int32((Double(product.quantity) * product.unitPrice))
            
        }
        
        return sales
    }
    
    @IBAction func onSelector(_ sender: Any) {
        
        let report = parentController!.contactController.coreData!.reportForType(type: ReportTypes.byGoals)
        report!.isManual = dataEntrySelector.selectedSegmentIndex == 0 ? false : true
    
        GlobalData.shared.saveCoreData()
        setupView()
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func OnReturn(_ sender: Any) {
        
        parentController!.projectController.reportsMenuView.showView(withTabBar: false)
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ReportsTotalSalesView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return GlobalData.shared.months.count }
          
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 30 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return false }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "totalSalesListStyle", for: indexPath) as! ReportsTotalSalesListCell
      
        if dataEntrySelector.selectedSegmentIndex == 1 {
            
            cell.monthToDateTextField.isEnabled = true
            cell.monthToDateTextField.backgroundColor = .white
            
            let monthToDate = parentController!.contactController.coreData!.goals![indexPath.row].monthToDate
            cell.monthToDateTextField.text = monthToDate == 0 ? "" : String(monthToDate).formattedDollarRounded
            
        } else {
            
            cell.monthToDateTextField.isEnabled = false
            cell.monthToDateTextField.backgroundColor = .clear
            
            let monthToDate = monthToDate(month: Int16(indexPath.row))
            cell.monthToDateTextField.text = monthToDate == 0 ? "" : String(monthToDate).formattedDollarRounded
        }
        
        let goal = parentController!.contactController.coreData!.goals![indexPath.row].goal
        let priorYear = parentController!.contactController.coreData!.goals![indexPath.row].priorYear
    
        cell.delegate = self
        cell.theMonth = indexPath.row
        cell.monthTextField.text = GlobalData.shared.months[indexPath.row]
        cell.goalTextField.text = goal == 0 ? "" : String(goal).formattedDollarRounded
        cell.previousYearTextField.text = priorYear == 0 ? "" : String(priorYear).formattedDollarRounded
        
        return cell
    }
}

// MARK: - SETTINGS GOAL LIST CELL DELEGATE
extension ReportsTotalSalesView: SettingsGoalListCellDelegate {
  
    func textFieldWillChange(values: SettingValues) { yearToDate -= values.mtd! }
        
    func textFieldDidChange(values: SettingValues, forMonth: Int) {
        
        yearToDate += values.mtd!
        totalYTDTextField.text! = yearToDate == 0 ? "" : String(yearToDate).formattedDollarRounded
        parentController!.contactController.coreData!.goals![forMonth].monthToDate = values.mtd!
        
        GlobalData.shared.saveCoreData()
    }
}

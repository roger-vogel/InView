//
//  SettingsByAccountView.swift
//  InView
//
//  Created by Roger Vogel on 2/7/23.
//

import UIKit

class SettingsByAccountView: ParentView {
    
    // MARK: - STORY BOARD CONNECTORS
    @IBOutlet weak var accountsTableView: UITableView!
    @IBOutlet weak var priorYearTotalTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    // MARK: - PROPERTIES
    var priorYearTotal: Int32 = 0
  
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theScrollView = scrollView
        theContentHeightConstraint = contentHeightConstraint
        theViewInfocus = accountsTableView
        
        super.initView(inController: inController)
        
        accountsTableView.delegate = self
        accountsTableView.dataSource = self
        accountsTableView.addTopBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
    }
    
    override func setupView() {
        
        priorYearTotal = sumPriorYear()
        priorYearTotalTextField.text = String(priorYearTotal).formattedDollarRounded
        reloadTheTableView()
    }
   
    // MARK: - METHODS
    func reloadTheTableView() {
        
        priorYearTotal = 0
        accountsTableView.reloadData()
    }
    
    func sumPriorYear() -> Int32 {
        
        var sum: Int32 = 0
     
        for company in parentController!.contactController.coreData!.companies! { sum += company.priorYear }
        
        return sum
        
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.projectController.reportsMenuView.showView()
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension SettingsByAccountView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return parentController!.contactController.coreData!.companies!.count
        
    }
        
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 30 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return false }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let companies = parentController!.contactController.coreData!.companies!
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "setupByEntityListStyle", for: indexPath) as! SettingsByEntityListCell
        let company = companies[indexPath.row]
     
        cell.delegate = self
        cell.theRow = indexPath.row
        cell.entityTextField.text = company.name!
        cell.priorYearTextField.backgroundColor = .white
        
        if company.priorYear != 0 { cell.priorYearTextField.text = String(company.priorYear).formattedDollarRounded }
        else { cell.priorYearTextField.text!.removeAll() }
            
        return cell
    }
}

extension SettingsByAccountView: EntityListCellDelegate {

    func textFieldWillChange(value: Int32) { priorYearTotal -= value }
   
    func textFieldDidChange(value: Int32, forRow: Int) {
        
        priorYearTotal += value
        priorYearTotalTextField.text! = priorYearTotal == 0 ? "" : String(priorYearTotal).formattedDollarRounded
        
        parentController!.contactController.coreData!.companies![forRow].priorYear = value
        GlobalData.shared.saveCoreData()
    }
}

/*
 
 let report = parentController!.contactController.coreData!.reportForType(type: ReportTypes.byCompanies)
 report!.isManual = dataEntrySelector.selectedSegmentIndex == 0 ? false : true
 
 GlobalData.shared.saveCoreData()
 */

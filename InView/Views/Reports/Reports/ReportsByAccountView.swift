//
//  ReportsByAccountView.swift
//  InView
//
//  Created by Roger Vogel on 2/13/23.
//

import UIKit

class ReportsByAccountView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var dataEntrySelector: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theScrollView = scrollView
        theContentHeightConstraint = contentHeightConstraint
        theViewInfocus = accountTableView
        
        super.initView(inController: inController)
        
        accountTableView.delegate = self
        accountTableView.dataSource = self
        accountTableView.addTopBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
    }
    
    override func setupView() {
        
        let report = parentController!.contactController.coreData!.reportForType(type: ReportTypes.byCompanies)
        dataEntrySelector.selectedSegmentIndex = report!.isManual ? 1 : 0
        
        accountTableView.reloadData()
    }
    
    // MARK: - METHODS
    func yearToDate(_ company: Company) -> Int32 {
        
        var ytd: Int32 = 0
        
        for project in parentController!.contactController.coreData!.projects! {
            
            if project.companies != nil && project.companies!.count > 0 {
                
                if project.companies!.contains(company) && project.products != nil && (project.stage!.lowercased() == "complete" || project.status!.lowercased() == "closed") {
                    
                    for aProduct in project.products! {
                        
                        let product = aProduct as! Product
                        ytd += Int32((Double(product.quantity) * product.unitPrice))
                    }
                }
            }
        }
        
        return ytd
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onSelector(_ sender: Any) {
        
        let report = parentController!.contactController.coreData!.reportForType(type: ReportTypes.byCompanies)
        report!.isManual = dataEntrySelector.selectedSegmentIndex == 0 ? false : true
        
        GlobalData.shared.saveCoreData()
        accountTableView.reloadData()
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.projectController.reportsMenuView.showView(withTabBar: false)
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ReportsByAccountView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return parentController!.contactController.coreData!.companies!.count
    }
          
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 30 }
    
    // Allow highlightcc 
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return false }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "entitySalesListType", for: indexPath) as! ReportsByEntityListCell
        let company = parentController!.contactController.coreData!.companies![indexPath.row]
        
        cell.delegate = self
        cell.myIndexPath = indexPath
        cell.entityNameTextField.text = company.name!
        cell.priorYearTextField.text = company.priorYear == 0 ? "" : String(company.priorYear).formattedDollarRounded
       
        if dataEntrySelector.selectedSegmentIndex == 1 {
            
            cell.priorYearTextField.isEnabled = true
            cell.ytdTextField.backgroundColor = .white
            cell.ytdTextField.isEnabled = true
            cell.ytdTextField.text = company.manualEntry == 0 ? "" : String(company.manualEntry).formattedDollarRounded
            
        } else {
            
            cell.priorYearTextField.isEnabled = false
            cell.ytdTextField.backgroundColor = .clear
            cell.ytdTextField.isEnabled = false
            cell.ytdTextField.text = yearToDate(company) == 0 ? "" : String(yearToDate(company)).formattedDollarRounded
        }
        
        return cell
    }
}

extension ReportsByAccountView: SettingsGoalListCellDelegate {
      
    func textFieldDidChange(value: Int32, indexPath: IndexPath) {
        
        parentController!.contactController.coreData!.companies![indexPath.row].manualEntry = value
        GlobalData.shared.saveCoreData()
    }
}

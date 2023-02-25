//
//  SettingsByProductView.swift
//  InView
//
//  Created by Roger Vogel on 2/7/23.
//

import UIKit

class SettingsByProductView: ParentView {
    
    // MARK: - STORY BOARD CONNECTORS
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var priorYearTotalTextField: UITextField!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    /// MARK: - PROPERTIES
    var priorYearTotal: Int32 = 0
 
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theScrollView = scrollView
        theContentHeightConstraint = contentHeightConstraint
        theViewInfocus = productsTableView
        
        super.initView(inController: inController)
        
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.addTopBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
    
    }
    
    override func setupView() {
        
        priorYearTotal = sumPriorYear()
        priorYearTotalTextField.text = String(priorYearTotal).formattedDollarRounded
        reloadTheTableView()
    }
   
    // MARK: - METHODS
    func reloadTheTableView() {
        
        priorYearTotal = 0
        productsTableView.reloadData()
    }
    
    func sumPriorYear() -> Int32 {
        
        var sum: Int32 = 0
     
        for category in parentController!.contactController.coreData!.productCategories! { sum += category.priorYear }
        
        return sum
        
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.projectController.reportsMenuView.showView()
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension SettingsByProductView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let namedCategories = parentController!.contactController.coreData!.productCategories!.filter { !$0.category!.isEmpty }
        return namedCategories.count
    }
        
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 30 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return false }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categories = parentController!.contactController.coreData!.productCategories!.filter { !$0.category!.isEmpty }
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "setupByEntityListStyle", for: indexPath) as! SettingsByEntityListCell
        let category = categories[indexPath.row]
     
        cell.delegate = self
        cell.theRow = indexPath.row
        cell.entityTextField.text = category.category!
        cell.priorYearTextField.backgroundColor = .white
        
        if category.priorYear != 0 { cell.priorYearTextField.text = String(category.priorYear).formattedDollarRounded }
        else { cell.priorYearTextField.text!.removeAll() }
            
        return cell
    }
}

extension SettingsByProductView: EntityListCellDelegate {

    func textFieldWillChange(value: Int32) { priorYearTotal -= value }
   
    func textFieldDidChange(value: Int32, forRow: Int) {
        
        priorYearTotal += value
        priorYearTotalTextField.text! = priorYearTotal == 0 ? "" : String(priorYearTotal).formattedDollarRounded
        
        parentController!.contactController.coreData!.productCategories![forRow].priorYear = value
        GlobalData.shared.saveCoreData()
    }
}

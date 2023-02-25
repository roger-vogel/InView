//
//  ReportFunnelByProductView.swift
//  InView
//
//  Created by Roger Vogel on 2/13/23.
//

import UIKit

struct CategoryDetail {
    
    var theProjects = [Project]()
    var category = ProductCategory()
    var value: Int32 = 0
}

class ReportsFunnelByProductView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var dataEntrySelector: UISegmentedControl!
    @IBOutlet weak var categoryTableView: UITableView!
    
    // MARK: - PROPERTIES
    var categoryDetails = [CategoryDetail]()
  
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.separatorColor = ThemeColors.aqua.uicolor
        categoryTableView.allowsSelection = true
        categoryTableView.separatorColor = ThemeColors.deepAqua.uicolor
        categoryTableView.addTopBorder(with: ThemeColors.aqua.uicolor, andWidth: 1.0)
        
        super.initView(inController: inController)
        
    }
    
    override func setupView() {
        
        let coreData = parentController!.contactController.coreData!
        
        categoryDetails.removeAll()
        
        // Get all the categories
        for category in coreData.productCategories! {
            
            if !category.category!.isEmpty {
                
                categoryDetails.append(CategoryDetail(category: category))
                
                // Get the products in the category
                for product in coreData.products! {
                    
                    if product.category!.category! == category.category! {
                        
                        // Get the associated project and the sales if completed
                        if product.project!.status!.lowercased() != "closed" && product.project!.stage!.lowercased() != "complete"  {
                            
                            categoryDetails[categoryDetails.count - 1].theProjects.append(product.project!)
                            categoryDetails[categoryDetails.count - 1].value += Int32(Double(product.quantity) * product.unitPrice)
                        }
                    }
                }
            }
        }
        
        categoryTableView.reloadData()
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onSelector(_ sender: Any) {
        
        let report = parentController!.contactController.coreData!.reportForType(type: ReportTypes.funnelbyProduct)
        report!.isManual = dataEntrySelector.selectedSegmentIndex == 0 ? false : true
        
        GlobalData.shared.saveCoreData()
        categoryTableView.reloadData()
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.projectController.reportsMenuView.showView(withTabBar: false)
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ReportsFunnelByProductView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return categoryDetails.count }
        
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 35 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return false }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "funnelByProductListStyle", for: indexPath) as! FunnelByProductListCell
        let categoryDetail = categoryDetails[indexPath.row]
        
        cell.theProductCategory = categoryDetail.category
        cell.delegate = self
        cell.myIndexPath = indexPath
       
        if dataEntrySelector.selectedSegmentIndex == 1 {
            
            cell.valueTextField.backgroundColor = .white
            cell.valueTextField.isEnabled = true
            cell.valueTextField.text = categoryDetail.category.manualEntry == 0 ? "" : String(categoryDetail.category.manualEntry).formattedDollarRounded
            
            if categoryDetail.category.manualEntry == 0 { cell.infoButton.isEnabled = false }
            else { cell.infoButton.isEnabled = true }
            
        } else {
            
            cell.valueTextField.backgroundColor = .clear
            cell.valueTextField.isEnabled = false
            cell.categoryTextField.text = categoryDetail.category.category!
            cell.valueTextField.text = String(categoryDetail.value).formattedDollarRounded
            
            if categoryDetail.value == 0 { cell.infoButton.isEnabled = false }
            else { cell.infoButton.isEnabled = true }
        }
        
        return cell
    }
}

// MARK: - REPORTS BY PRODUCT LIST CELL DELEGATE PROTOCOL
extension ReportsFunnelByProductView: ReportsByProductListCellDelegate {
   
    func onDetailsButton(info: UIButton, indexPath: IndexPath) {
        
        let theProjects = categoryDetails[indexPath.row].theProjects
        let theTitle = categoryDetails[indexPath.row].category.category!
        
        parentController!.projectController.reportsFunnelProjectView.setSource(isFrom: .byProduct, projects: theProjects, title: theTitle)
        parentController!.projectController.reportsFunnelProjectView.showView(withTabBar: false)
    }
    
    func textFieldWillChange(value: Int32, indexPath: IndexPath) { }
  
    func textFieldDidChange(info: UIButton, category: ProductCategory, value: Int32, indexPath: IndexPath) {
        
        if value == 0 { info.isEnabled = false }
        else { info.isEnabled = true }
       
        category.manualEntry = value
        GlobalData.shared.saveCoreData()
    }
}

// MARK: - HELPERS
extension ReportsFunnelByProductView {
    
    // MARK: - METHODS
    func categoryIndex(category: String) -> Int? {
        
        for (index,value) in categoryDetails.enumerated() {
            
            if value.category.category == category { return index }
        }
        
        let newCategory = ProductCategory()
        newCategory.category = category
       
        let details = CategoryDetail(category: newCategory)
        categoryDetails.append(details)
       
        return categoryDetails.count - 1
    }
}

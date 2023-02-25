//
//  ReportsByProductView.swift
//  InView
//
//  Created by Roger Vogel on 2/13/23.
//

import UIKit

class ReportsByProductView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var dataEntrySelector: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    // MARK: - PROPERTIES
    var theCategories: [ProductCategory]?

     // MARK: - INITIALIZATION
     override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
         
         theScrollView = scrollView
         theContentHeightConstraint = contentHeightConstraint
         theViewInfocus = categoriesTableView
         
         super.initView(inController: inController)
         
         categoriesTableView.delegate = self
         categoriesTableView.dataSource = self
         categoriesTableView.addTopBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
     }
     
     override func setupView() {
         
         let report = parentController!.contactController.coreData!.reportForType(type: ReportTypes.byProducts)
         dataEntrySelector.selectedSegmentIndex = report!.isManual ? 1 : 0
         
         categoriesTableView.reloadData()
     }
     
     // MARK: - METHODS
    func yearToDate(_ category: ProductCategory) -> Int32 {
        
        let coreData = parentController!.contactController.coreData!
        var ytd: Int32 = 0
        
        for project in coreData.projects! {
            
            if project.stage!.lowercased() == "complete" || project.status!.lowercased() == "closed" {
                
                if project.products != nil {
                    
                    for aProduct in project.products! {
                        
                        let product = aProduct as! Product
                        if product.category == category { ytd += Int32(product.unitPrice * Double(product.quantity))}
                    }
                }
            }
        }
    
        return ytd
    }
    
     // MARK: - ACTION HANDLERS
     @IBAction func onSelector(_ sender: Any) {
         
         let report = parentController!.contactController.coreData!.reportForType(type: ReportTypes.byProducts)
         report!.isManual = dataEntrySelector.selectedSegmentIndex == 0 ? false : true
         
         GlobalData.shared.saveCoreData()
         categoriesTableView.reloadData()
     }
     
     @IBAction func onReturn(_ sender: Any) {
         
         parentController!.projectController.reportsMenuView.showView(withTabBar: false)
     }
 }

 // MARK: - TABLE VIEW DELEGATE PROTOCOL
 extension ReportsByProductView: UITableViewDelegate, UITableViewDataSource {
     
     // Report number of sections
     func numberOfSections(in tableView: UITableView) -> Int { return 1 }
  
     // Report the number of rows in each section
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
         theCategories = parentController!.contactController.coreData!.productCategories!.filter { $0.category != "" }
         return theCategories!.count
     }
           
     // Report the row height
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 30 }
     
     // Allow highlight
     func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return false }
     
     // Dequeue the cells
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
         let cell = tableView.dequeueReusableCell(withIdentifier: "entitySalesListType", for: indexPath) as! ReportsByEntityListCell
         let productCategory = theCategories![indexPath.row]
         
         cell.delegate = self
         cell.myIndexPath = indexPath
         cell.entityNameTextField.text = productCategory.category!
         cell.priorYearTextField.text = productCategory.priorYear == 0 ? "" : String(productCategory.priorYear).formattedDollarRounded
    
         if dataEntrySelector.selectedSegmentIndex == 1 {
             
             cell.ytdTextField.isEnabled = true
             cell.ytdTextField.backgroundColor = .white
             cell.ytdTextField.text = productCategory.manualEntry == 0 ? "" : String(productCategory.manualEntry).formattedDollarRounded
             cell.priorYearTextField.isEnabled = true
             
         } else {
             
             cell.ytdTextField.isEnabled = false
             cell.ytdTextField.backgroundColor = .clear
             cell.ytdTextField.text = yearToDate(productCategory) == 0 ? "" : String(yearToDate(productCategory)).formattedDollarRounded
             cell.priorYearTextField.isEnabled = false
         }
        
         return cell
     }
 }

 extension ReportsByProductView: SettingsGoalListCellDelegate {
       
     func textFieldDidChange(value: Int32, indexPath: IndexPath) {
         
         parentController!.contactController.coreData!.productCategories![indexPath.row].manualEntry = value
         GlobalData.shared.saveCoreData()
     }
 }

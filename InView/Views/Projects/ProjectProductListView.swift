//
//  ProjectProductListView.swift
//  InView
//
//  Created by Roger Vogel on 10/13/22.
//

import UIKit
import AlertManager

class ProjectProductListView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var totalInvoiceLabel: UILabel!
    
    // MARK: - PROPERTIES
    var theProducts = [Product]()
    var theProject: Project?
    
    // MARK: - COMPUTED PROPERTIES
    var totalProductCost: Double {
        
        var totalCost: Double = 0
        
        for product in theProducts { totalCost += (product.unitPrice * Double(product.quantity)) }

        return totalCost
    }
    
    var totalInvoiceCost: Double {
        
        var totalCost: Double = 0
        
        for product in theProducts {
            
            if product.invoiced == Invoiced.pending {
                
                totalCost += (product.unitPrice * Double(product.quantity)) }
            }
        
        return totalCost
    }
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.sectionHeaderTopPadding = 10
        productTableView.sectionIndexMinimumDisplayRowCount = 15
        productTableView.separatorColor = ThemeColors.deepAqua.uicolor
        
        super.initView(inController: inController)
    }
    
    // MARK: - METHODS
    func setProjectRecord(project: Project) {
        
        theProject = project
        reloadProductList()
    }
    
    func reloadProductList() {
       
        theProducts.removeAll()
        
        for setItem in theProject!.products! { theProducts.append(setItem as! Product) }
    
        theProducts.sort { $0.productDescription! > $1.productDescription! }
        productTableView.reloadData()
    
        let formatter = NumberFormatter()
        
        formatter.setup()
        totalValueLabel.text = "$" + formatter.string(from: NSNumber(value: totalProductCost))!
        totalInvoiceLabel.text = "$" + formatter.string(from: NSNumber(value: totalInvoiceCost))!
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onPlus(_ sender: Any) {
        
        parentController!.projectController.projectProductDetailsView.setProjectProduct(project: theProject!)
        parentController!.projectController.projectProductDetailsView.showView(withTabBar: false)
    }
    
    @IBAction func onEditMode(_ sender: UIButton) {
        
        guard !parentController!.contactController.coreData!.projects!.isEmpty else { return }
        
        productTableView.isEditing = !productTableView.isEditing
        
        var buttonImage: UIImage?
        buttonImage = productTableView.isEditing ? UIImage(systemName: "pencil.circle.fill") : UIImage(systemName: "pencil.circle")
        
        sender.setImage(buttonImage, for: .normal)
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.projectController.projectDetailsView.showView(withTabBar: false)
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ProjectProductListView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
   
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { theProducts.count }
    
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 145 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var theProduct: Product?
        let cell = tableView.dequeueReusableCell(withIdentifier: "productListStyle", for: indexPath) as! ProjectProductListCell
        
        cell.delegate = self
        cell.myIndexPath = indexPath
        theProduct = theProducts[indexPath.row]
       
        if theProduct!.category == nil {
            
            cell.setFields(category: "No Category", id: theProduct!.productID!, description: theProduct!.productDescription!, qty: theProduct!.quantity, price: theProduct!.unitPrice, unitQty: theProduct!.units)
     
        } else {
            
            cell.setFields(category: theProduct!.category!.category!, id: theProduct!.productID!, description: theProduct!.productDescription!, qty: theProduct!.quantity, price: theProduct!.unitPrice, unitQty: theProduct!.units)
        }
        
        switch theProduct!.invoiced {
            
            case Invoiced.no:
                
                cell.invoiceCheckbox.setState(false)
                cell.invoiceCheckbox.isEnabled = true
                
            case Invoiced.pending:
                
                cell.invoiceCheckbox.setState(true)
                cell.invoiceCheckbox.isEnabled = true
                
            case Invoiced.complete:
                
                cell.invoiceCheckbox.setState(true)
                cell.invoiceCheckbox.isEnabled = false
            
            default: break
        }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
      
        return cell
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        parentController!.projectController.projectProductDetailsView.setProjectProduct(project: theProject!, product: theProducts[indexPath.row])
        parentController!.projectController.projectProductDetailsView.showView(withTabBar: false)
    }
    
    // Allow row move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Move a row
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let itemToMove = theProducts[sourceIndexPath.row]
        theProducts.remove(at: sourceIndexPath.row)
        theProducts.insert(itemToMove, at: destinationIndexPath.row)
        
        setupView()
    }
    
    // Disallow indent in edit mode
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { return true }
         
    // Show delete and drag bars
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {  return .delete }
    
    // Allow editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Delete project
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let product = theProducts[indexPath.row]
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Delete Product", aMessage: "Are you sure you want to delete " + product.productDescription! + "?", buttonTitles: ["CANCEL","DELETE"], theStyle: [.cancel,.destructive], theType: .actionSheet) { choice in
                
                if choice == 1 {
                    
                    self.parentController!.contactController.coreData!.projects!.remove(at: indexPath.row)
                    
                    GlobalData.shared.viewContext.delete(product)
                    GlobalData.shared.saveCoreData()
                    
                    
                    self.reloadProductList()
                }
            }
        }
    }
}

extension ProjectProductListView: ProjectProductCellDelegate {
    
    func invoiceProductWasSelected(indexPath: IndexPath) {
        
        theProducts[indexPath.row].invoiced = Invoiced.pending
        reloadProductList()
        
        GlobalData.shared.saveCoreData()
    }
    
    func invoiceProductWasDeselected(indexPath: IndexPath) {
        
        theProducts[indexPath.row].invoiced = Invoiced.no
        reloadProductList()
        
        GlobalData.shared.saveCoreData()
    }
}

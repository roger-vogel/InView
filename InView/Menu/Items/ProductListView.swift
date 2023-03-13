//
//  ProductListView.swift
//  InView-2
//
//  Created by Roger Vogel on 3/12/23.
//

import UIKit
import AlertManager

class ProductListView: ParentView {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var productTableView: UITableView!
    
    // MARK: - PROPERTIES
    var theProducts: [Product]?
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        super.initView(inController: inController)
        
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.sectionHeaderTopPadding = 0
        productTableView.separatorStyle = .none
        
        theProducts = GlobalData.shared.activeController!.contactController.coreData!.products!
    }
    
    // MARK: - ACTION HANLDERS
    @IBAction func onPlus(_ sender: Any) {
    }
    
    @IBAction func onCSV(_ sender: Any) {
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        dismissKeyboard()
        parentController!.dismiss(animated: true)
        GlobalData.shared.activeController!.tabBarController!.tabBar.isHidden = false
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ProductListView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return theProducts!.count }

    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 25 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let product = theProducts![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "productListStyle", for: indexPath) as! ProductListCell
    
        cell.categoryTextField.text = product.category == nil ? "No Category" : product.category!.category
        cell.descriptionTextField.text = product.productDescription
        cell.unitMeasureTextField.text = product.unitDescription
        cell.unitPriceTextField.text = String(format:"%.02f", product.unitPrice).formattedDollar
        cell.backgroundColor = indexPath.row % 2 == 0 ? ThemeColors.beige.uicolor : .white
        
        return cell
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    // Delete product
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let product = theProducts![indexPath.row]
            
            AlertManager(controller: GlobalData.shared.menuController!).popupWithCustomButtons(
                
                aTitle: "Delete Product",
                aMessage: "Are you sure you want to delete " + product.productDescription! + "?",
                buttonTitles: ["CANCEL","DELETE"],
                theStyle: [.cancel,.destructive], theType: .actionSheet) { choice in
                
                if choice == 1 {
                    
                    self.theProducts!.remove(at: indexPath.row)
                    GlobalData.shared.activeController!.contactController.coreData!.products!.remove(at: indexPath.row)
                    
                    GlobalData.shared.viewContext.delete(product)
                    GlobalData.shared.saveCoreData()
                    
                    self.productTableView.reloadData()
                }
            }
        }
    }
}

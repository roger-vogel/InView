//
//  ProductListView.swift
//  InView-2
//
//  Created by Roger Vogel on 3/12/23.
//

import UIKit
import AlertManager
import CustomControls

struct AProductCategory { var name: String; var category: ProductCategory? = nil }

class ProductListView: ParentView {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var addProductView: UIView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var productIDTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var measureTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var addButton: RoundedBorderedButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var csvButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var addTitleLabel: UILabel!
    
    // MARK: - PROPERTIES
    var theProducts: [Product]?
    var theProduct: Product?
    var theProject: Project?
    var categoryPicker = UIPickerView()
    var toolbar = Toolbar()
    var isNew: Bool?
    var selectedCategory: ProductCategory?
    var isFromMenu: Bool = true
   
    // MARK: COMPUTED PROPERTIES
    var theProductCategories: [AProductCategory] {
        
        var categories = [AProductCategory]()
        
        for category in (GlobalData.shared.activeController!.contactController.coreData!.productCategories!.filter { $0.category! != "" }) {
            
            categories.append(AProductCategory(name: category.category!, category: category))
        }
        
        categories.sort { $0.name < $1.name }
        return categories
    }
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        super.initView(inController: inController)
        
        addProductView.setBorder(width: 2.0, color: UIColor.white.cgColor)
        addProductView.roundAllCorners(value: 10)
        addProductView.isHidden = true
        addProductView.alpha = 0.0
        addProductView.layer.shadowColor = UIColor.black.cgColor
        addProductView.layer.shadowOpacity = 0.65
        addProductView.layer.shadowOffset = .zero
        addProductView.isHidden = true
        addProductView.alpha = 0.0

        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.sectionHeaderTopPadding = 0
        productTableView.separatorStyle = .none
        productTableView.allowsSelection = true
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        priceTextField.delegate = self
        priceTextField.inputAccessoryView = toolbar
        
        toolbar.setup(parent: self)
        categoryTextField.inputAccessoryView = toolbar
        categoryTextField.inputView = categoryPicker
        categoryTextField.rightView = UIImageView(image: UIImage(named: "button.up.down"))
        categoryTextField.rightView!.contentMode = .scaleAspectFit
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false
        categoryTextField.rightView!.widthAnchor.constraint(equalToConstant: 20).isActive = true
        categoryTextField.rightView!.heightAnchor.constraint(equalToConstant: categoryTextField.frame.height * 0.95).isActive = true
        categoryTextField.rightViewMode = .always
    }
    
    override func setupView() {
        
        theProducts = GlobalData.shared.activeController!.contactController.coreData!.products!
        productTableView.reloadData()
    }
    
    // MARK: - METHODS
    func projectCaller(project: Project, fromMenu: Bool) {
        
        isFromMenu = fromMenu
        theProject = project
    }
    
    func enableButtons(_ state: Bool) {
        
        returnButton.isEnabled = state
        csvButton.isEnabled = state
        plusButton.isEnabled = state
    }
    
    func clear() {
        
        productIDTextField.text!.removeAll()
        descriptionTextField.text!.removeAll()
        measureTextField.text!.removeAll()
        priceTextField.text!.removeAll()
    }

    // MARK: - ACTION HANLDERS
    @IBAction func primaryActionTriggered(_ sender: Any) { dismissKeyboard() }
   
    @IBAction func onAddProduct(_ sender: Any) {
        
        dismissKeyboard()
        
        if isNew == true {
            
            theProduct!.id = UUID()
            theProduct!.timestamp = Date()
            theProduct!.productID = productIDTextField.text!
            theProduct!.productDescription = descriptionTextField.text!
            theProduct!.unitDescription = measureTextField.text!
            theProduct!.unitPrice = NSString(string: priceTextField.text!.cleanedDollar).doubleValue
            
            if selectedCategory != nil { theProduct!.category = selectedCategory }
            
            parentController!.contactController.coreData!.products!.append(theProduct!)
            
        } else {
            
            theProduct!.productID = productIDTextField.text!
            theProduct!.productDescription = descriptionTextField.text!
            theProduct!.unitDescription = measureTextField.text!
            theProduct!.unitPrice = NSString(string: priceTextField.text!.cleanedDollar).doubleValue
            
            if selectedCategory != nil { theProduct!.category = selectedCategory }
        }
        
        GlobalData.shared.saveCoreData()
        
        setupView()
        onCancelAddProduct(self)
        
    }
    
    @IBAction func onCancelAddProduct(_ sender: Any) {
        
        addProductView.isHidden = true
        addProductView.alpha = 0.0
       
        enableButtons(true)
    }
    
    @IBAction func onPlus(_ sender: Any) {
        
        setProduct()
        displayAddProductView()
    }
    
    @IBAction func onCSV(_ sender: Any) {
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        dismissKeyboard()
        clear()
        
        parentController!.dismiss(animated: true)
        GlobalData.shared.activeController!.tabBarController!.tabBar.isHidden = false
    }
}

// MARK: -  ADD PRODUCT VIEW
extension ProductListView {
    
    func setProduct(product: Product? = nil) {
        
        if product == nil {
            
            isNew = true
            theProduct = Product(context: GlobalData.shared.viewContext)
            addTitleLabel.text = "Add Product"
        
        } else {
            
            isNew = false
            theProduct = product!
            addTitleLabel.text = "Edit Product"
        }
    }
    
    func setCategoryPicker() {
        
        var productCategories = theProductCategories
        productCategories.insert(AProductCategory(name: "No Category"), at: 0)
        
        if isNew! || theProductCategories.isEmpty {
            
            categoryTextField.text = "No Category"
            categoryPicker.selectRow(0, inComponent: 0, animated: false)
            
        } else {
            
            var categoryNames = [String]()
            for category in (productCategories.filter { $0.category != nil } ) {
                
                categoryNames.append(category.name)
            }
            
            categoryTextField.text = theProduct!.category!.category!
            categoryPicker.setRow(forKey: theProduct!.category!.category!, inData: categoryNames)
        }
        
        categoryPicker.reloadAllComponents()
    }
    
    func displayAddProductView() {
        
        setCategoryPicker()
        
        productIDTextField.text = theProduct!.productID!
        descriptionTextField.text = theProduct!.productDescription!
        measureTextField.text = theProduct!.unitDescription!
        priceTextField.text = String(format: "%.02f", theProduct!.unitPrice).formattedDollar
        
        addProductView.isHidden = false
      
        UIView.animate(withDuration: 0.25, animations: { self.addProductView.alpha = 1.0 }) { _ in
            
            self.enableButtons(false)
        }
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ProductListView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard theProducts != nil else { return 0 }
        return theProducts!.count
        
    }

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
        
        if isFromMenu {
            
            setProduct(product: theProducts![indexPath.row])
            displayAddProductView()
            
        } else {
            
            if !theProject!.products!.contains(theProducts![indexPath.row]) {
                
                theProject!.addToProducts(theProducts![indexPath.row])
                GlobalData.shared.saveCoreData()
            }
   
            GlobalData.shared.activeController!.projectController.projectProductListView.reloadProductList()
            
            parentController!.dismiss(animated: true)
            GlobalData.shared.activeController!.tabBarController!.tabBar.isHidden = true
        }
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

// MARK: - TEXT FIELD DELEGATE PROTOCOL
extension ProductListView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.text = textField.text!.cleanedDollar
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.text = textField.text!.formattedDollar
    }
}

// MARK: - PICKER PROTOCOL
extension ProductListView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { return 30 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return theProductCategories.count }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return theProductCategories[row].name }
        
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        categoryTextField.text = theProductCategories[row].name
        selectedCategory = theProductCategories[row].category!
    }
}




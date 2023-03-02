//
//  ProjectProductDetailsView.swift
//  InView
//
//  Created by Roger Vogel on 10/13/22.
//

import UIKit
import AlertManager
import CustomControls

class ProjectProductDetailsView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var projectNameTextField: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var productIDTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var unitQuantityTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitPriceTextField: UITextField!
    @IBOutlet weak var totalCostTextField: UITextField!
    @IBOutlet weak var totalItemsTextField: UITextField!
    
    // MARK: - PROPERTIES
    var theProject: Project?
    var theProduct: Product?
    var toolbar = Toolbar()
    var categoryPicker = UIPickerView()
    var categoryNames = [String]()
    var selectedCategory: ProductCategory?
  
    // MARK: - COMPUTED PROPERTIES
    var categoryDictionary: [String: ProductCategory] {
        
        var theCategories = [String: ProductCategory]()
 
        categoryNames.removeAll()
      
        let productCategories = parentController!.contactController.coreData!.productCategories!.filter { $0.category != "" }
        for category in productCategories {
            
            theCategories[category.category!] = category
            categoryNames.append(category.category!)
        }
        
        categoryNames.sort { $0 < $1 }
        categoryNames.insert("No Category", at: 0)
       
        return theCategories
    }
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        toolbar.setup(parent: self)
        
        categoryTextField.inputView = categoryPicker
        categoryTextField.inputAccessoryView = toolbar
        categoryTextField.rightView = UIImageView(image: UIImage(named: "button.up.down"))
        categoryTextField.rightView!.contentMode = .scaleAspectFit
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false
        categoryTextField.rightView!.widthAnchor.constraint(equalToConstant: 20).isActive = true
        categoryTextField.rightView!.heightAnchor.constraint(equalToConstant: categoryTextField.frame.height * 0.95).isActive = true
        categoryTextField.rightViewMode = .always
        
        quantityTextField.delegate = self
        unitPriceTextField.delegate = self
        unitQuantityTextField.delegate = self
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        categoryTextField.inputView = categoryPicker
        categoryTextField.inputAccessoryView = toolbar
        
        quantityTextField.inputAccessoryView = toolbar
        unitPriceTextField.inputAccessoryView = toolbar
        unitQuantityTextField.inputAccessoryView = toolbar
        
        super.initView(inController: inController)
    }
    
    // MARK: - METHODS
    func setProjectProduct(project: Project, product: Product? = nil) {
        
        _ = categoryDictionary
        
        theProject = project
        theProduct = product
        
        if theProduct != nil {
            
            productIDTextField.text = theProduct!.productID!
            descriptionTextField.text = theProduct!.productDescription!
            quantityTextField.text = String(theProduct!.quantity)
            unitPriceTextField.text = String(theProduct!.unitPrice).formattedDollar
            
            if categoryTextField.text!.isEmpty || theProduct!.category == nil {
                
                categoryTextField.text = "No Category"
                selectedCategory = nil
                categoryPicker.selectRow(0, inComponent: 0, animated: false)
                
            } else {
                
                let index = categoryPicker.setRow(forKey: theProduct!.category!.category!, inData: categoryNames)
                selectedCategory = categoryDictionary[categoryNames[index!]]
            }
          
        } else {
            
            categoryTextField.text = "No Category"
            selectedCategory = nil
            categoryPicker.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    func clear() {
        
        let fields = [productIDTextField,categoryTextField,productIDTextField,descriptionTextField,quantityTextField,unitPriceTextField]
        for field in fields { field!.text!.removeAll() }
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onPrimaryAction(_ sender: Any) { dismissKeyboard() }
    
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.projectController.projectProductListView.reloadProductList()
        parentController!.projectController.projectProductListView.showView(withTabBar: false)
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        dismissKeyboard()
        
        if theProduct == nil {
            
            let newProduct = Product(context: GlobalData.shared.viewContext)
       
            newProduct.id = UUID()
            newProduct.timestamp = Date()
            newProduct.productID = productIDTextField.text!
            newProduct.productDescription = descriptionTextField.text!
            newProduct.quantity = Int32(NSString(string: quantityTextField.text!.cleanedValue).intValue)
            newProduct.units = Int32(NSString(string: unitQuantityTextField.text!.cleanedValue).intValue)
            newProduct.unitPrice = NSString(string: unitPriceTextField.text!.cleanedDollar).doubleValue
            
            if selectedCategory != nil { newProduct.category = selectedCategory }
            
            theProject!.addToProducts(newProduct)
            
        } else {
            
            theProduct!.productID = productIDTextField.text!
            theProduct!.productDescription = descriptionTextField.text!
            theProduct!.quantity = Int32(NSString(string: quantityTextField.text!.cleanedValue).intValue)
            theProduct!.unitPrice = NSString(string: unitPriceTextField.text!.cleanedDollar).doubleValue
            
            if selectedCategory != nil { theProduct!.category = selectedCategory }
        }
        
        GlobalData.shared.saveCoreData()
        
        parentController!.projectController.projectProductListView.reloadProductList()
        parentController!.projectController.projectProductListView.showView(withTabBar: false)
        
        clear()
    }
}

// MARK: - TEXT FIELD DELEGATE PROTOCOL
extension ProjectProductDetailsView: UITextFieldDelegate, UIPickerViewDelegate {
 
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        guard !textField.text!.isEmpty else { return true }
            
        if textField == quantityTextField || textField == unitQuantityTextField {
            
            textField.text = textField.text!.cleanedValue
            return true
        }
        
        textField.text = textField.text!.cleanedDollar
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text!.isEmpty { textField.text = "0" }
        
        if !textField.text!.isValidNumber {
            
            if textField == unitPriceTextField {  AlertManager(controller: GlobalData.shared.activeController!).popupOK(aMessage: "Please enter a valid number for the unit price") }
            else if textField == unitQuantityTextField {  AlertManager(controller: GlobalData.shared.activeController!).popupOK(aMessage: "Please enter a valid number for the unit quantity") }
            else {  AlertManager(controller: GlobalData.shared.activeController!).popupOK(aMessage: "Please enter a valid number for the quantity")}
           
        } else {
            
            let quantity: Double = quantityTextField.text!.isEmpty ? 0 : NSString(string: quantityTextField.text!.cleanedValue).doubleValue
            let unitQuantity: Double = unitQuantityTextField.text!.isEmpty ? 0 : NSString(string: unitQuantityTextField.text!.cleanedValue).doubleValue
            let price: Double = unitPriceTextField.text!.isEmpty ? 0 : NSString(string: unitPriceTextField.text!.cleanedDollar).doubleValue
            let totalPrice = price * quantity
            let itemCount = unitQuantity * quantity
            
            totalCostTextField.text = String(totalPrice).formattedDollar
            totalItemsTextField.text = String(itemCount).formattedValue
           
            if textField == quantityTextField { quantityTextField.text = quantityTextField.text!.formattedValue }
            if textField == unitQuantityTextField { unitQuantityTextField.text = unitQuantityTextField.text!.formattedValue }
            if textField == unitPriceTextField { unitPriceTextField.text = unitPriceTextField.text!.formattedDollar }
        }
    }
}

// MARK: -  PICKER PROTOCOL
extension ProjectProductDetailsView: UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView,  rowHeightForComponent component: Int) -> CGFloat { return 30 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return categoryNames.count }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return categoryNames[row] }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        categoryTextField.text = categoryNames[row]
        
        if row == 0 { selectedCategory = nil }
        else { selectedCategory = categoryDictionary[categoryNames[row]] }
    }
}

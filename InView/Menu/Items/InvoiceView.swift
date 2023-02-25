//
//  InvoiceView.swift
//  InView
//
//  Created by Roger Vogel on 11/18/22.
//

import UIKit
import CustomControls
import Extensions
import AlertManager

class InvoiceView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var primaryStreetTextField: UITextField!
    @IBOutlet weak var subStreetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var marketTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var taxTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoButton: RoundedBorderedButton!
  
    // MARK: - PROPERTIES
    var theInvoice: Invoice?
    var toolbar = Toolbar()
    var statePicker = UIPickerView()
    var marketPicker = UIPickerView()
    var marketNames = [String]()
    var selectedMarket: MarketArea?
    var logoImagePicker = UIImagePickerController()
    var isNew: Bool?
    
    // MARK: - COMPUTED PROPERTIES
    var marketDictionary: [String: MarketArea] {
        
        var theMarkets = [String: MarketArea]()

        marketNames.removeAll()
    
        for area in parentController!.contactController.coreData!.marketAreas! {
            
            if area.area != "" {
                
                theMarkets[area.area!] = area
                marketNames.append(area.area!)
            }
        }
        
        marketNames.insert("None", at: 0)
        return theMarkets
    }
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theScrollView = scrollView
        theContentHeightConstraint = contentHeightConstraint
       
        logoImagePicker.delegate = self
              
        statePicker.delegate = self
        statePicker.dataSource = self
        stateTextField.inputView = statePicker
        stateTextField.inputAccessoryView = toolbar
        stateTextField.rightView = UIImageView(image: UIImage(named: "button.up.down"))
        stateTextField.rightView!.contentMode = .scaleAspectFit
        stateTextField.translatesAutoresizingMaskIntoConstraints = false
        stateTextField.rightView!.widthAnchor.constraint(equalToConstant: 20).isActive = true
        stateTextField.rightView!.heightAnchor.constraint(equalToConstant: stateTextField.frame.height * 0.95).isActive = true
        stateTextField.rightViewMode = .always
        
        marketPicker.delegate = self
        marketPicker.dataSource = self
        marketTextField.inputView = statePicker
        marketTextField.inputAccessoryView = toolbar
        marketTextField.rightView = UIImageView(image: UIImage(named: "button.up.down"))
        marketTextField.rightView!.contentMode = .scaleAspectFit
        marketTextField.translatesAutoresizingMaskIntoConstraints = false
        marketTextField.rightView!.widthAnchor.constraint(equalToConstant: 20).isActive = true
        marketTextField.rightView!.heightAnchor.constraint(equalToConstant: stateTextField.frame.height * 0.95).isActive = true
        marketTextField.rightViewMode = .always
        
        toolbar.setup(parent: self)
        phoneTextField.inputAccessoryView = toolbar
        postalCodeTextField.inputAccessoryView = toolbar
     
        stateTextField.inputView = statePicker
        stateTextField.inputAccessoryView = toolbar
        
        marketTextField.inputView = marketPicker
        marketTextField.inputAccessoryView = toolbar
        
        setTextFieldDelegates()
        
        super.initView(inController: inController)
    }
    
    override func setupView() {
         
        let coreData = GlobalData.shared.activeController!.contactController.coreData!
        
        if coreData.invoices!.isEmpty {
            
            isNew = true
            theInvoice = Invoice(context: GlobalData.shared.viewContext)

        }  else {
            
            isNew = false
            theInvoice = coreData.invoices!.first!
        }
       
        if theInvoice!.hasLogo {
            
            showButton(false)
            
            let logoData = Data(base64Encoded: theInvoice!.logo!)
            logoImageView.image = UIImage(data: logoData!)
            
        } else { showButton(true) }
            
        
        nameTextField.text = theInvoice!.name!
        primaryStreetTextField.text = theInvoice!.primaryStreet!
        subStreetTextField.text = theInvoice!.subStreet!
        cityTextField.text = theInvoice!.city!
        stateTextField.text = theInvoice!.state!
        postalCodeTextField.text = theInvoice!.postalCode!
        phoneTextField.text = theInvoice!.phone!
        marketTextField.text = theInvoice!.market!
        websiteTextField.text = theInvoice!.website
        taxTextField.text = String(theInvoice!.tax).formattedPercent
        
        _ = marketDictionary
        
        setPickerData()
    }

    // MARK: - METHODS
    func setPickerData() {
        
        _ = marketDictionary
        
        if stateTextField.text!.isEmpty { stateTextField.text = States.us.first!.name }
        else { statePicker.setRow(forState: theInvoice!.state!) }
        
        if marketTextField.text!.isEmpty { marketTextField.text = marketNames.first! }
        else { marketPicker.setRow(forKey: marketTextField.text!, inData: marketNames)}
    }
    
    func setTextFieldDelegates() {
        
        let textFields = [nameTextField,primaryStreetTextField,subStreetTextField,cityTextField,stateTextField,postalCodeTextField,phoneTextField,marketTextField,websiteTextField,taxTextField]
        for field in textFields { field!.delegate = self }
    }
    
    func showButton(_ state: Bool) {
        
        if state {
           
            logoImageView.image = nil
            
            logoButton.setBorder(width: 1.0, color: ThemeColors.darkGray.cgcolor)
            logoButton.setTitle("Tap To Add Logo", for: .normal)
            
        } else {
            
            logoButton.setBorder(width: 0.0)
            logoButton.setTitle("", for: .normal)
        }
    }

    // MARK: - ACTION HANDLERS
    @IBAction func primaryActionTriggered(_ sender: Any) { dismissKeyboard() }
  
    @IBAction func onLogo(_ sender: Any) {
        
        if theInvoice!.hasLogo {
            
            AlertManager(controller: GlobalData.shared.menuController!).popupWithCustomButtons(aTitle: "Logo Update", buttonTitles: ["Change Logo","Delete Logo","Cancel"], theStyle: [.default, .destructive, .cancel], theType: .actionSheet) { (choice) in
                
                switch choice {
                    
                    case 0:
                    
                        GlobalData.shared.menuController!.present(self.logoImagePicker, animated: true, completion: nil)
                    
                    case 1:
                    
                        self.theInvoice!.hasLogo = false
                        self.theInvoice!.logo = ""
                
                        self.showButton(true)
                  
                    default: break
                }
            }
        }
        
        else {
            
            GlobalData.shared.menuController!.present(logoImagePicker, animated: true, completion: nil) }
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        let coreData = GlobalData.shared.activeController!.contactController.coreData!
      
        theInvoice!.name = nameTextField.text!
        theInvoice!.primaryStreet = primaryStreetTextField.text!
        theInvoice!.subStreet = subStreetTextField.text!
        theInvoice!.city = cityTextField.text!
        theInvoice!.state = stateTextField.text!
        theInvoice!.postalCode = postalCodeTextField.text!
        theInvoice!.phone = phoneTextField.text!
        theInvoice!.market = marketTextField.text!
        theInvoice!.website = websiteTextField.text!
        theInvoice!.tax = NSString(string: taxTextField.text!).doubleValue
    
        if isNew! { coreData.invoices!.append(theInvoice!) }
     
        GlobalData.shared.saveCoreData()
     
        onReturn(self)
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        dismissKeyboard()
        parentController!.dismiss(animated: true)
        GlobalData.shared.activeController!.tabBarController!.tabBar.isHidden = false
    }
}

// MARK: - PICKER PROTOCOL
extension InvoiceView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { return 30 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == statePicker { return States.us.count }
        else { return marketNames.count }
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == statePicker { return States.us[row].name }
        else { return marketNames[row] }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == marketPicker {
            
            marketTextField.text = marketNames[row]
            
            if row == 0 { selectedMarket = nil }
            else { selectedMarket = marketDictionary[marketNames[row]] }
            
        } else { stateTextField.text = States.us[row].name }
    }
}

// MARK: - TEXT FIELD DELEGATE PROTOCOL
extension InvoiceView:  UITextFieldDelegate {
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        theViewInfocus = textField
        
        if textField == phoneTextField { phoneTextField.text = phoneTextField.text!.cleanedPhone }
        else if textField == taxTextField { taxTextField.text = taxTextField.text!.cleanedPercent }
       
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == phoneTextField { phoneTextField.text = phoneTextField.text!.formattedPhone }
        else if textField == taxTextField { taxTextField.text = taxTextField.text!.formattedPercent }
     
        return true
    }
}

// MARK: - IMAGE PICKER PROTOTOL
extension InvoiceView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    // MARK: - IMAGE PICKER DELEGATE PROTOCOL
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as? UIImage
      
        GlobalData.shared.menuController!.dismiss(animated: true, completion: { () -> Void in
            
            guard selectedImage != nil else { return }
        
            self.theInvoice!.logo = selectedImage!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
            self.theInvoice!.hasLogo = true
            
            self.logoImageView.image = selectedImage!
            self.showButton(false)
        })
    }
}


/*
 
 invoiceInfo = GlobalData.shared.activeController!.contactController.coreData!.invoiceInfo!.first!
 
 */

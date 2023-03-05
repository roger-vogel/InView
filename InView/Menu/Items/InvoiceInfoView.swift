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

class InvoiceInfoView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var primaryStreetTextField: UITextField!
    @IBOutlet weak var subStreetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var marketTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var taxTextField: UITextField!
    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var termsTextField: UITextField!
    @IBOutlet weak var signatureTextView: UITextView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoButton: RoundedBorderedButton!
  
    // MARK: - PROPERTIES
    var invoiceDefaults: DefaultInvoiceValue?
    var toolbar = Toolbar()
    var statePicker = UIPickerView()
    var marketPicker = UIPickerView()
    var termsPicker = UIPickerView()
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
        marketTextField.rightView!.heightAnchor.constraint(equalToConstant: marketTextField.frame.height * 0.95).isActive = true
        marketTextField.rightViewMode = .always
        
        termsPicker.delegate = self
        termsPicker.dataSource = self
        discountTextField.inputView = statePicker
        discountTextField.inputAccessoryView = toolbar
        discountTextField.rightView = UIImageView(image: UIImage(named: "button.up.down"))
        discountTextField.rightView!.contentMode = .scaleAspectFit
        discountTextField.translatesAutoresizingMaskIntoConstraints = false
        discountTextField.rightView!.widthAnchor.constraint(equalToConstant: 20).isActive = true
        discountTextField.rightView!.heightAnchor.constraint(equalToConstant: termsTextField.frame.height * 0.95).isActive = true
        discountTextField.rightViewMode = .always
        
        toolbar.setup(parent: self)
        phoneTextField.inputAccessoryView = toolbar
        postalCodeTextField.inputAccessoryView = toolbar
     
        stateTextField.inputView = statePicker
        stateTextField.inputAccessoryView = toolbar
        
        marketTextField.inputView = marketPicker
        marketTextField.inputAccessoryView = toolbar
        
        termsTextField.inputView = termsPicker
        termsTextField.inputAccessoryView = toolbar
        
        setTextFieldDelegates()
        
        super.initView(inController: inController)
    }
    
    override func setupView() {
         
        let coreData = GlobalData.shared.activeController!.contactController.coreData!
        
        if coreData.defaultInvoiceValues!.isEmpty {
            
            isNew = true
            invoiceDefaults = DefaultInvoiceValue(context: GlobalData.shared.viewContext)

        }  else {
            
            isNew = false
            invoiceDefaults = coreData.defaultInvoiceValues!.first!
        }
       
        if invoiceDefaults!.hasLogo {
            
            showButton(false)
            
            let logoData = Data(base64Encoded: invoiceDefaults!.logo!)
            logoImageView.image = UIImage(data: logoData!)
            
        } else { showButton(true) }
            
        
        nameTextField.text = invoiceDefaults!.name!
        primaryStreetTextField.text = invoiceDefaults!.primaryStreet!
        subStreetTextField.text = invoiceDefaults!.subStreet!
        cityTextField.text = invoiceDefaults!.city!
        stateTextField.text = invoiceDefaults!.state!
        postalCodeTextField.text = invoiceDefaults!.postalCode!
        emailTextField.text = invoiceDefaults!.email!
        phoneTextField.text = invoiceDefaults!.phone!
        marketTextField.text = invoiceDefaults!.market!
        websiteTextField.text = invoiceDefaults!.website
        taxTextField.text = String(invoiceDefaults!.tax).formattedPercent
        discountTextField.text = String(invoiceDefaults!.defaultDiscount).formattedPercent
        
        _ = marketDictionary
        
        setPickerData()
    }

    // MARK: - METHODS
    func setPickerData() {
        
        _ = marketDictionary
        
        if stateTextField.text!.isEmpty { stateTextField.text = States.us.first!.name }
        else { statePicker.setRow(forState: invoiceDefaults!.state!) }
        
        if marketTextField.text!.isEmpty { marketTextField.text = marketNames.first! }
        else { marketPicker.setRow(forKey: marketTextField.text!, inData: marketNames) }
        
        if termsTextField.text!.isEmpty { termsTextField.text = GlobalData.shared.theTerms.first! }
        else { termsPicker.setRow(forKey: termsTextField.text!, inData: GlobalData.shared.theTerms) }
    }
    
    func setTextFieldDelegates() {
        
        let textFields = [nameTextField,primaryStreetTextField,subStreetTextField,cityTextField,stateTextField,postalCodeTextField,emailTextField,phoneTextField,marketTextField,websiteTextField,taxTextField]
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
        
        if invoiceDefaults!.hasLogo {
            
            AlertManager(controller: GlobalData.shared.menuController!).popupWithCustomButtons(aTitle: "Logo Update", buttonTitles: ["Change Logo","Delete Logo","Cancel"], theStyle: [.default, .destructive, .cancel], theType: .actionSheet) { (choice) in
                
                switch choice {
                    
                    case 0:
                    
                        GlobalData.shared.menuController!.present(self.logoImagePicker, animated: true, completion: nil)
                    
                    case 1:
                    
                        self.invoiceDefaults!.hasLogo = false
                        self.invoiceDefaults!.logo = ""
                
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
      
        invoiceDefaults!.name = nameTextField.text!
        invoiceDefaults!.primaryStreet = primaryStreetTextField.text!
        invoiceDefaults!.subStreet = subStreetTextField.text!
        invoiceDefaults!.city = cityTextField.text!
        invoiceDefaults!.state = stateTextField.text!
        invoiceDefaults!.postalCode = postalCodeTextField.text!
        invoiceDefaults!.email = emailTextField.text!
        invoiceDefaults!.phone = phoneTextField.text!
        invoiceDefaults!.market = marketTextField.text!
        invoiceDefaults!.website = websiteTextField.text!
        invoiceDefaults!.tax = NSString(string: taxTextField.text!).doubleValue
        invoiceDefaults!.defaultDiscount = NSString(string: discountTextField.text!).doubleValue
        invoiceDefaults!.terms = termsTextField.text!
    
        if isNew! { coreData.defaultInvoiceValues!.append(invoiceDefaults!) }
     
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
extension InvoiceInfoView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { return 30 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == statePicker { return States.us.count }
        else if pickerView == marketPicker { return marketNames.count }
        else { return GlobalData.shared.theTerms.count }
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == statePicker { return States.us[row].name }
        else if pickerView == marketPicker { return marketNames[row] }
        else { return GlobalData.shared.theTerms[row] }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == marketPicker {
            
            marketTextField.text = marketNames[row]
            
            if row == 0 { selectedMarket = nil }
            else { selectedMarket = marketDictionary[marketNames[row]] }
            
        } else if pickerView == statePicker {
            
            stateTextField.text = States.us[row].name
            
        } else { termsTextField.text = GlobalData.shared.theTerms[row] }
    }
}

// MARK: - TEXT FIELD DELEGATE PROTOCOL
extension InvoiceInfoView:  UITextFieldDelegate {
   
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
extension InvoiceInfoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    // MARK: - IMAGE PICKER DELEGATE PROTOCOL
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as? UIImage
      
        GlobalData.shared.menuController!.dismiss(animated: true, completion: { () -> Void in
            
            guard selectedImage != nil else { return }
        
            self.invoiceDefaults!.logo = selectedImage!.pngData()!.base64EncodedString()
            self.invoiceDefaults!.hasLogo = true
            
            self.logoImageView.image = selectedImage!
            self.showButton(false)
        })
    }
}

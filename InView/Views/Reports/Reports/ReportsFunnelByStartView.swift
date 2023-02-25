//
//  ReportFunnelByStartView.swift
//  InView
//
//  Created by Roger Vogel on 2/13/23.
//

import UIKit
import CustomControls
import Extensions

enum IsFrom: Int { case byStart, byStage, byProduct}

class ReportsFunnelByStartView: ParentView {
    
    @IBOutlet weak var dataEntrySelector: UISegmentedControl!
    @IBOutlet weak var within30TextField: RoundedTextField!
    @IBOutlet weak var within60TextField: RoundedTextField!
    @IBOutlet weak var within90TextField: RoundedTextField!
    @IBOutlet weak var within120TextField: RoundedTextField!
    @IBOutlet weak var moreThan120TextField: RoundedTextField!
    
    @IBOutlet weak var infoButton0: UIButton!
    @IBOutlet weak var infoButton1: UIButton!
    @IBOutlet weak var infoButton2: UIButton!
    @IBOutlet weak var infoButton3: UIButton!
    @IBOutlet weak var infoButton4: UIButton!
    
    // MARK: PROPERTIES
    var theTextFields: [UITextField]?
    var theButtons: [UIButton]?
    let toolBar = Toolbar()
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
         
        super.initView(inController: inController)
        
        theTextFields = [
        
            within30TextField,
            within60TextField,
            within90TextField,
            within120TextField,
            moreThan120TextField
        ]
        
        theButtons = [
        
            infoButton0,
            infoButton1,
            infoButton2,
            infoButton3,
            infoButton4
        ]
        
        toolBar.setup(parent: self)
    
        for field in theTextFields! {
            
            field.delegate = self
            field.setPadding(left: 8.0, right: 8.0)
            field.setBorder(width: 1.0, color: ThemeColors.mediumGray.cgcolor)
            field.inputAccessoryView = toolBar
        }
    }
    
    override func setupView() {
        
        if dataEntrySelector.selectedSegmentIndex == 0 {
            
            for field in theTextFields! {
                
                field.backgroundColor = .clear
                field.text!.removeAll()
                field.isEnabled = false
            }
            
            var within = [Int32](repeating: 0, count: 5)
            
            for project in parentController!.contactController.coreData!.projects! {
                
                if project.status?.lowercased() != "closed" && project.stage?.lowercased() != "complete" {
                    
                    var sales: Int32 = 0
                    
                    if project.products != nil {
                    
                        for product in project.products! {
                            
                            let theProduct = product as! Product
                            sales += Int32(Double(theProduct.quantity) * theProduct.unitPrice)
                        }
                    }
                    
                    switch project.start {
                            
                        case 30: within[FunnelElements.within30] += sales
                        case 60: within[FunnelElements.within60] += sales
                        case 90: within[FunnelElements.within90] += sales
                        case 120: within[FunnelElements.within120] += sales
                        default: within[FunnelElements.moreThan120] += sales
                    }
                    
                    within30TextField.text = within[FunnelElements.within30] == 0 ? "" : String(within[FunnelElements.within30]).formattedDollarRounded
                    within60TextField.text = within[FunnelElements.within60] == 0 ? "" : String(within[FunnelElements.within60]).formattedDollarRounded
                    within90TextField.text = within[FunnelElements.within90] == 0 ? "" : String(within[FunnelElements.within90]).formattedDollarRounded
                    within120TextField.text = within[FunnelElements.within120] == 0 ? "" : String( within[FunnelElements.within120]).formattedDollarRounded
                    moreThan120TextField.text = within[FunnelElements.moreThan120] == 0 ? "" : String(within[FunnelElements.moreThan120] ).formattedDollarRounded
                    
                    for (index,value) in within.enumerated() {
                        
                        if value == 0 { theButtons![index].isEnabled = false }
                        else { theButtons![index].isEnabled = true }
                    }
                }                
            }
            
        } else {
            
            for field in theTextFields! {
                
                field.text!.removeAll()
                field.backgroundColor = .white
                field.isEnabled = true
            }
       
            let report = parentController!.contactController.coreData!.reportForType(type: ReportTypes.funnelbyStart)
            let theEntries = report!.funnelEntries!.splitString(byString: "|")
            
            if !theEntries.isEmpty {
                
                for fieldIndex in 0..<5 {
                    
                    theTextFields![fieldIndex].text = theEntries[fieldIndex] == "0" ? "" : theEntries[fieldIndex].formattedDollarRounded
                    theButtons![fieldIndex].isEnabled = theEntries[fieldIndex] == "0" ? false : true
                }
            }
        }
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onSelector(_ sender: UISegmentedControl) {
        
        let report = parentController!.contactController.coreData!.reportForType(type: ReportTypes.funnelbyStart)
        report!.isManual = dataEntrySelector.selectedSegmentIndex == 1 ? true : false
        
        setupView()
    }
    
    @IBAction func onInfo(_ sender: UIButton) {
        
        let timeframes = ["30","60","90","120","150"]
        parentController!.projectController.reportsFunnelProjectView.setSource(
            
            isFrom: .byStart,
            filteredBy: timeframes[sender.tag],
            withTitle: "Projects Starting Within " + timeframes[sender.tag] + " Days"
        )
        
        parentController!.projectController.reportsFunnelProjectView.showView(withTabBar: false)
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.projectController.reportsMenuView.showView(withTabBar: false)
    }
}

extension ReportsFunnelByStartView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        guard !textField.text!.isEmpty else { return true }
    
        if textField.text! != "" { textField.text = textField.text!.cleanedDollar }
        return true
    }
        
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        let report = parentController!.contactController.coreData!.reportForType(type: ReportTypes.funnelbyStart)
        var funnelEntries: String = ""
    
        if textField.text != "" { textField.text = textField.text!.formattedDollarRounded}
    
        for textField in theTextFields! {
            
            var textEntry: String
          
            if textField.text! == "" { textEntry = "0"}
            else { textEntry = textField.text!.cleanedDollar }
           
            funnelEntries += (textEntry + "|")
        }
    
        report!.funnelEntries = funnelEntries
        
        let theIndex = theTextFields!.firstIndex(of: textField)
        
        if textField.text!.isEmpty { theButtons![theIndex!].isEnabled = false }
        else { theButtons![theIndex!].isEnabled = true }
            
        GlobalData.shared.saveCoreData()
    }
}


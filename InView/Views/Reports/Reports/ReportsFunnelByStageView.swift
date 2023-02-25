//
//  ReportFunnelByStageView.swift
//  InView
//
//  Created by Roger Vogel on 2/13/23.
//

import UIKit
import CustomControls

class ReportsFunnelByStageView: ParentView {

     @IBOutlet weak var dataEntrySelector: UISegmentedControl!
     @IBOutlet weak var constructionStartedTextField: RoundedTextField!
     @IBOutlet weak var biddingTextField: RoundedTextField!
     @IBOutlet weak var samplingTextField: RoundedTextField!
     @IBOutlet weak var designTextField: RoundedTextField!
     @IBOutlet weak var earlyPlanningTextField: RoundedTextField!
    
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
         
             constructionStartedTextField,
             biddingTextField,
             samplingTextField,
             designTextField,
             earlyPlanningTextField
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
                     
                     switch project.stage {
                             
                         case "Construction": within[FunnelElements.construction] += sales
                         case "Bidding": within[FunnelElements.bidding] += sales
                         case "Sampling": within[FunnelElements.sampling] += sales
                         case "Design": within[FunnelElements.design] += sales
                         default: within[FunnelElements.earlyPlanning] += sales
                     }
                     
                     constructionStartedTextField.text = within[FunnelElements.construction] == 0 ? "" : String(within[FunnelElements.construction]).formattedDollarRounded
                     biddingTextField.text = within[FunnelElements.bidding] == 0 ? "" : String(within[FunnelElements.bidding]).formattedDollarRounded
                     samplingTextField.text = within[FunnelElements.sampling] == 0 ? "" : String(within[FunnelElements.sampling]).formattedDollarRounded
                     designTextField.text = within[FunnelElements.design] == 0 ? "" : String(within[FunnelElements.design]).formattedDollarRounded
                     earlyPlanningTextField.text = within[FunnelElements.earlyPlanning] == 0 ? "" : String(within[FunnelElements.earlyPlanning]).formattedDollarRounded
                     
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
         
         let stages = ["Construction","Bidding","Sampling","Design","Early Planning"]
         parentController!.projectController.reportsFunnelProjectView.setSource(
            
            isFrom: .byStage,
            filteredBy: stages[sender.tag],
            withTitle: "Projects: " + stages[sender.tag]
         )
         
         parentController!.projectController.reportsFunnelProjectView.showView(withTabBar: false)
     }
     
     @IBAction func onReturn(_ sender: Any) {
         
         parentController!.projectController.reportsMenuView.showView(withTabBar: false)
     }

}

 extension ReportsFunnelByStageView: UITextFieldDelegate {
     
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
 

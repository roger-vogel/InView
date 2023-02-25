//
//  ProductCategoriesView.swift
//  InView
//
//  Created by Roger Vogel on 11/12/22.
//

import UIKit

class ProductCategoryView: ParentSettingsView {

    @IBOutlet weak var firstArea: UITextField!
    @IBOutlet weak var secondArea: UITextField!
    @IBOutlet weak var thirdArea: UITextField!
    @IBOutlet weak var fourthArea: UITextField!
    @IBOutlet weak var fifthArea: UITextField!
    @IBOutlet weak var sixthArea: UITextField!
   
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theTextFields = [firstArea,secondArea,thirdArea,fourthArea,fifthArea,sixthArea]
        settingsType = .product
        
        super.initView(inController: inController)
    }

    @IBAction func onPrimaryAction(_ sender: Any) { dismissKeyboard() }
  
    @IBAction func onSave(_ sender: Any) {
        
        saveCategories()
        onReturn(self)
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        dismissKeyboard()
        parentController!.dismiss(animated: true)
        GlobalData.shared.activeController!.tabBarController!.tabBar.isHidden = false
    }
}

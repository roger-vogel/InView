//
//  CompanyCategoryView.swift
//  InView
//
//  Created by Roger Vogel on 12/26/22.
//

import UIKit

class CompanyCategoryView: ParentSettingsView {

    @IBOutlet weak var firstCategory: UITextField!
    @IBOutlet weak var secondCategory: UITextField!
    @IBOutlet weak var thirdCategory: UITextField!
    @IBOutlet weak var fourthCategory: UITextField!
    @IBOutlet weak var fifthCategory: UITextField!
    @IBOutlet weak var sixthCategory: UITextField!

    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theTextFields = [firstCategory,secondCategory,thirdCategory,fourthCategory,fifthCategory,sixthCategory]
        settingsType = .company
        
        super.initView(inController: inController)
    }

    @IBAction func onSave(_ sender: Any) {
        
        saveCategories()
        onReturn(self)
    }
    
    @IBAction func onPrimaryAction(_ sender: Any) { dismissKeyboard() }

    @IBAction func onReturn(_ sender: Any) {
        
        dismissKeyboard()
        parentController!.dismiss(animated: true)
        GlobalData.shared.activeController!.tabBarController!.tabBar.isHidden = false
    }
}

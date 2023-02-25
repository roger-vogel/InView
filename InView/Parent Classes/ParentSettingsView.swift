//
//  ParentSettingsView.swift
//  InView
//
//  Created by Roger Vogel on 11/12/22.
//

import UIKit

class ParentSettingsView: ParentView {

    // MARK: - PROPERTIES
    var theTextFields: [UITextField]?
    var settingsType: SettingsType?
   
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        super.initView(inController: inController)
    }
    
    // MARK: - METHODS
    override func setupView() {
        
        let coreData = parentController!.contactController.coreData!
        
        if settingsType == SettingsType.customer {
            
            let categories = thinCategories(theCategories: coreData.contactCategories!)
            for (index,value) in categories.enumerated() { theTextFields![index].text = value }
            
        } else if settingsType == SettingsType.company {
            
            let categories = thinCategories(theCategories: coreData.companyCategories!)
            for (index,value) in categories.enumerated() { theTextFields![index].text = value }
            
        } else if settingsType == SettingsType.product {
        
            let categories = thinCategories(theCategories: coreData.productCategories!)
            for (index,value) in categories.enumerated() { theTextFields![index].text = value }
            
        } else if settingsType == SettingsType.market {
         
            let categories = thinCategories(theCategories: coreData.marketAreas!)
            for (index,value) in categories.enumerated() { theTextFields![index].text = value }
        }
    }
    
    func saveCategories() {
        
        if settingsType == SettingsType.customer {
            
            let categories = parentController!.contactController.coreData!.contactCategories!
            for (index,_) in categories.enumerated() {  categories[index].category = theTextFields![index].text! }
            
        } else if settingsType == .company {
            
            let categories = parentController!.contactController.coreData!.companyCategories!
            for (index,_) in categories.enumerated() {  categories[index].category = theTextFields![index].text! }
    
        } else if settingsType == SettingsType.product {
            
            let categories = parentController!.contactController.coreData!.productCategories!
            for (index,_) in categories.enumerated() {  categories[index].category = theTextFields![index].text! }
            
        } else if settingsType == SettingsType.market {
            
            let areas = parentController!.contactController.coreData!.marketAreas!
            for (index,_) in areas.enumerated() {  areas[index].area = theTextFields![index].text! }
        }
        
        GlobalData.shared.appDelegate.saveContext()
    }
}

// MARK: - THINNERS
extension ParentSettingsView {
    
    func thinCategories(theCategories: [ProductCategory]) -> [String] {
        
        var thinnedCategories = [String]()
        
        for category in theCategories {
            
            if !category.category!.isEmpty { thinnedCategories.append(category.category!) }
        }
        
        return thinnedCategories
    }
    
    func thinCategories(theCategories: [ContactCategory]) -> [String] {
        
        var thinnedCategories = [String]()
        
        for category in theCategories {
            
            if !category.category!.isEmpty { thinnedCategories.append(category.category!) }
        }
        
        return thinnedCategories
    }
    
    func thinCategories(theCategories: [CompanyCategory]) -> [String] {
        
        var thinnedCategories = [String]()
        
        for category in theCategories {
            
            if !category.category!.isEmpty { thinnedCategories.append(category.category!) }
        }
        
        return thinnedCategories
    }
    
    func thinCategories(theCategories: [MarketArea]) -> [String] {
        
        var thinnedCategories = [String]()
        
        for category in theCategories {
            
            if !category.area!.isEmpty { thinnedCategories.append(category.area!) }
        }
        
        return thinnedCategories
    }
    
}

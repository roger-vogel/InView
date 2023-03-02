//
//  MenuOptions.swift
//  InView-2
//
//  Created by Roger Vogel on 3/2/23.
//

import Foundation

//var menuItems = ["Sort Preferences","Find Duplicates","Import Contacts","Customer Categories","Company Categories","Product Categories","Market Areas","Setup Company Invoice","Reports"]

struct MenuOptions {
  
    static let shared = MenuOptions()
    
    var sortPreferences: Int = 0
    var findDuplicates: Int = 1
    var importContacts: Int = 2
    var customerCategories: Int = 3
    var companyCategoriea: Int = 4
    var productCategories: Int = 5
    var marketAreas: Int = 6
    var invoiceSetup: Int = 7
    var reports: Int = 8
}

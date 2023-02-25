//
//  CompanySectionTitle.swift
//  InView
//
//  Created by Roger Vogel on 10/3/22.
//

import Foundation
import UIKit

class CompanySectionTitle {
    
    // MARK: - PROPERTIES
    var indexTitle: String?
    var companies = [Company]()
    
    // MARK: - INITIALIZATION
    init(title: String, theCompanies: [Company]) {
        
        indexTitle = title
        companies = theCompanies
    }
    
    // MARK: - METHODS
    func sortSectionItems() {
        
        switch GlobalData.shared.companySort {
            
            case .name:  companies.sort { $0.name! < $1.name! }
            case .city:  companies.sort { $0.city! < $1.city! }
            case .market:  companies.sort { $0.market!.area! < $1.market!.area! }
        }
    }
}

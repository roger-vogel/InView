//
//  SectionInfo.swift
//  InView
//
//  Created by Roger Vogel on 9/24/22.
//

import Foundation
import UIKit

class ContactSectionTitle {
    
    // MARK: - PROPERTIES
    var indexTitle: String?
    var contacts = [Contact]()
    
    // MARK: - INITIALIZATION
    init(title: String, theContacts: [Contact]) {
        
        indexTitle = title
        contacts = theContacts
    }
    
    // MARK: - METHODS
    func sortSectionItems() {
        
        if GlobalData.shared.peopleSort == .first { contacts.sort { $0.firstName! < $1.firstName!} }
        else {contacts.sort { $0.lastName! < $1.lastName!} }
    }
}

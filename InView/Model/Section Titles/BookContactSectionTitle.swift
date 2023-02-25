//
//  BookContactSectionTitle.swift
//  InView
//
//  Created by Roger Vogel on 12/11/22.
//

import Foundation

import Foundation
import UIKit
import Contacts

struct BookContactSectionTitle {
    
    // MARK: - PROPERTIES
    var indexTitle: String?
    var bookContacts = [CNContact]()
    
    // MARK: - INITIALIZATION
    init(title: String, theBookContacts: [CNContact]) {
        
        indexTitle = title
        bookContacts = theBookContacts
    }
}

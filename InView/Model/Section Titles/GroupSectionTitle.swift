//
//  GroupSectionTitle.swift
//  InView
//
//  Created by Roger Vogel on 10/5/22.
//

import Foundation
import UIKit

struct GroupSectionTitle {
    
    // MARK: - PROPERTIES
    var indexTitle: String?
    var groups = [Group]()
    
    // MARK: - INITIALIZATION
    init(title: String, theGroups: [Group]) {
        
        indexTitle = title
        groups = theGroups
    }
}

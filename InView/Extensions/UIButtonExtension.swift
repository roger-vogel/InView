//
//  UIButtonExtension.swift
//  Flirte
//
//  Created by Roger Vogel on 8/5/22.
//

import Foundation
import UIKit

extension UIButton {
    
    // MARK: - METHODS
    func setInViewTitle(_ theTitle: String) {
        
        setTitle(theTitle == "" ? "-" : theTitle, for: .normal)
        setTitleColor(theTitle == "" ? ThemeColors.darkGray.uicolor : .systemBlue, for: .normal)
  
        isEnabled = theTitle == "" ? false : true
    }
}

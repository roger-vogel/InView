//
//  Toolbar.swift

//  Primary ToolBar class
//  Basic class from which all pickers are subclassed
//
//  Created by Roger Vogel on 3/31/21.
//  Copyright © 2021 Puldy Resiliency Partners. All rights reserved.

import UIKit

class Toolbar: UIToolbar {
    
    // MARK: -  PROPERTIES
    var parentViewController: ParentViewController?
    var parentView: UIView?
    weak var onCompletion: ToolBarDelegate?

    // MARK: -  METHODS
    
    func setup(parent: UIView) { parentView = parent; setParams() }
    
    func setup(parent: ParentViewController) { parentViewController = parent; setParams() }
        
    func setParams() {
       
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissToolbar))
        
        barStyle = UIBarStyle.default
        isTranslucent = false
        tintColor = .white
        barTintColor = ThemeColors.text.uicolor
        sizeToFit()
        setItems([doneButton], animated: false)
        isUserInteractionEnabled = true
    }
    
    // MARK: -  ACTION HANDLERS
    
    @objc func dismissToolbar() {
        
        if parentViewController != nil { parentViewController!.view.endEditing(true) }
        else { parentView!.endEditing(true) }
        
        if onCompletion != nil { onCompletion!.doneButtonTapped() }
        
    }
}

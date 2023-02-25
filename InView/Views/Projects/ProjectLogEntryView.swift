//
//  ProjectLogEntryView.swift
//  InView
//
//  Created by Roger Vogel on 10/9/22.
//

import UIKit

class ProjectLogEntryView: ParentLogEntryView {

    // MARK: - STORBOARD CONNECTORS
    @IBOutlet weak var entryDatePicker: UIDatePicker!
    @IBOutlet weak var entryTextView: UITextView!
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theEntryDatePicker = entryDatePicker
        theEntryTextView = entryTextView
        
        super.initView(inController: inController)
    }
    
    // MARK: - TEXT VIEW DELEGATE PROTOCOL
  
    @IBAction func onReturn(_ sender: Any) {
        
        saveEntry()
        
        parentController!.projectController.projectLogListView.reloadLogTable()
        parentController!.projectController.projectLogListView.showView(atCompletion: { self.clearEntry() })
    }
}

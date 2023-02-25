//
//  ContactLogEntryView.swift
//  InView
//
//  Created by Roger Vogel on 10/23/22.
//

import UIKit

class ContactLogEntryView: ParentLogEntryView {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var entryDatePicker: UIDatePicker!
    @IBOutlet weak var entryTextView: UITextView!
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theEntryDatePicker = entryDatePicker
        theEntryTextView = entryTextView
        
        super.initView(inController: inController)
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        saveEntry()
        
        parentController!.contactController.contactLogListView.reloadLogTable()
        parentController!.contactController.contactLogListView.showView(withTabBar: false, atCompletion: { self.clearEntry() })
    }
}

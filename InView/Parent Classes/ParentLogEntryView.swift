//
//  ParentLogEntryView.swift
//  InView
//
//  Created by Roger Vogel on 10/23/22.
//

import UIKit

class ParentLogEntryView: ParentView {
    
    var theEntryDatePicker: UIDatePicker?
    var theEntryTextView: UITextView?

    // MARK: - PROPERTIES
    var isNewEntry: Bool = false
    var theLogEntry: LogEntry?
    var theContact: Contact?
    var theCompany: Company?
    var theProject: Project?
    var toolbar = Toolbar()
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        toolbar.setup(parent: self)
        theEntryTextView!.inputAccessoryView = toolbar
      
        super.initView(inController: inController)
    }
    
    // MARK: - METHODS
    func setLogEntry(contact: Contact, logEntry: LogEntry? = nil) {
        
        theContact = contact
        theLogEntry = logEntry
        
        if theLogEntry == nil {
            
            isNewEntry = true
            theLogEntry = LogEntry(context: GlobalData.shared.viewContext)
            theEntryDatePicker!.date = Date()
            
        } else {
      
            theEntryDatePicker!.date = theLogEntry!.timestamp!
            theEntryTextView!.text = theLogEntry!.notes!
        }
        
        theCompany = nil
        theProject = nil
    }
    
    func setLogEntry(company: Company, logEntry: LogEntry? = nil) {
        
        theCompany = company
        theLogEntry = logEntry
        
        if theLogEntry == nil {
            
            isNewEntry = true
            theLogEntry = LogEntry(context: GlobalData.shared.viewContext)
            theEntryDatePicker!.date = Date()
            
        } else {
      
            theEntryDatePicker!.date = theLogEntry!.timestamp!
            theEntryTextView!.text = theLogEntry!.notes!
        }
        
        theContact = nil
        theProject = nil
    }
    
    func setLogEntry(project: Project, logEntry: LogEntry? = nil) {
    
        theProject = project
        theLogEntry = logEntry
        
        if theLogEntry == nil {
            
            isNewEntry = true
            theLogEntry = LogEntry(context: GlobalData.shared.viewContext)
            theEntryDatePicker!.date = Date()
            
        } else {
      
            theEntryDatePicker!.date = theLogEntry!.timestamp!
            theEntryTextView!.text = theLogEntry!.notes!
        }
        
        theContact = nil
        theCompany = nil
    }
    
    func clearEntry() {
        
        theEntryTextView!.text!.removeAll()
        theEntryDatePicker!.date = Date()
    }
    
    func saveEntry() {
        
        dismissKeyboard()
        
        theLogEntry!.timestamp = theEntryDatePicker!.date
        theLogEntry!.notes = theEntryTextView!.text!
        
        if isNewEntry && theContact != nil { theContact!.addToLogEntries(theLogEntry!) }
        if isNewEntry && theCompany != nil { theCompany!.addToLogEntries(theLogEntry!) }
        if isNewEntry && theProject != nil { theProject!.addToLogEntries(theLogEntry!) }
       
        GlobalData.shared.saveCoreData()
    }
}

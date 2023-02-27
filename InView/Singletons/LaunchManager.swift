//
//  LaunchManager.swift
//  InView
//
//  Created by Roger Vogel on 10/3/22.
//

import Foundation
import UIKit
import AlertManager

class LaunchManager {
    
    // MARK: - SINGLETON
    static var shared = LaunchManager()
        
    // MARK: - PROPERTIES
    var parentController: ParentViewController?
    
    // MARK: - INITIALIZATION
    init() { parentController = GlobalData.shared.activeController! }
    
    // MARK: - METHODS
    func call(atNumber: String) {
        
           if let url = URL(string: "tel://" + atNumber) { if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url, options: [:], completionHandler: nil) } }
           else { NSLog("Bad call URL") }
        }
        
    func text(atNumber: [String]) { parentController!.sendMessage(toPhones: atNumber) }
  
    func email(atEmail: [String]) {  parentController!.sendEmail(toAddresses: atEmail) }
        
    func emailContact(contact: Contact) {
        
        AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aMessage: "Select Email Account", buttonTitles: ["Personal","Work","Other","Custom","Cancel"], theStyle: [.default,.default,.default,.default, .cancel], theType: .actionSheet) { choice in
            
            var email: String = ""
            
            switch choice {
                
                case 0: email = contact.personalEmail!
                case 1: email = contact.workEmail!
                case 2: email = contact.otherEmail!
                case 3: email = contact.customEmail!
              
                default: break
            }
            
            if email != "" { self.email(atEmail: [email]) }
      
        }
    }
    
    func callContact(contact: Contact) {
        
        AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aMessage: "Select Phone Number", buttonTitles: ["Mobile","Work","Home","Custom","Cancel"], theStyle: [.default,.default,.default,.default, .cancel], theType: .actionSheet) { choice in
            
            var phoneNumber: String = ""
            
            switch choice {
                
                case 0: phoneNumber = contact.mobilePhone!.cleanedPhone
                case 1: phoneNumber = contact.workPhone!.cleanedPhone
                case 2: phoneNumber = contact.homePhone!.cleanedPhone
                case 3: phoneNumber = contact.customPhone!.cleanedPhone
              
                default: break
            }
            
            if phoneNumber != "" { LaunchManager.shared.call(atNumber: phoneNumber) }
        }
    }
    
    func messageContact(contact: Contact) {
        
        AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aMessage: "Select Phone Number", buttonTitles: ["Mobile","Work","Home","Custom","Cancel"], theStyle: [.default,.default,.default,.default, .cancel], theType: .actionSheet) { choice in
            
            var phoneNumber: String = ""
            
            switch choice {
                
                case 0: phoneNumber = contact.mobilePhone!.cleanedPhone
                case 1: phoneNumber = contact.workPhone!.cleanedPhone
                case 2: phoneNumber = contact.homePhone!.cleanedPhone
                case 3: phoneNumber = contact.customPhone!.cleanedPhone
              
                default: break
            }
            
            if phoneNumber != "" { LaunchManager.shared.text(atNumber: [phoneNumber]) }
        }
    }
    
    func emailContacts(contacts: [Contact]) {
        
        var email = [String]()
        
        for contact in contacts { email.append(contact.workEmail!) }
       
        self.email(atEmail: email)
        
    }
    
    func messageContacts(contacts: [Contact]) {
        
        var phoneNumbers = [String]()
        
        for contact in contacts { phoneNumbers.append(contact.mobilePhone!) }
        self.text(atNumber: phoneNumbers)
    }
    
    func launchMaps(contact: Contact) {
      
        var address =  ""
        
        address += (contact.primaryStreet! + " ")
        address += (contact.subStreet! + " ")
        address += (contact.city! + " ")
        address += (contact.state! + " ")
        address += (contact.postalCode!)
        
        address = address.replacingOccurrences(of: " ", with: "%20")
        
        let url = URL(string: "https://maps.apple.com/?address=" + address)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func launchMaps(company: Company) {
      
        var address =  ""
        
        address += (company.primaryStreet! + " ")
        address += (company.subStreet! + " ")
        address += (company.city! + " ")
        address += (company.state! + " ")
        address += (company.postalCode!)
        
        address = address.replacingOccurrences(of: " ", with: "%20")
        
        let url = URL(string: "https://maps.apple.com/?address=" + address)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func launchMaps(project: Project) {
      
        var address =  ""
        
        address += (project.primaryStreet! + " ")
        address += (project.subStreet! + " ")
        address += (project.city! + " ")
        address += (project.state! + " ")
        address += (project.postalCode!)
        
        address = address.replacingOccurrences(of: " ", with: "%20")
        
        let url = URL(string: "https://maps.apple.com/?address=" + address)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func launchBrowser(url: String) {
        
        if let theURL = URL(string: url) { if UIApplication.shared.canOpenURL(theURL) { UIApplication.shared.open(theURL, options: [:], completionHandler: nil) } }
        else { NSLog("Bad URL") }
    }
}

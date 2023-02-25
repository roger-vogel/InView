//
//  ViewController.swift
//  InView
//
//  Created by Roger Vogel on 9/23/22.
//

import UIKit
import UniformTypeIdentifiers
import MessageUI
import Contacts
import ContactsUI
import AlertManager

// MARK: - PRIMARY CLASS
class ParentViewController: UIViewController {
   
    // MARK: - PROPERTES
    var launchPrimaryView: Bool = true
    var refreshViews: Bool = true
    var controllerViewIsLoaded = false
    var nonPrimaryView: ParentView?
    var importType: ImportType?
    var importedContacts: [CNContact]?

    // MARK: - COMPUTED PROPERTIES
    override var preferredStatusBarStyle: UIStatusBarStyle { return .darkContent }
    
    var contactController: ContactViewController {
        
        let controllers = tabBarController!.viewControllers
        return controllers![Tabs.contacts] as! ContactViewController
    }
    
    var companyController: CompanyViewController {
        
        let controllers = tabBarController!.viewControllers
        return controllers![Tabs.companies] as! CompanyViewController
    }
    
    var groupController: GroupViewController {
        
        let controllers = tabBarController!.viewControllers
        return controllers![Tabs.groups] as! GroupViewController
    }

    var projectController: ProjectViewController {
        
        let controllers = tabBarController!.viewControllers
        return controllers![Tabs.projects] as! ProjectViewController
    }
    
    var activityController: ActivityViewController {
        
        let controllers = tabBarController!.viewControllers
        return controllers![Tabs.activites] as! ActivityViewController
    }
    
    var currentTab: Int { return tabBarController!.selectedIndex }
    
    var activeSubview: ParentView? {
        
        for subView in view.subviews {
            
            if subView.window != nil { return subView as? ParentView }
        }
        
        return nil
    }
    
    // MARK: - INITIALIZATION AND OVERRIDES
    override func viewDidLoad() {
      
        super.viewDidLoad()
        
        guard tabBarController != nil else { return }
        
        tabBarController!.delegate = self
        tabBarController!.tabBar.unselectedItemTintColor = ThemeColors.darkGray.uicolor
        
        controllerViewIsLoaded = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        GlobalData.shared.activeController = self
        GlobalData.shared.activeView = activeSubview
        
        hideSubviews()
    }
    
    // MARK: - METHODS
    func controllerFor(tab: Int) -> ParentViewController? {
        
        switch tab {
            
            case 0: return contactController
            case 1: return companyController
            case 2: return groupController
            case 3: return projectController
            case 4: return activityController
                
            default: return nil
        }
    }
    
    func refreshSubviews() {
        
        for subview in view.subviews { (subview as! ParentView).refresh() }
    }
    
    func refreshAllSubviews() {
        
        contactController.refreshSubviews()
        companyController.refreshSubviews()
        groupController.refreshSubviews()
        projectController.refreshSubviews()
        activityController.refreshSubviews()
    }
    
    func setTabBarElements(selected: UIColor? = ThemeColors.lightGray.uicolor, unselected: UIColor? = ThemeColors.darkGray.uicolor, barColor: UIColor? = ThemeColors.teal.uicolor, isTranslucent: Bool? = false) {
        
        tabBarController!.tabBar.tintColor = selected!
        tabBarController!.tabBar.barTintColor = barColor!
        tabBarController!.tabBar.unselectedItemTintColor = unselected!
        tabBarController!.tabBar.isTranslucent = isTranslucent!
    }
        
    func addSubViews(subViews: [ParentView]) {
        
        for subView in subViews {
            
            subView.alpha = 0.0
            subView.initView(inController: self)
            
            view.addSubview(subView)
        }
    }
    
    func deleteContactIndicesAt(indices: inout [Int]) {
        
        contactController.coreData!.contacts!.deleteIndicesAt(indices: &indices)
        GlobalData.shared.saveCoreData()
    }
    
    func hideSubviews() {
        
        let subviews = view.subviews
        for subview in subviews { subview.isHidden = true }
    }
    
    // MARK: - TAB BAR NAVIGATION
    func gotoTab(_ aTab: Int, showingView: ParentView? = nil, fade: Bool? = false, withTabBar: Bool? = true, atCompletion: @escaping ()-> Void? = { return }) {
        
        if showingView != nil {
            
            controllerFor(tab: aTab)!.launchPrimaryView = false
            controllerFor(tab: aTab)!.nonPrimaryView = showingView!
        
            if showingView!.parentController == nil { showingView!.initView(inController: controllerFor(tab: aTab)!) }
        }
        
        if tabBarController!.selectedIndex != aTab { tabBarController!.selectedIndex = aTab }
    }
    
    // MARK: - ACTION BUTTON STATE CHANGE
    func updateActionButtons() {
        
        if contactController.contactDetailsView != nil { contactController.contactDetailsView.setActionButtonState() }
        if companyController.companyDetailsView != nil { companyController.companyDetailsView.setActionButtonState() }
        if projectController.projectDetailsView != nil { projectController.projectDetailsView.setActionButtonState() }
    }
  
    // MARK: - FOR TESTING
    func printRecords(fields: [String]) {
        
        var output = ""
        for (index,value) in fields.enumerated() { output += (String(format: "%d ",index) + value + " | ") }
        print(output)
    }
}

// MARK: - IMPORT DATA
extension ParentViewController {
    
    func importData(urls: [URL]) {
    
    for url in urls {
        
        readFile(url:url) { fileData in
            
            if self.importType == .vcard { self.importVCard(fileData: fileData) }
            else { self.parseCSV(fileData: fileData) }
        }
    }
}
 
    func importVCard(fileData: Data) {
        
        do {
            
            importedContacts = try CNContactVCardSerialization.contacts(with: fileData)
            
            if importedContacts!.count > 1 {
                
                AlertManager(controller: GlobalData.shared.activeController!).popupWithTextField(
                    aTitle: String(format: "There are %d contacts in this vCard", importedContacts!.count),
                    aMessage: "Would you like to create or add them to a group?",
                    aPlaceholder: "Group name",
                    aDefault: "",
                    buttonTitles: ["NO","YES"],
                    disabledButtons: [1],
                    aStyle: [.cancel,.default]) { button, text in
                        
                    if button == 1 {
                    
                        for importedContact in self.importedContacts! {
                            
                            if importedContact.familyName.isEmpty && importedContact.givenName.isEmpty && !importedContact.organizationName.isEmpty {
                                
                                self.importCompanyVCard(importedContact: importedContact, isInAGroup: true, groupName: text, group: self.contactController.coreData!.containsGroupName(name: text))
                                
                            }
                            else {
                                
                                self.importContactVCard(importedContact: importedContact, isInAGroup: true, groupName: text, group: self.contactController.coreData!.containsGroupName(name: text))
                            }
                        }
                        
                    } else {
                        
                        for importedContact in self.importedContacts! {
                            
                            if importedContact.familyName.isEmpty && importedContact.givenName.isEmpty && !importedContact.organizationName.isEmpty { self.importCompanyVCard(importedContact: importedContact) }
                            else { self.importContactVCard(importedContact: importedContact) }
                        }
                    }
                }
                
            } else {
                
                for importedContact in self.importedContacts! {
                    
                    if importedContact.familyName.isEmpty && importedContact.givenName.isEmpty && !importedContact.organizationName.isEmpty { self.importCompanyVCard(importedContact: importedContact) }
                    else { self.importContactVCard(importedContact: importedContact) }
                }
            }
            
        } catch {  AlertManager(controller: GlobalData.shared.activeController!).popupOK(aMessage: "There seems to be a problem importing your contact data") }
    }
    
    func importVCard(importedContact: CNContact) {
     
        if importedContact.familyName.isEmpty && importedContact.givenName.isEmpty && !importedContact.organizationName.isEmpty { importCompanyVCard(importedContact: importedContact) }
        else { importContactVCard(importedContact: importedContact) }
    }
    
    func importContactVCard(importedContact: CNContact, isInAGroup: Bool? = false, groupName: String? = nil, group: Group? = nil) {
        
        var theGroup: Group?
        let contact = Contact(context: GlobalData.shared.viewContext)
   
        contact.id = UUID()
        contact.appId = UUID().description
        contact.timestamp = Date()
        contact.firstName = importedContact.givenName
        contact.lastName = importedContact.familyName
        contact.title = importedContact.jobTitle
        contact.hasPhoto = importedContact.imageDataAvailable
        
        if contact.hasPhoto {
            
            let photoImage = UIImage(data: importedContact.imageData!)
            contact.photo = photoImage!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
     
        if !importedContact.postalAddresses.isEmpty {
            
            let postalAddress = importedContact.postalAddresses.first!.value
            
            contact.primaryStreet = postalAddress.street
            contact.subStreet = postalAddress.subLocality
            contact.city = postalAddress.city
            contact.state = postalAddress.state
            contact.postalCode = postalAddress.postalCode
        }
        
        if !importedContact.phoneNumbers.isEmpty {
            
            for phone in importedContact.phoneNumbers {
                
                let phoneType = phone.label!.removeCharacters(charsToRemove: ["_","$","!","<",">"])
                
                switch phoneType {
                    
                    case "Mobile": contact.mobilePhone = phone.value.stringValue.cleanedPhone
                    case "Work": contact.workPhone = phone.value.stringValue.cleanedPhone
                    case "Other": contact.otherEmail = phone.value.stringValue.cleanedPhone
                    
                    default: break
                }
            }
        }
        
        if !importedContact.emailAddresses.isEmpty {
            
            for email in importedContact.emailAddresses {
                
                if email.label != nil {
                    
                    let emailType = email.label!.removeCharacters(charsToRemove: ["_","$","!","<",">"])
                    
                    switch emailType {
                        
                        case "Home": contact.personalEmail = String(email.value)
                        case "Work": contact.workEmail = String(email.value)
                        case "Other": contact.otherEmail = String(email.value)
                        
                        default: break
                    }
                }
            }
        }
        
        if importedContact.organizationName != "" {
            
            let theCompany = contactController.coreData!.containsCompanyName(name: importedContact.organizationName)
            
            if theCompany != nil {
         
                contact.company = theCompany!
                theCompany!.addToEmployees(contact)
                
                contactController.coreData!.contacts!.append(contact)
                
            
            } else {
                
                let aCompany = Company(context: GlobalData.shared.viewContext)
                
                aCompany.id = UUID()
                aCompany.appId = UUID().description
                aCompany.timestamp = Date()
                
                aCompany.name = importedContact.organizationName
                contact.company = aCompany
                
                contactController.coreData!.contacts!.append(contact)
                contactController.coreData!.companies!.append(aCompany)
            }
            
        } else {
           
            contactController.coreData!.contacts!.append(contact)
        }
        
        if isInAGroup! && group != nil {
            
            theGroup = group
            theGroup!.addToPeopleMembers(contact)
            
        } else if isInAGroup! && group == nil {
                
            theGroup = Group(context: GlobalData.shared.viewContext)
            theGroup!.name = groupName
            theGroup!.addToPeopleMembers(contact)
            
            contactController.coreData!.groups!.append(theGroup!)
        }
        
        GlobalData.shared.saveCoreData()
        
        if GlobalData.shared.activeController is ContactViewController { contactController.contactListView.setupView() }
        if GlobalData.shared.activeController is CompanyViewController { companyController.companyListView.setupView() }
        if GlobalData.shared.activeController is GroupViewController { groupController.groupListView.setupView() }
    }
    
    func importCompanyVCard(importedContact: CNContact, isInAGroup: Bool? = false, groupName: String? = nil, group: Group? = nil) {
        
        var theGroup: Group?
        let company = Company(context: GlobalData.shared.viewContext)
   
        company.id = UUID()
        company.appId = UUID().description
        company.timestamp = Date()
        
        company.name = importedContact.organizationName
      
        if company.hasPhoto {
            
            let photoImage = UIImage(data: importedContact.imageData!)
            company.photo = photoImage!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
     
        if !importedContact.postalAddresses.isEmpty {
            
            let postalAddress = importedContact.postalAddresses.first!.value
            
            company.primaryStreet = postalAddress.street
            company.subStreet = postalAddress.subLocality
            company.city = postalAddress.city
            
            if States.isValidState(theState: postalAddress.state) {
                
                if States.isStateName(theState: postalAddress.state) { company.state = postalAddress.state }
                else { company.state = States.abbrevToName(abbrev: postalAddress.state)}
                
            } else { company.state = "" }
            
            company.postalCode = postalAddress.postalCode
        }
        
        if !importedContact.phoneNumbers.isEmpty {
            
            company.phone = importedContact.phoneNumbers.first!.value.stringValue
        }
        
        if !importedContact.urlAddresses.isEmpty {
            
            company.website = importedContact.urlAddresses.first!.label!
        }
        
        if isInAGroup! && group != nil {
            
            theGroup = group
            theGroup!.addToCompanyMembers(company)
            
        } else if isInAGroup! && group == nil {
                
            theGroup = Group(context: GlobalData.shared.viewContext)
            theGroup!.name = groupName
            theGroup!.addToCompanyMembers(company)
            
            contactController.coreData!.groups!.append(theGroup!)
        }
            
        contactController.coreData!.companies!.append(company)
        companyController.companyListView.setupView()
     
        GlobalData.shared.saveCoreData()
    }
    
    func parseCSV(fileData: Data) {
        
        let fileString = String(data: fileData, encoding: .utf8)
        
        var newContacts = fileString!.split(separator: "\r\n")
        
        guard !newContacts.isEmpty else {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupOK(aMessage: "There are no records in your CSV file")
            return
        }
     
        guard isValidCSVFile(headerString: String(newContacts.first!)) else {
             
             AlertManager(controller: GlobalData.shared.activeController!).popupOK(aMessage: "Your CSV file is not in the correct format. Please review the file structure at [URL]")
             return
         }
    
        newContacts.removeFirst()
    
        for contactDetails in newContacts {
            
            let fields = String(contactDetails).nullSplit(delimiter: ",")
      
            guard fields.count >= 13 else {
                
                AlertManager(controller: GlobalData.shared.activeController!).popupOK(aMessage: "There are columns missing in you CSV file. Please review the file structure at [URL]")
                return
            }
            
            if fields[0].isEmpty {
                
                let theContact = Contact(context: GlobalData.shared.viewContext)
                
                theContact.firstName = fields[1]
                theContact.lastName = fields[2]
                theContact.title = fields[3]
                theContact.workPhone = fields[4].cleanedPhone
                theContact.workEmail = fields[5]
                theContact.homePhone = fields[6]
                theContact.mobilePhone = fields[7].cleanedPhone
                theContact.personalEmail = fields[8]
                theContact.primaryStreet = fields[9]
                theContact.subStreet = fields[10]
                theContact.city = fields[11]
                theContact.state = fields[12]
                theContact.postalCode = fields[13]
              
                contactController.coreData!.contacts!.append(theContact)
                GlobalData.shared.saveCoreData()
                
            } else {
                
                let theCompany = Company(context: GlobalData.shared.viewContext)
                
                theCompany.name = fields[1]
                theCompany.phone = fields[4].cleanedPhone
                theCompany.primaryStreet = fields[9]
                theCompany.subStreet = fields[10]
                theCompany.city = fields[11]
                theCompany.state = States.getStateName(theState: fields[12])
                theCompany.postalCode = fields[13]
              
                contactController.coreData!.companies!.append(theCompany)
                GlobalData.shared.saveCoreData()
            }
        }
        
        contactController.contactListView.refresh()
        companyController.companyListView.refresh()
    }
    
    func isValidCSVFile(headerString: String) -> Bool {
        
        let headers = [
            
            "isCompany",
            "firstName",
            "lastName",
            "Title",
            "workPhone",
            "workEmail",
            "homePhone",
            "cellPhone",
            "homeEmail",
            "Address",
            "Address_2",
            "City",
            "State",
            "postalCode",
            "Country"
        ]
            
        let subStrings = headerString.nullSplit(delimiter: ",")
        
        for (index,value) in headers.enumerated() {
            
            if subStrings[index] != value { return false }
        }
    
        return true
    }
    
    func readFile(url: URL, atCompletion: @escaping (Data)-> Void) {
        
        var error: NSError? = nil
        
        NSFileCoordinator().coordinate(readingItemAt: url, error: &error) { (url) in
            
            let accessGranted = url.startAccessingSecurityScopedResource()
            guard accessGranted else { NSLog("ACCESS NOT GRANTED"); return }
            
            // Get the file data
            let fileData = FileManager().contents(atPath: url.path)
            
            url.stopAccessingSecurityScopedResource()
            atCompletion(fileData!)
        }
    }
}

// MARK: - TAB BAR CONTROLLER DELEGATE PROTOCOL
extension ParentViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard refreshViews else {
            
            refreshViews = true
            return true
        }
        
        // Refresh contact controller sub views
//        if contactController.contactDetailsView != nil && contactController.contactDetailsView.theContact != nil {  contactController.contactDetailsView.setContactRecord() }
//        if contactController.contactProjectListView != nil && contactController.contactProjectListView.theContact != nil { contactController.contactProjectListView.setContact() }
//        if contactController.contactActivityListView != nil && contactController.contactActivityListView.theContact != nil { contactController.contactActivityListView.setContact() }
//     
//        // Refresh company controller sub views
//        if companyController.companyDetailsView != nil && companyController.companyDetailsView.theCompany != nil { companyController.companyDetailsView.setCompanyRecord() }
//        if companyController.companyProjectListView != nil && companyController.companyProjectListView.theCompany != nil { companyController.companyProjectListView.setCompany() }
//        if companyController.companyActivityListView != nil && companyController.companyActivityListView.theCompany != nil { companyController.companyActivityListView.setCompany() }
//        
//        // Refresh project controller sub views
//        if projectController.projectDetailsView != nil && projectController.projectDetailsView.theProject != nil { projectController.projectDetailsView.setProjectRecord(refreshOnly: true) }
//        if projectController.projectActivityListView != nil && projectController.projectActivityListView.theProject != nil { projectController.projectActivityListView.setProject() }
        
        return true
    }
}

// MARK: - MAIL COMPOSER INITIATOR AND CONTROLLER DELEGATE PROTOCOL
extension ParentViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail(toAddresses: [String]) {
        
        guard MFMailComposeViewController.canSendMail() else {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupMessage(aMessage: "Email services are currently not available on your phone")
            return
        }
        
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setToRecipients(toAddresses)
        
        present(mailViewController, animated: true, completion: nil )
    }
    
    func sendEmailWithAttachment(contentTitle: String, theData: Data) {
        
        guard MFMailComposeViewController.canSendMail() else {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupMessage(aMessage: "Email services are currently not available on your phone")
            return
        }
        
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        
        mailViewController.setPreferredSendingEmailAddress("rtv0431@gmail.com")
        mailViewController.setSubject(contentTitle)
        mailViewController.addAttachmentData(theData, mimeType: FileMimes.mimes["vcf"]!, fileName: contentTitle + ".vcf")
        
        present(mailViewController, animated: true, completion: nil )
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - MESSAGE COMPOSER INITIATOR AND CONTROLLER DELEGATE PROTOCOL
extension ParentViewController: MFMessageComposeViewControllerDelegate {
    
    func sendMessage(toPhones: [String], withBody: String? = nil, withAttachment: AttachmentInfo? = nil) {
        
        guard MFMessageComposeViewController.canSendText() else {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupMessage(aMessage: "SMS services are currently not available on your phone")
            return
        }
        
        let messageViewController = MFMessageComposeViewController()
        messageViewController.messageComposeDelegate = self
        messageViewController.recipients = toPhones
        
        if withBody != nil {
            messageViewController.body = withBody
        }
        
        if withAttachment != nil {
            messageViewController.addAttachmentURL(withAttachment!.url, withAlternateFilename: withAttachment!.title)
        }
     
        present(messageViewController, animated: true, completion: nil )
    }
    
    func sendMessageWithAttachment(contentTitle: String, theData: Data) {
         
         guard MFMessageComposeViewController.canSendText() else {
             
             AlertManager(controller: GlobalData.shared.activeController!).popupMessage(aMessage: "SMS services are currently not available on your phone")
             return
         }
         
         let messageViewController = MFMessageComposeViewController()
         messageViewController.messageComposeDelegate = self
         messageViewController.addAttachmentData(theData, typeIdentifier: FileMimes.mimes["vcf"]!, filename: contentTitle + ".vcf")
      
         present(messageViewController, animated: true, completion: nil )
     }
  
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
            
            case .sent: break  // Actions for sent, if any
            case .cancelled: break // Actions for cancel, if any
            case .failed: break // Actions for message failure, if any
            
            default: break
        }
                                     
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - PRINTER INITIATOR AND  INITIATOR AND CONTROLLER DELEGATE PROTOCOL
extension ParentViewController: UIPrintInteractionControllerDelegate {
    
    func printContent(theURL: URL) {
    
        let printerInterface = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo()
        
        printerInterface.delegate = self
       
        printInfo.outputType = .general
        printInfo.jobName = "InView"
        printerInterface.printInfo = printInfo
        
        printerInterface.present(animated: true, completionHandler: nil)
    }
    
    func printInteractionControllerDidDismissPrinterOptions(_ printInteractionController: UIPrintInteractionController) {
        
        printInteractionController.dismiss(animated: true)
    }
}

// MARK: - DUPLICATE VIEW DELEGATE PROTOCOL
extension ParentViewController: DuplicatesViewDelegate {
    
    func dismissMenuView() {
        
        refreshSubviews()
        GlobalData.shared.saveCoreData()
        dismiss(animated: true)
    }
}

// MARK: - DOCCUMENT PICKER INITIATOR AND DELEGATE PROTOCOL
extension ParentViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ picker: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard urls.count > 0 else { return }
        importData(urls: urls)
    }
    
    func documentPickerWasCancelled(_ picker: UIDocumentPickerViewController) { dismiss(animated: true) }
}

// MARK: - CONTACT PICKER INITIATOR AND DELEGATE PROTOCOL
extension ParentViewController: CNContactPickerDelegate {
    
    func presentContactPicker() {
      
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
       
        present(contactPicker, animated: true)
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        
        for contact in contacts { importVCard(importedContact: contact) }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelectContactProperties contactProperties: [CNContactProperty]) {
   
    }
}

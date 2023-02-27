//
//  ContactDetailsView.swift
//  InView
//
//  Created by Roger Vogel on 9/27/22.
//

import UIKit
import Contacts
import AlertManager
import ColorManager

class ContactDetailsView: ParentView {
   
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contactPhoto: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var quickNotesTextView: UITextView!
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var projectButton: UIButton!
    @IBOutlet weak var activityButton: UIButton!
    
    @IBOutlet weak var mobilePhoneButton: UIButton!
    @IBOutlet weak var homePhoneButton: UIButton!
    @IBOutlet weak var workPhoneButton: UIButton!
    @IBOutlet weak var customPhoneButton: UIButton!
    
    @IBOutlet weak var personalEmailButton: UIButton!
    @IBOutlet weak var workEmailButton: UIButton!
    @IBOutlet weak var otherEmailButton: UIButton!
    @IBOutlet weak var customEmailButton: UIButton!
    
    @IBOutlet weak var primaryStreetButton: UIButton!
    @IBOutlet weak var subStreetButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var postalCodeButton: UIButton!
    
    var hasProjects: Bool {
        
        if theContact!.projects != nil && theContact!.projects!.count > 0 { return true }
        return false
    }
    
    var hasActivities: Bool {
        
        if theContact!.activities != nil && theContact!.activities!.count > 0 { return true}
        return false
    }
    
    // MARK: - PROPERTIES
    var photoImagePicker = UIImagePickerController()
    var toolbar = Toolbar()
    var theContact: Contact?
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        super.initView(inController: inController)
        
        contactPhoto.frameInCircle()
     
        photoImagePicker.delegate = self
        scrollView.delegate = self
        
        toolbar.setup(parent: self)
        toolbar.onCompletion = self
        quickNotesTextView.delegate = self
        quickNotesTextView.inputAccessoryView = toolbar
        quickNotesTextView.setBorder(width: 1.0, color: ThemeColors.teal.cgcolor)
        quickNotesTextView.roundCorners(corners: .all)
    }
    
    // MARK: - METHODS
    func setContactRecord(contact: Contact? = nil) {
        
        if contact != nil { theContact = contact! }
        
        if theContact!.firstName! == "No First Name"{ theContact!.firstName = "" }
        if theContact!.lastName! == "No Last Name"{ theContact!.lastName = "" }
        
        if theContact!.hasPhoto { contactPhoto.image = UIImage(data: Data(base64Encoded: theContact!.photo!)!)! }
        else { contactPhoto.image = GlobalData.shared.contactNoPhoto}
        
        nameLabel.text = theContact!.firstName! + " " + theContact!.lastName!
    
        if theContact!.quickNotes!.isEmpty {
            
            quickNotesTextView.text = "Enter notes here"
            quickNotesTextView.textColor = ColorManager(grayScalePercent: 70).uicolor
            
        } else {
            
            quickNotesTextView.text = theContact!.quickNotes!
            quickNotesTextView.textColor = ThemeColors.darkGray.uicolor
        }
        
        mobilePhoneButton.setInViewTitle(theContact!.mobilePhone!.formattedPhone)
        homePhoneButton.setInViewTitle(theContact!.homePhone!.formattedPhone)
        workPhoneButton.setInViewTitle(theContact!.workPhone!.formattedPhone)
        customPhoneButton.setInViewTitle(theContact!.customPhone!.formattedPhone)
        
        personalEmailButton.setInViewTitle(theContact!.personalEmail!)
        workEmailButton.setInViewTitle(theContact!.workEmail!)
        customEmailButton.setInViewTitle(theContact!.customEmail!)
        otherEmailButton.setInViewTitle(theContact!.otherEmail!)
        
        primaryStreetButton.setInViewTitle(theContact!.primaryStreet!)
        subStreetButton.setInViewTitle(theContact!.subStreet!)
        cityButton.setInViewTitle(theContact!.city!)
        stateButton.setInViewTitle(theContact!.state!)
        postalCodeButton.setInViewTitle(theContact!.postalCode!)
       
        if theContact!.title != nil && theContact!.title != "" {
            
            titleLabel.text = theContact!.title!
            titleLabel.textColor = ColorManager(grayScalePercent: 25).uicolor
            
        } else {

            titleLabel.textColor = .lightGray
            titleLabel.text! = "No Title"
        }
        
        if theContact!.category != nil {
            
            categoryLabel.text = theContact!.category!.category!
            categoryTitleLabel.text = "Category: "
            categoryTitleLabel.textColor = ColorManager(grayScalePercent: 25).uicolor
            
        } else {

            categoryLabel.text = ""
            categoryTitleLabel.text = "No Category"
            categoryTitleLabel.textColor = .lightGray
        }
        
        if theContact!.company != nil {
            
            companyLabel.text = theContact!.company!.name!
            companyLabel.textColor = ColorManager(grayScalePercent: 25).uicolor
            
        } else {
            
            companyLabel.text! = "No Company"
            companyLabel.textColor = .lightGray
        }
        
        setActionButtonState()
    }
    
    func setActionButtonState() {
        
        guard theContact != nil else { return }
        guard theContact!.mobilePhone != nil else { return }
        
        // Phone numbers
        if (theContact!.mobilePhone! + theContact!.homePhone!) + (theContact!.workPhone! + theContact!.customPhone!) == "" {
            
            phoneButton.alpha = 0.50
            phoneButton.isEnabled = false
            
            messageButton.alpha = 0.50
            messageButton.isEnabled = false
            
        } else {
            
            phoneButton.alpha = 1.0
            phoneButton.isEnabled = true
            
            messageButton.alpha = 1.0
            messageButton.isEnabled = true
        }
        
        // Email
        if (theContact!.personalEmail! + theContact!.workEmail!) + (theContact!.otherEmail! + theContact!.customEmail!) == "" {
            
            emailButton.alpha = 0.50
            emailButton.isEnabled = false
            
        } else {
            
            emailButton.alpha = 1.0
            emailButton.isEnabled = true
        }
    }
  
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        guard thelastTab != nil else  {
            
            parentController!.contactController.contactListView.showView()
            return
        }
        
        switch thelastTab {
            
            case Tabs.companies:
                parentController!.companyController.launchPrimaryView = false
                parentController!.companyController.companyDetailsView.setCompanyRecord()
                parentController!.gotoTab(Tabs.companies, showingView: parentController!.companyController.companyDetailsView, withTabBar: false)
            
            case Tabs.groups:
                parentController!.groupController.launchPrimaryView = false
                parentController!.groupController.groupDetailsView.setGroupRecord()
                parentController!.gotoTab(Tabs.groups, showingView: parentController!.groupController.groupDetailsView, withTabBar: false)
            
            case Tabs.projects:
                parentController!.projectController.launchPrimaryView = false
                parentController!.projectController.projectTeamView.setProjectRecord()
                parentController!.gotoTab(Tabs.projects, showingView: parentController!.projectController.projectTeamView, withTabBar: false)
                
            default: break
        }
        
        thelastTab = nil
    }
     
    @IBAction func onSend(_ sender: Any) {
        
        // Build vCard
        let begin = "BEGIN:VCARD\n"
        let version = "VERSION:4.0\n"
        let cardName = "FN:" + theContact!.firstName! + " " + theContact!.lastName! + "\n"
        let name = "N:" + theContact!.lastName! +  ";" + theContact!.firstName! + ";" + "\n"
        let address = "ADR;TYPE=work:;" + theContact!.subStreet! + ";" + theContact!.primaryStreet! + ";" + theContact!.city! + ";" + theContact!.state! + ";" + theContact!.postalCode! + ";;" + "\n"
        let company = theContact!.company == nil ? "" : "ORG:" + theContact!.company!.name! + "\n"
        let photo = theContact!.hasPhoto ? "PHOTO;ENCODING=BASE64;TYPE=JPEG:" + theContact!.photo! + "\n" : ""
    
        let mobilePhone = theContact!.mobilePhone!.isEmpty ? "" : "TEL;TYPE=mobile:" + theContact!.mobilePhone!.cleanedPhone + "\n"
        let workPhone = theContact!.workPhone!.isEmpty ? "" : "TEL;TYPE=work:" + theContact!.workPhone!.cleanedPhone + "\n"
        let homePhone = theContact!.homePhone!.isEmpty ? "" : "TEL;TYPE=home:" + theContact!.homePhone!.cleanedPhone + "\n"
        let otherPhone = theContact!.customPhone!.isEmpty ? "" : "TEL;TYPE=other:" + theContact!.customPhone!.cleanedPhone + "\n"
        
        let workEmail = theContact!.workEmail!.isEmpty ? "" : "EMAIL;TYPE=work:" + theContact!.workEmail! + "\n"
        let homeEmail = theContact!.personalEmail!.isEmpty ? "" : "EMAIL;TYPE=home:" + theContact!.personalEmail! + "\n"
        let otherEmail = theContact!.otherEmail!.isEmpty ? "" : "EMAIL;TYPE=other:" + theContact!.otherEmail! + "\n"
  
        let fileString = begin + version + cardName + name + company + address + mobilePhone + workPhone + homePhone + otherPhone + workEmail + homeEmail + otherEmail + photo + "END:VCARD"
        
        // Send email or message?
        AlertManager(controller: parentController!).popupWithCustomButtons(aTitle: "Send By", buttonTitles: ["EMAIL","TEXT","CANCEL"], theStyle: [.default,.default,.destructive], theType: .actionSheet) { choice in
            
            switch choice {
                
                case 0: self.parentController!.sendEmailWithAttachment(contentTitle: self.theContact!.firstName! +  " " + self.theContact!.lastName!, theData: Data(fileString.utf8))
                case 1: self.parentController!.sendMessageWithAttachment(contentTitle: self.theContact!.firstName! +  " " + self.theContact!.lastName!, theData: Data(fileString.utf8))
                    
                default: break
            }
        }
    }
     
    @IBAction func onLog(_ sender: Any) {
        
        parentController!.contactController.contactLogListView.setContactRecord(contact: theContact!)
        parentController!.contactController.contactLogListView.showView(withTabBar: false)
        
    }
    
    @IBAction func onEdit(_ sender: Any) {
        
        parentController!.contactController.contactEditView.setContactRecord(contact: theContact!)
        parentController!.contactController.contactEditView.showView(withTabBar: false)
    }
    
    @IBAction func onPhoto(_ sender: Any) {
        
        if theContact!.hasPhoto {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Photo Update", buttonTitles: ["Change Photo","Delete Photo","Cancel"], theStyle: [.default, .destructive, .cancel], theType: .actionSheet) { (choice) in
                
                switch choice {
                    
                    case 0:
                    
                        self.parentController!.present(self.photoImagePicker, animated: true, completion: nil)
                    
                    case 1:
                    
                        self.theContact!.hasPhoto = false
                        self.theContact!.photo = ""
                        self.contactPhoto.image = GlobalData.shared.contactNoPhoto
                  
                    default: break
                }
            }
        }
        
        else { parentController!.present(photoImagePicker, animated: true, completion: nil) }
    }
    
    @IBAction func onPhoneAction(_ sender: UIButton) {
        
        LaunchManager.shared.callContact(contact: theContact!)
    }
    
    @IBAction func onMessageAction(_ sender: Any) {
   
        LaunchManager.shared.messageContact(contact: theContact!)
    }

    @IBAction func onEmailAction(_ sender: Any) {
        
        LaunchManager.shared.emailContact(contact: theContact!)
    }
    
    @IBAction func onProjects(_ sender: Any) {
        
        parentController!.contactController.contactProjectListView.setContact(theContact!)
        parentController!.contactController.contactProjectListView.showView(withTabBar: false)
    }
    
    @IBAction func onActivity(_ sender: Any) {
        
        let activityList = parentController!.contactController.contactActivityListView
        
        activityList!.clear()
        activityList!.setContact(theContact!)
        activityList!.showView(withTabBar: false)
    }
    
    @IBAction func onPhone(_ sender: UIButton) {
        
        LaunchManager.shared.call(atNumber: sender.titleLabel!.text!.cleanedPhone)
    }
    
    @IBAction func onEmail(_ sender: UIButton) {
        
        LaunchManager.shared.email(atEmail: [sender.titleLabel!.text!])
    }
    
    @IBAction func onAddress(_ sender: UIButton) {
        
        LaunchManager.shared.launchMaps(contact: theContact!)
    }
}

// MARK: - IMAGE PICKER DELEGATE PROTOCOL
extension ContactDetailsView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as? UIImage
      
        parentController!.dismiss(animated: true, completion: { () -> Void in
            
            guard selectedImage != nil else { return }
            
            self.theContact!.photo = selectedImage!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
            self.theContact!.hasPhoto = true
            self.contactPhoto.image = selectedImage!
            
            GlobalData.shared.saveCoreData()
            
        })
    }
}

// MARK: - TEXT VIEW DELEGATE PROTOCOL
extension ContactDetailsView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView.text == "Enter notes here" {
            
            textView.text.removeAll()
            textView.textColor = .darkGray
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        guard theContact != nil else { return true }
        guard theContact!.quickNotes != nil else { return true }
        
        if quickNotesTextView.text == "Enter notes here" { quickNotesTextView.text.removeAll() }
        
        theContact!.quickNotes = quickNotesTextView.text!
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()

        return true
    }
}

// MARK: - SCROLL VIEW DELEGATE PROTOCOL
extension ContactDetailsView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { scrollView.contentOffset.x = 0 }
}

// MARK: - TOOL BAR DELEGATE PROTOCOL
extension ContactDetailsView: ToolBarDelegate {
    
    func doneButtonTapped() {
        
        if quickNotesTextView.text.isEmpty {
            
            quickNotesTextView.text = "Enter notes here"
            quickNotesTextView.textColor = ColorManager(grayScalePercent: 70).uicolor
            
        } else { quickNotesTextView.textColor = ThemeColors.darkGray.uicolor }
    }
}


/*
 let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
 let fileURL = documentDirectoryURL.appendingPathComponent(fileName)


 let status = fileManager.createFile(atPath: documentDirectoryURL.absoluteString, contents: Data(fileString.utf8) )
 
 */

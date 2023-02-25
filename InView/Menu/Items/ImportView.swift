//
//  ImportView.swift
//  InView
//
//  Created by Roger Vogel on 12/7/22.
//

import UIKit
import Contacts
import CustomControls

class ImportView: ParentView {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var addressBookButton: RoundedBorderedButton!
    @IBOutlet weak var vCardButton: RoundedBorderedButton!
    @IBOutlet weak var csvButton: RoundedBorderedButton!
    
    var importFileType: ImportType?
    var documentPicker: UIDocumentPickerViewController?
  
    // MARK: - METHODS
    func importContacts() {
        
        documentPicker!.delegate = parentController!
        documentPicker!.allowsMultipleSelection = true
        
        parentController!.dismiss(animated: false)
        parentController!.present(documentPicker!, animated: false, completion: nil)
    }
    
    // MARK: -  ACTION HANDLERS
    @IBAction func onAddressBook(_ sender: Any) {
        
        parentController!.dismiss(animated: false)
        parentController!.presentContactPicker()
    }
    
    @IBAction func onvCard(_ sender: Any) {
    
        parentController!.importType = .vcard
        documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.vCard])
        
        importContacts()
    }
    
    @IBAction func onCSV(_ sender: Any) {
    
        parentController!.importType = .csv
        documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.commaSeparatedText])
        
        importContacts()
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.dismiss(animated: true)
        GlobalData.shared.activeController!.tabBarController!.tabBar.isHidden = false
    }
}

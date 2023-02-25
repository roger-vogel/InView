//
//  MemberSelectionView.swift
//  InView
//
//  Created by Roger Vogel on 10/5/22.
//

import UIKit

class MemberSelectionView: ParentSelectionView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectorTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        theTitleLabel = titleLabel
        theSelectorTableView = selectorTableView
        theRecordCountLabel = recordCountLabel
        theSearchTextField = searchTextField
        
        super.initView(inController: inController)
    }
    
    // MARK: - SELECTOR CELL DELEGATE PROTOCOL
    override func contactWasSelected(contact: Contact) {
        
        guard !theSelectedContacts!.contains(contact) else { return }
        
        theSelectedContacts!.append(contact)
        theGroup!.addToPeopleMembers(contact)
        
        setRecordCount()
        GlobalData.shared.saveCoreData()
    }
    
    override func contactWasDeselected(contact: Contact) {
        
        guard theSelectedContacts!.contains(contact) else { return }
        
        theSelectedContacts = theSelectedContacts!.filter { $0 != contact }
        theGroup!.removeFromPeopleMembers(contact)
        
        setRecordCount()
        GlobalData.shared.saveCoreData()
    }
    
    override func companyWasSelected(company: Company) {
        
        guard !theSelectedCompanies!.contains(company) else { return }
        
        theSelectedCompanies!.append(company)
        theGroup!.addToCompanyMembers(company)
        
        setRecordCount()
        GlobalData.shared.saveCoreData()
    }
    
    override func companyWasDeselected(company: Company) {
        
        guard theSelectedCompanies!.contains(company) else { return }
        
        theSelectedCompanies = theSelectedCompanies!.filter { $0 != company }
        theGroup!.removeFromCompanyMembers(company)
        
        setRecordCount()
        GlobalData.shared.saveCoreData()
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.groupController.groupDetailsView.reloadMemberTable()
        parentController!.groupController.groupDetailsView.showView(withTabBar: false)
        
        // Save the change
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

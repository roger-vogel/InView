//
//  ProjectCompanySelectionView.swift
//  InView
//
//  Created by Roger Vogel on 12/25/22.
//

import UIKit

class ProjectCompanySelectionView: ParentSelectionView {

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
    override func companyWasSelected(company: Company) {
        
        guard !theSelectedCompanies!.contains(company) else { return }
        
        theSelectedCompanies!.append(company)
        theProject!.addToCompanies(company)
        
        setRecordCount()
        selectorTableView.reloadData()
        
        GlobalData.shared.saveCoreData()
        
    }
    
    override func companyWasDeselected(company: Company) {
        
        guard theSelectedCompanies!.contains(company) else { return }
        
        theSelectedCompanies = theSelectedCompanies!.filter { $0 != company }
        theProject!.removeFromCompanies(company)
        
        setRecordCount()
        GlobalData.shared.saveCoreData()
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.projectController.projectCompanyView.reloadcompaniesTable()
        parentController!.projectController.projectCompanyView.showView(withTabBar: false)
        
        // Save the change
        GlobalData.shared.saveCoreData()
    }
}

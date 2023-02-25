//
//  ActivityCompanySelectionView.swift
//  InView
//
//  Created by Roger Vogel on 10/27/22.
//

import UIKit

class ActivityCompanySelectionView: ParentSelectionView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectorTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - PROPERTIES
    weak var delegate: ActivitySelectionViewDelegate?
  
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
        
        if !theSelectedCompanies!.contains(company) { theSelectedCompanies!.append(company) }
        setRecordCount()
    }
  
    override func companyWasDeselected(company: Company) {
        
        for (index,value) in theSelectedCompanies!.enumerated() {
            
            if value == company {
                
                theSelectedCompanies!.remove(at: index)
                break
            }
        }
        
        setRecordCount()
    }
        
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        if activityType == .task {
            
            if theSelectedCompanies != nil {
                parentController!.activityController.taskDetailsView.selectedCompanies = theSelectedCompanies!
            }
          
            parentController!.activityController.taskDetailsView.showView(withTabBar: false)

        }  else {
            
            if theSelectedCompanies != nil {
                parentController!.activityController.eventDetailsView.selectedCompanies = theSelectedCompanies!
            }
            
            parentController!.activityController.eventDetailsView.showView(withTabBar: false)
        }
    }
}

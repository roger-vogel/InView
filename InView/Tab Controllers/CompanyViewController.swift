//
//  CompanyViewController.swift
//  InView
//
//  Created by Roger Vogel on 9/23/22.
//

import UIKit

class CompanyViewController: ParentViewController {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet var companyListView: CompanyListView!
    @IBOutlet var companyDetailsView: CompanyDetailsView!
    @IBOutlet var companyEditView: CompanyEditView!
    @IBOutlet var employeeSelectionView: EmployeeSelectionView!
    @IBOutlet var companyProjectListView: CompanyProjectListView!
    @IBOutlet var companyLogListView: CompanyLogListView!
    @IBOutlet var companyLogEntryView: CompanyLogEntryView!
    @IBOutlet var companyActivityListView: CompanyActivityListView!
    @IBOutlet var companyActivityMoveView: CompanyActivityMoveView!
    @IBOutlet var companyInvoiceView: CompanyInvoiceView!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addSubViews(subViews: [
        
                companyListView,
                companyDetailsView,
                companyEditView,
                employeeSelectionView,
                companyProjectListView,
                companyLogListView,
                companyLogEntryView,
                companyActivityListView,
                companyActivityMoveView,
                companyInvoiceView
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    
        if launchPrimaryView {
            
            companyListView.showView(withFade: false, withTabBar: true)
          
        } else {
            
            if nonPrimaryView != nil {
                
                nonPrimaryView!.showView(withFade: false, withTabBar: false)
                nonPrimaryView = nil
            }
            
            launchPrimaryView = true
        }
    }
}

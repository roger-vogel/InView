//
//  MenuController.swift
//  InView
//
//  Created by Roger Vogel on 11/19/22.
//

import UIKit

class MenuViewController: UIViewController {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet var invoiceView: InvoiceInfoView!
    @IBOutlet var marketAreaView: MarketAreaView!
    @IBOutlet var duplicatesView: DuplicatesView!
    @IBOutlet var customerCategoryView: CustomerCategoryView!
    @IBOutlet var companyCategoryView: CompanyCategoryView!
    @IBOutlet var sortPreferencesView: SortPreferencesView!
    @IBOutlet var productCategoryView: ProductCategoryView!
    @IBOutlet var duplicateDetailsView: DuplicateDetailsView!
    @IBOutlet var importView: ImportView!
 
    // MARK: - PROPERTIES
    var presentingController: ParentViewController?
    var viewToShow: ParentView?

    // MARK: - INITIALIZATION
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        addSubViews(subViews: [
            invoiceView,
            marketAreaView,
            duplicatesView,
            customerCategoryView,
            companyCategoryView,
            sortPreferencesView,
            productCategoryView,
            duplicateDetailsView,
            importView
        ])
        
        GlobalData.shared.menuController = self
        duplicateDetailsView.delegate = self
        duplicatesView.delegate = presentingController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
         
        if viewToShow != nil { viewToShow!.showView(withTabBar: false) }

    }
    
    // MARK: - METHODS
    func addSubViews(subViews: [ParentView]) {
        
        for subView in subViews {
            
            subView.alpha = 0.0
            subView.initView(inController: presentingController!)
            
            view.addSubview(subView)
        }
    }
}

extension MenuViewController: DuplicateDetailsViewDelegate {
 
    func refresh() {  duplicatesView.setupView() }
}



/*
 let keysToFetch = [CNContactEmailAddressesKey as CNKeyDescriptor, CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
 */

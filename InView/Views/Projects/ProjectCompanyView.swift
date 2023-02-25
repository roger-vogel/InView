//
//  ProjectCompanyView.swift
//  InView
//
//  Created by Roger Vogel on 12/25/22.
//

import UIKit

class ProjectCompanyView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var companiesTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var addCompanyView: UIView!
    @IBOutlet weak var existingCompanyButton: UIButton!
    @IBOutlet weak var newCompanyButton: UIButton!
    @IBOutlet weak var cancelCompanyButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var plusMinusButton: UIButton!
    
    var theCompanies = [Company]()
    var theProject: Project?
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        companiesTableView.delegate = self
        companiesTableView.dataSource = self
        
        companiesTableView.isEditing = true
        companiesTableView.allowsSelectionDuringEditing = true
        companiesTableView.sectionHeaderTopPadding = 10
        companiesTableView.sectionIndexMinimumDisplayRowCount = 15
        companiesTableView.separatorColor = ThemeColors.deepAqua.uicolor
        
        addCompanyView.setBorder(width: 2.0, color: UIColor.white.cgColor)
        addCompanyView.roundAllCorners(value: 10)
        addCompanyView.isHidden = true
        addCompanyView.alpha = 0.0
        
        addCompanyView.layer.shadowColor = UIColor.black.cgColor
        addCompanyView.layer.shadowOpacity = 0.65
        addCompanyView.layer.shadowOffset = .zero
        
        existingCompanyButton.setBorder(width: 2.0, color: UIColor.white.cgColor)
        existingCompanyButton.roundAllCorners(value: 15)
        
        newCompanyButton.setBorder(width: 2.0, color: UIColor.white.cgColor)
        newCompanyButton.roundAllCorners(value: 15)
        
        cancelCompanyButton.setBorder(width: 1.0, color: ThemeColors.beige.cgcolor)
        cancelCompanyButton.roundAllCorners(value: 15)
     
        super.initView(inController: inController)
    }
    
    // MARK: - METHODS
    func setProjectRecord(project: Project? = nil) {
        
        if project != nil { theProject = project }
        
        titleLabel.text = theProject!.name
        reloadcompaniesTable()
    }
    
    func reloadcompaniesTable() {
    
        theCompanies.removeAll()
        
        for setItem in theProject!.companies! { theCompanies.append(setItem as! Company) }
    
        theCompanies.sort { $0.name! < $1.name! }
        companiesTableView.reloadData()
    
        let description = theProject!.team!.count == 1 ?  "Company" : "Companies"
        recordCountLabel.text = String(format: "%d " + description, theProject!.companies!.count )
    }
   
    
    // MARK: - ACTION HANDLERS
    @IBAction func onPlusMinus(_ sender: Any) {
        
        returnButton.isEnabled = false
        plusMinusButton.isEnabled = false
        
        addCompanyView.isHidden = false
        UIView.animate(withDuration:0.25, animations: { self.addCompanyView.alpha = 1.0 })
    }
    
    @IBAction func onChoose(_ sender: Any) {
        
        parentController!.projectController.projectCompanySelectionView.theProject = theProject!
        parentController!.projectController.projectCompanySelectionView.loadView(companies: theCompanies)
        parentController!.projectController.projectCompanySelectionView.showView(withTabBar: false)
        
        addCompanyView.alpha = 0.0
        addCompanyView.isHidden = true
        
        returnButton.isEnabled = true
        plusMinusButton.isEnabled = true
    }
    
    @IBAction func onCreate(_ sender: Any) {
        
        let editView = parentController!.companyController.companyEditView
        
        if editView != nil {
            
            if editView!.parentController == nil {
                
                editView!.initView(inController: parentController!.companyController)
            }
        }
        
        editView!.isFromProject = theProject!
        editView!.setCompanyRecord(newCompany: true)
        
        parentController!.gotoTab(Tabs.companies, showingView: parentController!.companyController.companyEditView, fade: false, withTabBar: false)
        
        addCompanyView.alpha = 0.0
        addCompanyView.isHidden = true
        
        returnButton.isEnabled = true
        plusMinusButton.isEnabled = true
    }
    
    @IBAction func onCancel(_ sender: Any) {
        
        returnButton.isEnabled = true
        plusMinusButton.isEnabled = true
        
        addCompanyView.alpha = 0.0
        addCompanyView.isHidden = true
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.projectController.projectDetailsView.showView(withTabBar: false)
    }
}

extension ProjectCompanyView: UITableViewDelegate, UITableViewDataSource {
   
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
         
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { theCompanies.count }
        
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 80 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCompaniesListStyle", for: indexPath) as! CompanyListCell
        let company = theCompanies[indexPath.row]
        
        cell.theCompany = company
        cell.parentController = parentController!
        
        if company.hasPhoto { cell.companyImageView.image = UIImage(data: Data(base64Encoded: company.photo!)!)}
        else { cell.companyImageView.image = GlobalData.shared.contactNoPhoto }
        
        cell.companyNameLabel.text = company.name!
        
        if parentController!.contactController.coreData!.addressIsIncomplete(theCompany: company) {
            
            cell.locationLabel.text = "Address is incomplete"
        }
        else {
            
            cell.locationLabel.text = company.city!
            if company.state! != "" { cell.locationLabel.text! += ( ", " + company.state!) }
        }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return cell
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if parentController!.companyController.companyDetailsView!.parentController == nil {
            
            parentController!.companyController.companyDetailsView!.initView(inController: parentController!.companyController)
        }
      
        parentController!.companyController.launchPrimaryView = false
        parentController!.companyController.companyDetailsView!.thelastTab = Tabs.projects
        parentController!.companyController.companyDetailsView!.setCompanyRecord(company: theCompanies[indexPath.row])
        parentController!.gotoTab(Tabs.companies, showingView: parentController!.companyController.companyDetailsView!, withTabBar: false)
    }
    
    // Allow row move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Move a row
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let itemToMove = theCompanies[sourceIndexPath.row]
        theCompanies.remove(at: sourceIndexPath.row)
        theCompanies.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    // Don't indent in edit mode
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { return false }
         
    // Show only drag bars
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {  return .none }
}

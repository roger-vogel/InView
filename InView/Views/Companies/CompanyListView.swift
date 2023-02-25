//
//  CompanyListView.swift
//  InView
//
//  Created by Roger Vogel on 10/3/22.
//

import UIKit
import AlertManager

class CompanyListView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var addCompanyButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var companiesTableView: UITableView!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var editModeButton: UIButton!
    
    // MARK: - PROPERTIES
    var sectionTitles = [CompanySectionTitle]()
    var searchCompanies = [Company]()
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        super.initView(inController: inController)
     
        companiesTableView.delegate = self
        companiesTableView.dataSource = self
        
        companiesTableView.sectionHeaderTopPadding = 0
        companiesTableView.sectionIndexMinimumDisplayRowCount = 15
        companiesTableView.separatorStyle = .none
        companiesTableView.isEditing = false
     
        theMenuButton = menuButton
    }
    
    override func setupView() {
        
        guard parentController != nil else { return }
        
        let companies = parentController!.contactController.coreData!.companies!
        
        sectionTitles.removeAll()
        searchCompanies.removeAll()
        
        if !companies.isEmpty {
            
            if searchTextField.text!.isEmpty {
                
                if GlobalData.shared.companySort == .name {
                    
                    for title in GlobalData.shared.indexTitles {
                        
                        let companies = parentController!.contactController.coreData!.companies!.filter { $0.name!.first != nil && $0.name! != "" && $0.name! != "Unnamed Company" && String($0.name!.first!).uppercased() == title }
                        if companies.count > 0 {  sectionTitles.append(CompanySectionTitle(title: title, theCompanies: companies)) }
                    }
                    
                    // Check for blanks
                    var blankCompanies = [Company]()
                    
                    for company in parentController!.contactController.coreData!.companies! {
                        
                        if company.name! == "" {
                            
                            company.name = "Unnamed Company"
                            blankCompanies.append(company)
                        }
                    }
                    
                    if !blankCompanies.isEmpty {
                        
                        sectionTitles.append(CompanySectionTitle(title: "No Last Name", theCompanies: blankCompanies))
                    }
                    
                } else if GlobalData.shared.companySort == .city {
                    
                    for title in GlobalData.shared.indexTitles {
                        
                        let companies = parentController!.contactController.coreData!.companies!.filter { $0.city!.first != nil && $0.city! != "" && $0.city! != "City Not Specified" && String($0.city!.first!).uppercased() == title }
                        if companies.count > 0 {  sectionTitles.append(CompanySectionTitle(title: title, theCompanies: companies)) }
                    }
                    
                    // Check for blanks
                    var blankCompanies = [Company]()
                    
                    for company in parentController!.contactController.coreData!.companies! {
                        
                        if company.city! == "" {
                            
                            company.city = "City Not Specified"
                            blankCompanies.append(company)
                        }
                    }
                    
                    if !blankCompanies.isEmpty {
                        
                        sectionTitles.append(CompanySectionTitle(title: "City Not Specified", theCompanies: blankCompanies))
                    }
                    
                } else {
                    
                    for title in GlobalData.shared.indexTitles {
                        
                        let companies = parentController!.contactController.coreData!.companies!.filter { $0.market!.area != nil && $0.market!.area! != "" && $0.market!.area! != "Market Not Specified" && String($0.market!.area!.first!).uppercased() == title }
                        if companies.count > 0 {  sectionTitles.append(CompanySectionTitle(title: title, theCompanies: companies)) }
                    }
                    
                    // Check for blanks
                    var blankCompanies = [Company]()
                    
                    for company in parentController!.contactController.coreData!.companies! {
                        
                        if company.city! == "" {
                            
                            company.city = "Market Not Specified"
                            blankCompanies.append(company)
                        }
                    }
                    
                    if !blankCompanies.isEmpty {
                        
                        sectionTitles.append(CompanySectionTitle(title: "Market Not Specified", theCompanies: blankCompanies))
                    }
                }
                
            } else { searchCompanies = parentController!.contactController.coreData!.companies!.filter { $0.name!.uppercased().contains(searchTextField.text!.uppercased())}}
            
        }
        
        for companies in sectionTitles { companies.sortSectionItems() }
        companiesTableView.reloadData()
      
        if searchTextField.text!.isEmpty {
           
            let description = parentController!.contactController.coreData!.companies!.count == 1 ? "Company" : "Companies"
            recordCountLabel.text = String(format: "%d " + description, parentController!.contactController.coreData!.companies!.count )
            
        } else {
     
            let description = searchCompanies.count == 1 ? "Company" : "Companies"
            recordCountLabel.text = String(format: "%d " + description, searchCompanies.count )
        }
    }
    
    override func refresh() { setupView() }
  
    // MARK: ACTION HANDLERS
    @IBAction func onEditMode(_ sender: UIButton) {
        
        companiesTableView.isEditing = !companiesTableView.isEditing
        
        let buttonImage = companiesTableView.isEditing ? UIImage(systemName: "pencil.circle.fill") : UIImage(systemName: "pencil.circle")
        sender.setImage(buttonImage, for: .normal)
    }
    
    @IBAction func onSearchPrimaryAction(_ sender: Any) { dismissKeyboard() }
    
    @IBAction func onEditChange(_ sender: Any) { setupView() }
        
    @IBAction func onMenu(_ sender: Any) {
        
        menuButton.isHidden = true
        
        initMenu()
        theMenuView!.showMenu()
    }
    
    @IBAction func onPlus(_ sender: Any) {
        
        parentController!.companyController.companyEditView.setCompanyRecord(newCompany: true)
        parentController!.companyController.companyEditView.showView(withTabBar: false)
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension CompanyListView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if searchTextField.text!.isEmpty { return sectionTitles.count }
        return 1
    }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard !sectionTitles.isEmpty else { return searchCompanies.count }
        
        if searchTextField.text!.isEmpty { return sectionTitles[section].companies.count }
        return searchCompanies.count
    }
  
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 70 }
    
    // View for headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard !sectionTitles.isEmpty else { return nil }
        
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 120))
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width-25, height: 28))
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 6.5, width: tableView.frame.size.width, height: 15))
        
        sectionHeaderView.addSubview(headerLabel)
        sectionHeaderView.backgroundColor = .clear
        
        sectionHeaderView.addSubview(backgroundView)
        backgroundView.backgroundColor = ThemeColors.brown.uicolor
        backgroundView.roundAllCorners(value: 5)
     
        sectionHeaderView.addSubview(headerLabel)
        headerLabel.textColor = ThemeColors.aqua.uicolor
        headerLabel.backgroundColor = .clear
        headerLabel.font = UIFont.systemFont(ofSize: 13)
        headerLabel.text = sectionTitles[section].indexTitle
        
        return sectionHeaderView
    }
    
    // Provide section index titles
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        guard !sectionTitles.isEmpty else { return nil }
      
        var indexTitles = [String]()
        for title in sectionTitles { indexTitles.append("     " + title.indexTitle!) }
        return indexTitles
    }

    // Provide section index for a given title
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int { return index }
      
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var company: Company?
        let cell = tableView.dequeueReusableCell(withIdentifier: "companyListStyle", for: indexPath) as! CompanyListCell
        
        if searchTextField.text!.isEmpty { company = sectionTitles[indexPath.section].companies[indexPath.row] }
        else { company = searchCompanies[indexPath.row] }
        
        if company!.hasPhoto { cell.companyImageView.image = UIImage(data: Data(base64Encoded: company!.photo!)!)}
        else { cell.companyImageView.image = GlobalData.shared.companyNoPhoto }
        
        cell.companyNameLabel.text = company!.name!
        
        if parentController!.contactController.coreData!.addressIsIncomplete(theCompany: company!) {
            
            cell.locationLabel.text = "Address is incomplete"
        }
        else {
            
            cell.locationLabel.text = company!.city!
            if company!.state! != "" { cell.locationLabel.text! += ( ", " + company!.state!) }
        }
        
        if searchTextField.text!.isEmpty {
            
            if indexPath.row == sectionTitles[indexPath.section].companies.count-1 { cell.dividerLabel.isHidden = true }
            else { cell.dividerLabel.isHidden = false }
        }
    
        return cell
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let company = searchTextField.text!.isEmpty ? sectionTitles[indexPath.section].companies[indexPath.row] : searchCompanies[indexPath.row]
        
        parentController!.companyController.companyDetailsView.setCompanyRecord(company: company)
        parentController!.companyController.companyDetailsView.showView(withTabBar: false)
    }
    
    // Allow row move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return false }
    
    // Allows editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Delete company
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let company = parentController!.contactController.coreData!.companies![indexPath.row]
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Delete Company" ,aMessage: "Are you sure you want to delete " + company.name! + "?", buttonTitles: ["CANCEL","DELETE"], theStyle: [.cancel,.destructive], theType: .actionSheet) { choice in
                
                if choice == 1 {
                    
                    let company = self.sectionTitles[indexPath.section].companies[indexPath.row]
                    let index = self.parentController!.contactController.coreData!.companyIndex(company: company)
                    
                    guard index != nil else { return }
                    self.parentController!.contactController.coreData!.companies!.remove(at: index!)
                    
                    GlobalData.shared.viewContext.delete(company)
                    GlobalData.shared.saveCoreData()
                    
                    if self.parentController!.contactController.coreData!.companies!.isEmpty && self.companiesTableView.isEditing { self.onEditMode(self.editModeButton) }
                    self.setupView()
                }
            }
        }
    }
}

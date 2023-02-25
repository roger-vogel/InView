//
//  ParentProjectListView.swift
//  InView
//
//  Created by Roger Vogel on 10/22/22.
//

import UIKit

class ParentProjectListView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    var theTitleLabel: UILabel!
    var theProjectTableView: UITableView!
    var theRecordCountLabel: UILabel!
    
    // MARK: - PROPERTIES
    var theContact: Contact?
    var theCompany: Company?
    var theProjects = [Project]()
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
       
        theProjectTableView!.delegate = self
        theProjectTableView!.dataSource = self
        theProjectTableView.sectionHeaderTopPadding = 10
        theProjectTableView.sectionIndexMinimumDisplayRowCount = 15
        theProjectTableView.separatorColor = ThemeColors.deepAqua.uicolor
        
        super.initView(inController: inController)
    }
   
    // MARK: - METHODS
    func setContact(_ contact: Contact? = nil) {
        
        if contact != nil { theContact = contact! }
        
        theProjects.removeAll()
        
        for project in theContact!.projects! { theProjects.append(project as! Project) }
        
        setRecordCount()
        theTitleLabel.text = "Projects Attached to " + theContact!.firstName! + " " + theContact!.lastName!
        
        theProjectTableView.reloadData()
    }
    
    func setCompany(_ company: Company? = nil) {
        
        if company != nil { theCompany = company }
        
        theProjects.removeAll()
        
        for project in theCompany!.projects! { theProjects.append(project as! Project) }
        
        setRecordCount()
        theTitleLabel.text = theCompany!.name! + " Projects"
        
        theProjectTableView.reloadData()
    }
    
    func setRecordCount() {
        
        let description = theProjects.count == 1 ? "Project" : "Projects"
        theRecordCountLabel.text = String(format: "%d " + description, theProjects.count )
    }
    
    func setReturnTab(forView: ParentView) { /* Placeholder */ }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ParentProjectListView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return theProjects.count }
          
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 40 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commonProjectListStyle", for: indexPath) as! CommonListCell
        
        cell.projectName.text = theProjects[indexPath.row].name!
        
        if theProjects[indexPath.row].city != nil { cell.projectCity.text = theProjects[indexPath.row].city! }
            
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        cell.backgroundColor = indexPath.row % 2 == 0 ? ThemeColors.beige.uicolor : ThemeColors.beige.uicolor
        
        return cell
    }
    
    // On selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        parentController!.projectController.launchPrimaryView = false
        
        if parentController!.projectController.projectDetailsView.parentController == nil {
            
            parentController!.projectController.projectDetailsView.initView(inController: parentController!.projectController)
        }
        
        let theLastTab = theContact == nil ? Tabs.companies : Tabs.contacts
        parentController!.projectController.projectDetailsView.setEditMode(false)
        parentController!.projectController.projectDetailsView.thelastTab = theLastTab
        parentController!.gotoTab(Tabs.projects, showingView: parentController!.projectController.projectDetailsView, fade: false, withTabBar: false)
    }
}

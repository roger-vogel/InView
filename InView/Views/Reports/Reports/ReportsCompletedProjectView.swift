//
//  ReportsCompletedProjectView.swift
//  InView
//
//  Created by Roger Vogel on 2/17/23.
//

import UIKit
import DateManager

class ReportsCompletedProjectView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var projectsTableView: UITableView!
    
    // MARK: - PROPERTIES
    var theProjects: [Project]?
   
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
        projectsTableView.separatorColor = ThemeColors.aqua.uicolor
        projectsTableView.allowsSelection = true
        projectsTableView.separatorColor = ThemeColors.deepAqua.uicolor
        projectsTableView.addTopBorder(with: ThemeColors.aqua.uicolor, andWidth: 1.0)
        
        super.initView(inController: inController)
    }
    
    override func setupView() {
        
        theProjects = parentController!.contactController.coreData!.projects!.filter { $0.status == "Closed"}
        projectsTableView.reloadData()
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.projectController.reportsMenuView.showView(withTabBar: false)
    }
    
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ReportsCompletedProjectView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard theProjects != nil else { return 0 }
        return theProjects!.count
    }
         
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 44 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "completedProjectListStyle", for: indexPath) as! ReportsCompleteListCell
        let project = theProjects![indexPath.row]
    
        cell.theProject = project
        cell.projectNameTextField.text = project.name!
        cell.dateTextField.text = DateManager(date: project.completionDate).dateString
       
        return cell
    }
    
    // On selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ReportsCompleteListCell
        
        parentController!.projectController.projectDetailsView.thelastTab = Tabs.projects
        parentController!.projectController.projectDetailsView.reportType = ReportTypes.funnelbyCompletedProjects
        parentController!.projectController.projectDetailsView.setProjectRecord(project: cell.theProject!,  isFromReport: true)
        parentController!.projectController.projectDetailsView.showView(withTabBar: false)
    }
}

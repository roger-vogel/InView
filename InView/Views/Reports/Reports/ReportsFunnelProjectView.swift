//
//  ReportsFunnelProjectView.swift
//  InView
//
//  Created by Roger Vogel on 2/14/23.
//

import UIKit

class ReportsFunnelProjectView: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - PROPERTIES
    var isFrom: IsFrom?
    var tableEntries = [Project]()
    
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
        
        projectsTableView.reloadData()
    }
    
    // MARK: - METHODS
    func setSource(isFrom: IsFrom, filteredBy: String, withTitle: String) {
    
        self.isFrom = isFrom
        
        if isFrom == .byStart {
            
            tableEntries = parentController!.contactController.coreData!.projects!.filter { $0.start == Int64(filteredBy) }
      
        } else if isFrom == .byStage {
            
            tableEntries = parentController!.contactController.coreData!.projects!.filter { $0.stage == filteredBy }
            
        } else {
            
           
        }
        
        titleLabel.text = withTitle
        projectsTableView.reloadData()
    }
    
    func setSource(isFrom: IsFrom, projects: [Project], title: String) {
        
        self.isFrom = isFrom
        titleLabel.text = title
        tableEntries = projects
        projectsTableView.reloadData()
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {

        switch isFrom {

            case .byStart: parentController!.projectController.reportsFunnelByStartView.showView(withTabBar: false)
            case .byStage: parentController!.projectController.reportsFunnelByStageView.showView(withTabBar: false)
            case .byProduct: parentController!.projectController.reportsFunnelByProductView.showView(withTabBar: false)

            default: break
        }
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ReportsFunnelProjectView: UITableViewDelegate, UITableViewDataSource {
    
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tableEntries.count }
         
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 44 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "funnelProjectListStyle", for: indexPath) as! FunnelProjectListCell
        
        cell.theProject = tableEntries[indexPath.row]
        cell.projectNameTextField.text = tableEntries[indexPath.row].name!
       
        return cell
    }
    
    // On selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FunnelProjectListCell
        
        parentController!.projectController.projectDetailsView.thelastTab = Tabs.projects
        parentController!.projectController.projectDetailsView.reportType = ReportTypes.funnelbyProject
        parentController!.projectController.projectDetailsView.setProjectRecord(project: cell.theProject!,  isFromReport: true)
        parentController!.projectController.projectDetailsView.showView(withTabBar: false)
    }
}

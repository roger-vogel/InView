//
//  ProjectViewController.swift
//  InView
//
//  Created by Roger Vogel on 9/23/22.
//

import UIKit

class ProjectViewController: ParentViewController {
  
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet var projectListView: ProjectListView!
    @IBOutlet var projectDetailsView: ProjectDetailsView!
    @IBOutlet var projectTeamView: ProjectTeamView!
    @IBOutlet var projectTeamSelectionView: ProjectTeamSelectionView!
    @IBOutlet var projectCompanyView: ProjectCompanyView!
    @IBOutlet var projectCompanySelectionView: ProjectCompanySelectionView!
    @IBOutlet var projectLogListView: ProjectLogListView!
    @IBOutlet var projectLogEntryView: ProjectLogEntryView!
    @IBOutlet var projectPhotoView: ProjectPhotoView!
    @IBOutlet var projectPhotoViewer: ProjectPhotoViewer!
    @IBOutlet var projectDocumentView: ProjectDocumentView!
    @IBOutlet var projectProductListView: ProjectProductListView!
    @IBOutlet var projectProductDetailsView: ProjectProductDetailsView!
    @IBOutlet var projectActivityListView: ProjectActivityListView!
    @IBOutlet var projectActivityMoveView: ProjectActivityMoveView!
    @IBOutlet var reportsMenuView: ReportsMenuView!
    @IBOutlet var settingsGoalView: SettingsGoalView!
    @IBOutlet var settingsByAccountView: SettingsByAccountView!
    @IBOutlet var settingsByProductView: SettingsByProductView!
    @IBOutlet var reportsTotalSalesView: ReportsTotalSalesView!
    @IBOutlet var reportsByAccountView: ReportsByAccountView!
    @IBOutlet var reportsByProductView: ReportsByProductView!
    @IBOutlet var reportsFunnelByStartView: ReportsFunnelByStartView!
    @IBOutlet var reportsFunnelByStageView: ReportsFunnelByStageView!
    @IBOutlet var reportsFunnelByProductView: ReportsFunnelByProductView!
    @IBOutlet var reportsFunnelProjectView: ReportsFunnelProjectView!
    @IBOutlet var reportsCompletedProjectView: ReportsCompletedProjectView!
    
    // MARK: - INITIALIZATION¸
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addSubViews(subViews: [
            
            projectListView,
            projectDetailsView,
            projectTeamView,
            projectTeamSelectionView,
            projectLogListView,
            projectLogEntryView,
            projectPhotoView,
            projectPhotoViewer,
            projectDocumentView,
            projectProductListView,
            projectProductDetailsView,
            projectActivityListView,
            projectCompanyView,
            projectCompanySelectionView,
            projectActivityMoveView,
            reportsMenuView,
            settingsGoalView,
            settingsByAccountView,
            settingsByProductView,
            reportsTotalSalesView,
            reportsByAccountView,
            reportsByProductView,
            reportsFunnelByStartView,
            reportsFunnelByStageView,
            reportsFunnelByProductView,
            reportsFunnelProjectView,
            reportsCompletedProjectView
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
      
        if launchPrimaryView {
            
            projectListView.showView(withFade: false, withTabBar: true)
        
        } else {
            
            if nonPrimaryView != nil {
                
                nonPrimaryView!.showView(withFade: false, withTabBar: false)
                nonPrimaryView = nil
            }
            
            launchPrimaryView = true
        }
    }
}

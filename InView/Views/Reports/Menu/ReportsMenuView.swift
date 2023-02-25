//
//  ReportsMenuView.swift
//  InView
//
//  Created by Roger Vogel on 2/5/23.
//

import UIKit

class ReportsMenuView: ParentView {

    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var chooseReportView: UIView!
    @IBOutlet weak var goalsSetupButton: UIButton!
    @IBOutlet weak var byAccountSetupButton: UIButton!
    @IBOutlet weak var byCategorySetupButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    
    // MARK: - PROPERTIES
    var fromTab: Int?
   
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        super.initView(inController: inController)
        
        chooseReportView.setBorder(width: 2.0, color: UIColor.white.cgColor)
        chooseReportView.roundAllCorners(value: 10)
        chooseReportView.isHidden = true
        chooseReportView.alpha = 0.0
        
        chooseReportView.layer.shadowColor = UIColor.black.cgColor
        chooseReportView.layer.shadowOpacity = 0.65
        chooseReportView.layer.shadowOffset = .zero
        
        goalsSetupButton.setBorder(width: 2.0, color: UIColor.white.cgColor)
        goalsSetupButton.roundAllCorners(value: 15)
        
        byAccountSetupButton.setBorder(width: 2.0, color: UIColor.white.cgColor)
        byAccountSetupButton.roundAllCorners(value: 15)
        
        byCategorySetupButton.setBorder(width: 2.0, color: UIColor.white.cgColor)
        byCategorySetupButton.roundAllCorners(value: 15)
        
        doneButton.setBorder(width: 1.0, color: ThemeColors.beige.cgcolor)
        doneButton.roundAllCorners(value: 15)
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onGoalSettings(_ sender: Any) { parentController!.projectController.settingsGoalView.showView(withTabBar: false) }
   
    @IBAction func onMenuButton(_ sender: UIButton) {
        
        switch sender.tag {
            
            case 0:
                parentController!.projectController.reportsTotalSalesView.showView(withFade: true, withTabBar: false)
                
            case 1:
                parentController!.projectController.reportsByAccountView.showView(withFade: true, withTabBar: false)
            
            case 2:
                parentController!.projectController.reportsByProductView.showView(withFade: true, withTabBar: false)
            
            case 3:
                parentController!.projectController.reportsFunnelByStartView.showView(withFade: true, withTabBar: false)
            
            case 4:
                parentController!.projectController.reportsFunnelByStageView.showView(withFade: true, withTabBar: false)
            
            case 5:
                parentController!.projectController.reportsFunnelByProductView.showView(withFade: true, withTabBar: false)
            
            case 6:
                parentController!.projectController.reportsCompletedProjectView.showView(withFade: true, withTabBar: false)
                
            default: break
        }
    }
    
    @IBAction func onSettings(_ sender: Any) {
        
        settingsButton.isEnabled = false
        settingsButton.alpha = 0.50
        returnButton.isEnabled = false
        chooseReportView.isHidden = false
        
        UIView.animate(withDuration:0.25, animations: { self.chooseReportView.alpha = 1.0 })
    }
 
    @IBAction func onByAccount(_ sender: Any) { parentController!.projectController.settingsByAccountView.showView(withTabBar: false) }
 
    @IBAction func onByProduct(_ sender: Any) { parentController!.projectController.settingsByProductView.showView(withTabBar: false) }
    
    @IBAction func onDone(_ sender: Any) {
        
        chooseReportView.alpha = 0.0
        chooseReportView.isHidden = true
        settingsButton.isEnabled = true
        settingsButton.alpha = 1.0
        returnButton.isEnabled = true
    }
    
    @IBAction func onReturn(_ sender: Any) {
        
        guard fromTab != nil  else {
            
            parentController!.tabBarController!.tabBar.isHidden = false
            parentController!.projectController.projectListView.showView()
            return
        }
             
        parentController!.controllerFor(tab: fromTab!)!.gotoTab(fromTab!)
        fromTab = nil
    }
}

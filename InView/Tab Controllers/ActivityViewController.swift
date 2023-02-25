//
//  ActivityViewController.swift
//  InView
//
//  Created by Roger Vogel on 9/23/22.
//

import UIKit

class ActivityViewController: ParentViewController {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet var activityListView: ActivityListView!
    @IBOutlet var taskDetailsView: TaskDetailsView!
    @IBOutlet var eventDetailsView: EventDetailsView!
    @IBOutlet var activityCalendarView: ActivityCalendarView!
    @IBOutlet var activityContactSelectionView: ActivityContactSelectionView!
    @IBOutlet var activityCompanySelectionView: ActivityCompanySelectionView!
    @IBOutlet var activityProjectSelectionView: ActivityProjectSelectionView!
    @IBOutlet var activityMoveView: ActivityMoveView!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addSubViews(subViews: [
            
            activityListView,
            taskDetailsView,
            eventDetailsView,
            activityCalendarView,
            activityContactSelectionView,
            activityCompanySelectionView,
            activityProjectSelectionView,
            activityMoveView
        ])
    } 
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(false)
        
        if launchPrimaryView {
            
            activityListView.showView(withFade: false, withTabBar: true)
            
        } else {
            
            if nonPrimaryView != nil {
                
                nonPrimaryView!.showView(withFade: false, withTabBar: false)
                nonPrimaryView = nil
            }
            
            launchPrimaryView = true
        }
    }
}

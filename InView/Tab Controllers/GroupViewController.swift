//
//  GroupViewController.swift
//  InView
//
//  Created by Roger Vogel on 9/23/22.
//

import UIKit

class GroupViewController: ParentViewController {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet var groupListView: GroupListView!
    @IBOutlet var groupDetailsView: GroupDetailsView!
    @IBOutlet var memberSelectionView: MemberSelectionView!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addSubViews(subViews: [groupListView,groupDetailsView,memberSelectionView])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if launchPrimaryView {
            
            groupListView.showView(withFade: false, withTabBar: true)
           
        } else {
            
            if nonPrimaryView != nil {
                
                nonPrimaryView!.showView(withFade: false, withTabBar: false)
                nonPrimaryView = nil
            }
            
            launchPrimaryView = true
        }
    }
}

//
//  ProjectListCell.swift
//  InView
//
//  Created by Roger Vogel on 10/6/22.
//

import UIKit

class ProjectListCell: UITableViewCell {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var projectNameLabel: UITextField!
    @IBOutlet weak var projectCityLabel: UITextField!
    
    // MARK: - PROPERTIES
    var theProject: Project?
}

//
//  ProjectListView.swift
//  InView
//
//  Created by Roger Vogel on 10/6/22.
//

import UIKit
import AlertManager

class ProjectListView: ParentView {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var editModeButton: UIButton!
    @IBOutlet weak var addProjectButton: UIButton!
    @IBOutlet weak var projectTableView: UITableView!
    @IBOutlet weak var sortPickerView: UIPickerView!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var sortLabel: UILabel!
 
    // MARK: - PROPERTIES
    var isSorting: Bool = false
    var searchProjects = [Project]()
    var theProjects = [Project]()
    var currentSort: SortMethod = .alpha
    var sortField = ["Alphabetically","Newest on Top","Market Area","City"]
    
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        projectTableView.delegate = self
        projectTableView.dataSource = self
        projectTableView.sectionHeaderTopPadding = 0
        projectTableView.sectionIndexMinimumDisplayRowCount = 15
        projectTableView.separatorColor = ThemeColors.deepAqua.uicolor
        
        sortPickerView.delegate = self
        sortPickerView.dataSource = self
        sortPickerView.isHidden = true
        sortPickerView.setBorder(width: 1.0, color: ThemeColors.teal.cgcolor)
        sortPickerView.roundCorners(corners: .bottom)
        
        theMenuButton = menuButton
     
        super.initView(inController: inController)
    }
    
    override func setupView() {
        
        sortButton.setImage(UIImage(systemName: "arrow.up.arrow.down.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        
        searchProjects.removeAll()
        
        theProjects = parentController!.contactController.coreData!.projects!
      
        if theProjects.count > 0 {
            
            switch currentSort {
                
                case .alpha:
                    theProjects.sort { $0.name! < $1.name! }
                    sortLabel.text = "Sorted by Name"
                case .date:
                    theProjects.sort { $0.timestamp! > $1.timestamp! }
                    sortLabel.text = "Sorted by Most Recent Date"
                case .market:
                    theProjects.sort { $0.market! < $1.market! }
                    sortLabel.text = "Sorted by Market Area"
                case .city:
                    theProjects.sort { $0.city! < $1.city! }
                    sortLabel.text = "Sorted by City"
                case .none:
                    sortLabel.text!.removeAll()
           
            }
            
        } else { sortLabel.text!.removeAll() }
       
        if !searchTextField.text!.isEmpty {
            
            searchProjects = parentController!.contactController.coreData!.projects!.filter { $0.name!.uppercased().contains(searchTextField.text!.uppercased())}
       
            let description = searchProjects.count == 1 ? "Project" : "Projects"
            recordCountLabel.text = String(format: "%d " + description, searchProjects.count )
    
        } else {
            
            let description = theProjects.count == 1 ? "Project" : "Projects"
            recordCountLabel.text = String(format: "%d " + description, theProjects.count )
        }
        
        projectTableView.reloadData()
    }
    
    override func refresh() { setupView() }
    
    // MARK: - METHODS
    func setSort(_ toState: Bool) {
        
        isSorting = toState
        
        if isSorting {
            
            if currentSort == .none { currentSort = .alpha; setupView() }
                
            sortButton.setImage(UIImage(systemName: "arrow.up.arrow.down.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            sortPickerView.isHidden = false
    
        } else {
            
            sortButton.setImage(UIImage(systemName: "arrow.up.arrow.down.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            sortPickerView.isHidden = true
            setupView()
        }
    }
 
    // MARK: - ACTION HANDLERS
    @IBAction func onSearchPrimaryAction(_ sender: Any) { dismissKeyboard() }
    
    @IBAction func onEditChange(_ sender: Any) { setupView() }
    
    @IBAction func onAdd(_ sender: Any) {
        
        parentController!.projectController.projectDetailsView.setProjectRecord()
        parentController!.projectController.projectDetailsView.showView(withTabBar: false)
    }
   
    @IBAction func onEditMode(_ sender: UIButton) {
        
        guard !parentController!.contactController.coreData!.projects!.isEmpty else { return }
        
        projectTableView.isEditing = !projectTableView.isEditing
        
        var buttonImage: UIImage?
        buttonImage = projectTableView.isEditing ? UIImage(systemName: "pencil.circle.fill") : UIImage(systemName: "pencil.circle")
        
        sender.setImage(buttonImage, for: .normal)
    }
   
    @IBAction func onSort(_ sender: Any) { setSort(!isSorting) }
  
    @IBAction func onMenu(_ sender: Any) {
        
        menuButton.isHidden = true
        
        initMenu()
        theMenuView!.showMenu()
    }
}

// MARK: - PICKER PROTOCOL
extension ProjectListView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView,  rowHeightForComponent component: Int) -> CGFloat { return 30 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return sortField.count }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return sortField[row] }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        switch row {
            
            case 0: currentSort = .alpha
            case 1: currentSort = .date
            case 2: currentSort = .market
            case 3: currentSort = .city
            
            default: break
        }
        
      setSort(false)
    }
}

// MARK: - TABLE VIEW DELEGATE PROTOCOL
extension ProjectListView: UITableViewDelegate, UITableViewDataSource {
   
    // Report number of sections
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
   
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if searchTextField.text!.isEmpty { return theProjects.count }
        return searchProjects.count
    }
  
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 70 }
    
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var project: Project?
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectListStyle", for: indexPath) as! ProjectListCell
        
        if searchTextField.text!.isEmpty { project = theProjects[indexPath.row] }
        else { project = searchProjects[indexPath.row] }
        
        cell.theProject = project
        cell.projectNameLabel.text = project!.name!
        
        if project!.state != nil && project!.city != nil {
            
            cell.projectCityLabel.text = project!.state! != "" && project!.city! != "" ? project!.city! + ", " + project!.state! : "No address specified"
      
        } else {
            
            cell.projectCityLabel.text = "Incomplete address"
        }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
      
        return cell
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        parentController!.projectController.projectDetailsView.setProjectRecord(project: theProjects[indexPath.row])
        parentController!.projectController.projectDetailsView.showView(withTabBar: false)
    }
    
    // Allow row move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Move a row
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let itemToMove = theProjects[sourceIndexPath.row]
        theProjects.remove(at: sourceIndexPath.row)
        theProjects.insert(itemToMove, at: destinationIndexPath.row)
        
        currentSort = .none
        setupView()
    }
    
    // Indent in edit mode
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { return false }
         
    // Show delete and drag bars
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {  return .delete }
    
    // Allow editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Delete project
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let project = theProjects[indexPath.row]
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Delete Project", aMessage: "Are you sure you want to delete " + project.name! + "?", buttonTitles: ["CANCEL","DELETE"], theStyle: [.cancel,.destructive], theType: .actionSheet) { choice in
                
                if choice == 1 {
                    
                    let project = (tableView.cellForRow(at: indexPath) as! ProjectListCell).theProject!
                    let index = self.parentController!.contactController.coreData!.projectIndex(project: project)
              
                    self.parentController!.contactController.coreData!.projects!.remove(at: index!)
                  
                    GlobalData.shared.viewContext.delete(project)
                    GlobalData.shared.saveCoreData()
                    
                    if self.parentController!.contactController.coreData!.projects!.isEmpty && self.projectTableView.isEditing { self.onEditMode(self.editModeButton) }
                    self.setupView()
                }
            }
        }
    }
}

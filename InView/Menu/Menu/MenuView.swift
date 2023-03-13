//
//  MenuView.swift
//  Flirté
//
//  Created by Roger Vogel on 5/10/22.
//

import UIKit

class MenuView: UIView {
    
    // MARK: - PROPERTIES
    let menuController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuController") as UIViewController
    
    var isLogout = false
    var closeButton: UIButton?
    var parentView: ParentView?
    var menuTableView: UITableView?
    var preselectedValue: Menu?
    var menuItems = ["Sort Preferences","Find Duplicates","Import Contacts","Customer Categories","Company Categories","Products","Product Categories","Market Areas","Setup Company Invoice","Reports"]
   
    weak var delegate: MenuViewDelegate?
    
    // MARK: - INITIALIZATION
    
    func initMenu(_ theView: ParentView) {
        
        delegate = theView
        parentView = theView
      
        self.frame = theView.frame
        self.frame.size.width = 0
        self.alpha = 0.95
        self.backgroundColor = .white
        
        let closeImage = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        
        closeButton = UIButton(frame: CGRect(x: 10, y: 64, width: 40, height: 40))
        closeButton!.setImage(closeImage, for: .normal)
        closeButton!.tintColor = .black
        closeButton!.addTarget(self, action: #selector(hideMenu), for: .touchUpInside)
        closeButton!.isHidden = true
        
        menuTableView = UITableView(frame: CGRect(x: 0, y: 150, width: self.frame.width, height: self.frame.height))
        menuTableView!.delegate = self
        menuTableView!.dataSource = self
        
        menuTableView!.backgroundColor = .clear
        menuTableView!.separatorStyle = .singleLine
        menuTableView!.separatorColor = ThemeColors.aqua.uicolor
        menuTableView!.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: frame.size.width)
        menuTableView!.allowsSelection = true
        menuTableView!.register(UITableViewCell.self, forCellReuseIdentifier: "menuStyle")
       
        if GlobalData.shared.preselectedMenuOption != nil {
            
            menuTableView!.selectRow(at: IndexPath(row: GlobalData.shared.preselectedMenuOption!, section: 0), animated: false, scrollPosition: .top)
            GlobalData.shared.preselectedMenuOption = nil
        }
        
        if #available(iOS 15, *) { menuTableView!.sectionHeaderTopPadding = 0 }
    
        addSubview(closeButton!)
        addSubview(menuTableView!)
    }
    
    // MARK: - METHODS
    func setSortPreferences() {
        
        let controller = menuController as! MenuViewController
        
        controller.presentingController = parentView!.parentController!
        controller.viewToShow = controller.sortPreferencesView
        
        hideMenuNoFade()
        parentView!.parentController!.present(menuController, animated: true, completion: { return })
    }
    
    func findDuplicates() {
        
        let controller = menuController as! MenuViewController
        
        controller.presentingController = parentView!.parentController!
        controller.viewToShow = controller.duplicatesView
        
        hideMenuNoFade()
        parentView!.parentController!.present(menuController, animated: true, completion: { return })
    }
    
    func importContacts() {
        
        let controller = menuController as! MenuViewController
        
        controller.presentingController = parentView!.parentController!
        controller.viewToShow = controller.importView
        
        hideMenuNoFade()
        parentView!.parentController!.present(menuController, animated: true, completion: { self.parentView!.parentController!.tabBarController!.tabBar.isHidden = false })
    }
    
    func setCustomerCategories() {
        
        let controller = menuController as! MenuViewController
        
        controller.presentingController = parentView!.parentController!
        controller.viewToShow = controller.customerCategoryView
        
        hideMenuNoFade()
        parentView!.parentController!.present(menuController, animated: true, completion: { return })
    }
    
    func setCompanyCategories() {
        
        let controller = menuController as! MenuViewController
        
        controller.presentingController = parentView!.parentController!
        controller.viewToShow = controller.companyCategoryView
        
        hideMenuNoFade()
        parentView!.parentController!.present(menuController, animated: true, completion: {return })
        
    }
    
    func gotoProductLibrary() {
        
        let controller = menuController as! MenuViewController
        
        controller.presentingController = parentView!.parentController!
        controller.viewToShow = controller.productListView
        controller.productListView.isFromMenu = true
        
        hideMenuNoFade()
        parentView!.parentController!.present(menuController, animated: true, completion: { return })
    }
    
    func setProductCategories() {
       
        let controller = menuController as! MenuViewController
        
        controller.presentingController = parentView!.parentController!
        controller.viewToShow = controller.productCategoryView
        
        hideMenuNoFade()
        parentView!.parentController!.present(menuController, animated: true, completion: { return })
    }
    
    func setMarketAreas() {
        
        let controller = menuController as! MenuViewController
        
        controller.presentingController = parentView!.parentController!
        controller.viewToShow = controller.marketAreaView
        
        hideMenuNoFade()
        parentView!.parentController!.present(menuController, animated: true, completion: { return })
    }
    
    func setupCompanyInvoice() {
        
        let controller = menuController as! MenuViewController
        
        controller.presentingController = parentView!.parentController!
        controller.viewToShow = controller.invoiceView
        
        hideMenuNoFade()
        parentView!.parentController!.present(menuController, animated: true, completion: { self.hideMenuNoFade() })
    }
    
    func gotoReports() {
        
    let controller = GlobalData.shared.activeController!
   
        guard controller.currentTab != Tabs.projects else {
            
            hideMenuNoFade()
            controller.projectController.reportsMenuView.showView(withFade: true, withTabBar: false)
           
            return
        }
        
        controller.projectController.reportsMenuView.fromTab = controller.currentTab
        controller.gotoTab(Tabs.projects, showingView: controller.projectController.reportsMenuView)
        
        hideMenuNoFade()
         
    }
    
    // MARK: - ACTION HANDLERS
    func showMenu() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.frame.size.width = self.parentView!.frame.width
            self.menuTableView!.frame.size.width = self.frame.width
            self.closeButton!.isHidden = false
            self.parentView!.parentController!.tabBarController!.tabBar.isHidden = true
            self.delegate!.menuDidShow()
        })
    }
    
    func hideMenuNoFade() {
        
        self.alpha = 0.0
    
        self.frame.size.width = 0
        self.menuTableView!.frame.size.width = self.frame.width
        self.closeButton!.isHidden = true
        self.delegate!.menuDidHide()
        
        self.alpha = 1.0
    }
    
    @objc func hideMenu() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.frame.size.width = 0
            self.menuTableView!.frame.size.width = self.frame.width
            self.closeButton!.isHidden = true
            self.delegate!.menuDidHide()
        })
           
        if !self.isLogout {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.30, execute: { self.parentView!.parentController!.tabBarController!.tabBar.isHidden = false })
            isLogout = false
        }
    }
}

extension MenuView: UITableViewDelegate, UITableViewDataSource {
 
    // Report the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return menuItems.count }
 
    // Report the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 40 }
      
    // Allow highlight
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Dequeue the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuStyle", for: indexPath)
        let selectedView = UIView()
        var content = cell.defaultContentConfiguration()
        
        selectedView.backgroundColor = ThemeColors.beige.uicolor
       
        content.text = menuItems[indexPath.row]
        content.textProperties.color = ThemeColors.aqua.uicolor
        content.textProperties.font = UIFont.systemFont(ofSize: 15, weight: .medium)
       
        cell.contentConfiguration = content
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = selectedView
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let chevron = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(scale: .small))!.withTintColor(.black, renderingMode: .alwaysOriginal)
        let chevronRight = UIImageView(image: chevron)
        cell.accessoryView = chevronRight
       
        return cell
    }
    
    // Capture selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
            case 0: setSortPreferences()
            case 1: findDuplicates()
            case 2: importContacts()
            case 3: setCustomerCategories()
            case 4: setCompanyCategories()
            case 5: gotoProductLibrary()
            case 6: setProductCategories()
            case 7: setMarketAreas()
            case 8: setupCompanyInvoice()
            case 9: gotoReports()
            
            default: break
        }
            
        tableView.deselectRow(at: indexPath, animated: false)
       // hideMenu(slide: true)
    }
    
}

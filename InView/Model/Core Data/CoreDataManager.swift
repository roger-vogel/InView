//
//  CoreDataManager.swift
//  InView
//
//  Created by Roger Vogel on 9/24/22.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    let appDelegate = GlobalData.shared.appDelegate
   
    // MARK: - CORE DATA CONTAINERS
    var parentController: ContactViewController?
    var completion: () -> Void
    var contacts: [Contact]?
    var companies: [Company]?
    var groups: [Group]?
    var projects: [Project]?
    var activities: [Activity]?
    var contactCategories: [ContactCategory]?
    var productCategories: [ProductCategory]?
    var companyCategories: [CompanyCategory]?
    var marketAreas: [MarketArea]?
    var defaultSorts: [DefaultSort]?
    var defaultInvoiceValues: [DefaultInvoiceValue]?
    var goals: [Goal]?
    var reports: [Report]?
    var products: [Product]?
    var counterArray: [InvCounter]?
  
    // MARK: - COMPUTED PROPERTIES
    var companyNames: [String] {
        
        var theCompanyNames = [String]()
        
        for company in companies! { theCompanyNames.append(company.name!) }
        return theCompanyNames
    }
    
    var invoiceCounter: Int32 {
        
        get {
            
            if counterArray!.isEmpty { return 0 }
            else { return counterArray!.first!.countValue}
        }
      
        set { counterArray!.first!.countValue = newValue }
    }
    
    // MARK: - INITIALIZATION
    init(parent: ContactViewController, onCompletion: @escaping () -> Void) {
        
        parentController = parent
        completion = onCompletion
        
        loadCoreData()
        
        if parentController!.contactListView.contactsTableView != nil { parent.contactListView.contactsTableView.reloadData() }
    }
        
    // MARK: - METHODS
    func loadCoreData() {
        
        // Sorted
        let contactsFetchRequest = Contact.fetchRequest()
        contactsFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Contact.lastName!, ascending: true)]
        
        let companiesFetchRequest = Company.fetchRequest()
        companiesFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Company.name!, ascending: true)]
        
        let groupsFetchRequest = Group.fetchRequest()
        groupsFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Group.sortOrder, ascending: true)]

        let projectsFetchRequest = Project.fetchRequest()
        projectsFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.name!, ascending: true)]
        
        let activitiesFetchRequest = Activity.fetchRequest()
        activitiesFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Activity.activityDescription!, ascending: true)]
        
        let productCategoriesFetchRequest = ProductCategory.fetchRequest()
        productCategoriesFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ProductCategory.category!, ascending: true)]
        
        let goalFetchRequest = Goal.fetchRequest()
        goalFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Goal.month, ascending: true)]
        
        let productFetchRequest = Product.fetchRequest()
        productFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Product.productDescription, ascending: true)]
        
        // Unsorted
        let customerCategoriesFetchRequest = ContactCategory.fetchRequest()
        
        let companyCategoriesFetchRequest = CompanyCategory.fetchRequest()
        
        let marketAreaFetchRequest = MarketArea.fetchRequest()
     
        let defaultSortFetchRequest = DefaultSort.fetchRequest()
        
        let invoiceFetchRequest = DefaultInvoiceValue.fetchRequest()
        
        let reportFetchRequest = Report.fetchRequest()
        
        let counterFetchRequest = InvCounter.fetchRequest()
        
        GlobalData.shared.viewContext.perform {
            
            do {
                
                self.contacts = try contactsFetchRequest.execute()
                self.companies = try companiesFetchRequest.execute()
                self.groups = try groupsFetchRequest.execute()
                self.projects = try projectsFetchRequest.execute()
                self.activities = try activitiesFetchRequest.execute()
                self.contactCategories = try customerCategoriesFetchRequest.execute()
                self.companyCategories = try companyCategoriesFetchRequest.execute()
                self.productCategories = try productCategoriesFetchRequest.execute()
                self.marketAreas = try marketAreaFetchRequest.execute()
                self.defaultSorts = try defaultSortFetchRequest.execute()
                self.defaultInvoiceValues = try invoiceFetchRequest.execute()
                self.goals = try goalFetchRequest.execute()
                self.reports = try reportFetchRequest.execute()
                self.products = try productFetchRequest.execute()
                self.counterArray = try counterFetchRequest.execute()
             
                self.initializeCategoryEntities()
                self.initializeDefaultSorts()
                self.initializeGoals()
                self.initializeReports()
                self.initializeCounter()
               
                self.completion()

            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func initializeCategoryEntities() {
        
        // Make sure we have 6 records
        if contactCategories!.isEmpty {
            
            for _ in 0...5 {
                
                let category = ContactCategory(context: GlobalData.shared.viewContext)
                category.category = ""
                contactCategories!.append(category)
            }
        }
        
        if companyCategories!.isEmpty {
            
            for _ in 0...5 {
                
                let category = CompanyCategory(context: GlobalData.shared.viewContext)
                category.category = ""
                companyCategories!.append(category)
            }
        }
        
        if productCategories!.isEmpty {
            
            for _ in 0...5 {
                
                let category = ProductCategory(context: GlobalData.shared.viewContext)
                category.category = ""
                productCategories!.append(category)
            }
        }
        
        if marketAreas!.isEmpty {
            
            for _ in 0...5 {
                
                let area = MarketArea(context: GlobalData.shared.viewContext)
                area.area = ""
                marketAreas!.append(area)
            }
        }
        
        GlobalData.shared.appDelegate.saveContext()
    }
    
    func initializeDefaultSorts() {
        
        // Init sort preference settings
        if defaultSorts!.isEmpty {
    
            let theSort = DefaultSort(context: GlobalData.shared.viewContext)
          
            theSort.forPeople = Int16(GlobalData.shared.peopleSort.rawValue)
            theSort.forCompany = Int16(GlobalData.shared.companySort.rawValue)
            defaultSorts!.append(theSort)
            
            GlobalData.shared.appDelegate.saveContext()
            
        } else {
            
            switch defaultSorts!.first!.forPeople {
                
                case 0: GlobalData.shared.peopleSort = .first
                case 1: GlobalData.shared.peopleSort = .last
                
                default: break
            }
            
            switch defaultSorts!.first!.forCompany {
                
                case 0: GlobalData.shared.companySort = .name
                case 1: GlobalData.shared.companySort = .city
                case 2: GlobalData.shared.companySort = .market
                
                default: break
            }
        }
    }
    
    func initializeGoals() {
        
        if goals!.isEmpty {
            
            for month in 0..<12 {
                
                let newGoal = Goal(context: GlobalData.shared.viewContext)
                newGoal.id = UUID()
                newGoal.timestamp = Date()
                newGoal.month = Int16(month)
                
                goals!.append(newGoal)
            }
            
            GlobalData.shared.saveCoreData()
        }
    }
    
    func initializeReports() {
        
        if reports!.isEmpty {
            
            for type in 0..<6 {
                
                let newReport = Report(context: GlobalData.shared.viewContext)
                
                newReport.id = UUID()
                newReport.timestamp = Date()
                newReport.reportType = Int16(type)
                
                reports!.append(newReport)
            }
            
            GlobalData.shared.saveCoreData()
        }
    }
    
    func initializeCounter() {
        
        if counterArray!.isEmpty {
            
            let theCounter = InvCounter(context: GlobalData.shared.viewContext)
            theCounter.countValue = 0
            
            GlobalData.shared.saveCoreData()
        }
    }
    
    // MARK: - SET TO ARRAY
    func setToArray(contacts: NSSet) -> [Contact] {
        
        var theContacts = [Contact]()
        
        for contact in contacts { theContacts.append(contact as! Contact) }
        return theContacts
    }
    
    func setToArray(companies: NSSet) -> [Company] {
        
        var theCompanies = [Company]()
        
        for company in companies { theCompanies.append(company as! Company) }
        return theCompanies
    }
    
    func setToArray(groups: NSSet) -> [Group] {
        
        var theGroups = [Group]()
        
        for group in groups { theGroups.append(group as! Group) }
        return theGroups
    }
    
    func setToArray(projects: NSSet) -> [Project] {
        
        var theProjects = [Project]()
        
        for project in projects {  theProjects.append(project as! Project) }
        return theProjects
    }
    
    func setToArray(activities: NSSet) -> [Activity] {
        
        var theActivities = [Activity]()
        
        for activity in activities { theActivities.append(activity as! Activity) }
        return theActivities
    }
    
    func setToArray(products: NSSet) -> [Product] {
        
        var theProducts = [Product]()
        
        for product in products { theProducts.append(product as! Product) }
        return theProducts
    }
    
    // MARK: - CATEGORIES/MARKETS TO ARRAY
    func contactCategoriesAsArray() -> [String] {
        
        var theCategories = [String]()
        
        for category in contactCategories! { theCategories.append(category.category!) }
        return theCategories
    }
    
    func companyCategoriesAsArray() -> [String] {
        
        var theCategories = [String]()
        
        for category in companyCategories! { theCategories.append(category.category!) }
        return theCategories
    }
    
    func productCategoriesAsArray() -> [String] {
        
        var theCategories = [String]()
        
        for category in productCategories! { theCategories.append(category.category!) }
        return theCategories
    }
    
    func marketAreasAsArray() -> [String] {
        
        var theAreas = [String]()
        
        for area in marketAreas! { theAreas.append(area.area!) }
        return theAreas
    }
    
    // MARK: - ELEMENT TESTERS
    func containsContactName (name: String)  -> Int? {
        
        for (index,value )in contacts!.enumerated() {
            
            if value.firstName! + " " + value.lastName! == name { return index }
        }
        
        return nil
    }
    
    func containsCompanyName (name: String)  -> Company? {
        
        for company in companies! { if company.name == name { return company } }
        return nil
    }
    
    func containsGroupName (name: String)  -> Group? {
        
        for group in groups! { if group.name == name { return group } }
        return nil
    }
    
    func companyWith(uid: UUID) -> Company? {
        
        for company in companies! {
            
            if company.id == uid { return company }
        }
        
        return nil
    }
    
    // MARK: INDEX GETTERS
    func contactIndex(contact: Contact) -> Int? {
     
        for (index,value) in contacts!.enumerated() {
            
            if contact.appId == value.appId { return index }
        }
        
        return nil
    }
    
    func companyIndex(company: Company) -> Int? {
    
        for (index,value) in companies!.enumerated() {
            
            if company.appId == value.appId { return index }
        }
        
        return nil
    }
    
    func groupIndex(group: Group) -> Int? {
        
        for (index,value) in groups!.enumerated() {
            
            if group.appId == value.appId { return index }
        }
        
        return nil
    }
    
    func projectIndex(project: Project) -> Int? {
        
        for (index,value) in projects!.enumerated() {
            
            if project.appId == value.appId { return index }
        }
        
        return nil
    }
    
    func activityIndex(activity: Activity) -> Int? {
        
        for (index,value) in activities!.enumerated() {
            
            if activity.appId == value.appId { return index }
        }
        
        return nil
    }
    
    func reportForType(type: Int16) -> Report? {
        
        for report in reports! {
            
            if report.reportType == type { return report }
        }
        
        return nil
    }
    
    func salesFor(product: Product) -> Int32 {
        
        let index = products!.firstIndex(of: product)!
        let theProduct = products![index]
        
        return Int32(theProduct.quantity) * Int32(theProduct.unitPrice)
    }
        
    // MARK: - VALIDITY TESTS
    func addressIsIncomplete (theCompany: Company) -> Bool {
        
        if theCompany.primaryStreet! == "" || theCompany.city == "" || theCompany.postalCode! == "" { return true }
        else { return false }
    }
}


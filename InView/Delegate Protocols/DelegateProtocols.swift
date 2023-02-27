//
//  DelegateProtocols.swift
//  Flirté
//
//  Created by Roger Vogel on 5/8/22.
//

import Foundation
import UIKit
import Contacts

// MARK: - MENU
protocol MenuViewDelegate: AnyObject {
    
    func menuDidShow()
    func menuDidHide()
}

// MARK: - EMPLOYEE TABLE CELL
protocol EmployeeTableCellDelegate: AnyObject {
    
    func showEmployee(_ employee: Contact)
    func callEmployee(_ employee: Contact)
    func messageEmployee(_ employee: Contact)
    func emailEmployee(_ employee: Contact)    
}

// MARK: - SELECTOR CELL
protocol SelectorTableCellDelegate: AnyObject {
    
    func contactWasSelected(contact: Contact)
    func contactWasDeselected(contact: Contact)
    
    func companyWasSelected(company: Company)
    func companyWasDeselected(company: Company)
    
    func projectWasSelected(project: Project)
    func projectWasDeselected(project: Project)
    
    func bookContactWasSelected(bookContact: CNContact, isCompany: Bool)
    func bookContactWasDeselected(bookContact: CNContact)
}

// MARK: - COLLECTION CELL
protocol ProjectCollectionCellDelegate: AnyObject {
    
    func nameEditingInProgress()
    func nameEditingCompleted(name: String, forCellIndex: Int)
}

// MARK: - TOOL BAR
protocol ToolBarDelegate: AnyObject {
    
    func doneButtonTapped()
}

// MARK: - ACTIVITY TABLE CELL
protocol ActivityTableCellDelegate: AnyObject {
    
    func activityWasSelected(activity: Activity)
    func activityWasDeselected(activity: Activity)
    func activityDescriptionWasChanged(activity: Activity)
    func onDetailsButton(indexPath: IndexPath)
}

// MARK: - ACTIVITY SELECTION
protocol ActivitySelectionViewDelegate: AnyObject {

    func selectedContactDidChange(contact: Contact, selected: Bool)

    func selectedCompanyDidChange(company: Company, selected: Bool)

    func selectedProjectDidChange(project: Project, selected: Bool)
}

// MARK: - DIVIDER CELL
protocol DividerTableCellDelegate: AnyObject {
    
    func titleHasChanged(forIndex: Int, name: String)
}

// MARK: - SELECTOR CELL FOR DUPLICATES
protocol DuplicateTableCellDelegate: AnyObject {
    
    func contactWasSelected(contact: Contact, indexPath: IndexPath)
    func contactWasDeselected(contact: Contact, indexPath: IndexPath)
}

protocol DuplicatesViewDelegate: AnyObject {
    
    func dismissMenuView()
}

protocol DuplicateDetailsViewDelegate: AnyObject {
    
    func refresh()
}

// MARK: - CALENDAR VIEW DELEGATE
protocol CalendarViewDelegate: AnyObject {
    
    func dayWasSelected(day: Int)
    func dayWasDeselected(day: Int)
}

// MARK: - ENTITY LIST CELL DELEGATE
protocol EntityListCellDelegate: AnyObject {
    
    func textFieldWillChange(value: Int32)
    func textFieldDidChange(value: Int32, forRow: Int)
}

// MARK: - GOAL LIST CELL DELEGATE
protocol SettingsGoalListCellDelegate: AnyObject {
    
    func textFieldWillChange(values: SettingValues)
    func textFieldDidChange(values: SettingValues, forMonth: Int)
    func textFieldDidChange(value: Int32, indexPath: IndexPath)
}

// MARK: - GOAL LIST CELL DELEGATE
protocol ReportsByProductListCellDelegate: AnyObject {
    
    func onDetailsButton(info: UIButton, indexPath: IndexPath)
    func textFieldWillChange(value: Int32, indexPath: IndexPath)
    func textFieldDidChange(info: UIButton, category: ProductCategory, value: Int32, indexPath: IndexPath)
}

// MARK: - PRODUCT INVOICE DELEGATE
protocol ProjectProductCellDelegate: AnyObject {
    
    func invoiceProductWasSelected(indexPath: IndexPath)
    func invoiceProductWasDeselected(indexPath: IndexPath)
}

// MARK: - DEFAULTS FOR OPTIONAL METHODS
extension ActivitySelectionViewDelegate {
    
    func selectedContactDidChange(contact: Contact, selected: Bool) { }
    func selectedCompanyDidChange(company: Company, selected: Bool) { }
    func selectedProjectDidChange(project: Project, selected: Bool) { }
}

extension SelectorTableCellDelegate {
    
    func contactWasSelected(contact: Contact) { }
    func contactWasDeselected(contact: Contact) { }
    
    func companyWasSelected(company: Company) { }
    func companyWasDeselected(company: Company) { }
    
    func projectWasSelected(project: Project) { }
    func projectWasDeselected(project: Project) { }
    
    func bookContactWasSelected(bookContact: CNContact, isCompany: Bool) { }
    func bookContactWasDeselected(bookContact: CNContact) { }
}

extension SettingsGoalListCellDelegate {
    
    func textFieldWillChange(values: SettingValues) { }
    func textFieldDidChange(values: SettingValues, forMonth: Int) { }
    func textFieldDidChange(value: Int32, indexPath: IndexPath) { }
}

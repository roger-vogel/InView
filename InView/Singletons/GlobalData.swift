//
//  GlobalData.swift
//  InView
//
//  Created by Roger Vogel on 9/23/22.
//

import Foundation
import UIKit
import DateManager

class GlobalData {
    
    // MARK: - SINGLETON
    static let shared = GlobalData()
    
    // MARK: - PROPERTIES
    let appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    var viewContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    var clockPreference: ClockPreference = .c12
    var activeController: ParentViewController?
    var activeView: ParentView?
    var indexTitles = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    var contactNoPhoto = UIImage(named: "image.contact.nophoto.light")
    var companyNoPhoto = UIImage(named: "image.company.nophoto.light")
    var peopleSort: PeopleSort = .last
    var companySort: CompanySort = .name
    var menuController: MenuViewController?
       
    // MARK: - METHODS
    func saveCoreData() {
        
        appDelegate.saveContext()
        if activeController != nil { activeController!.updateActionButtons() }
    }
}

// MARK: - ENUMERATIONS
enum ActivityType: Int { case task, event }
enum AddEntityType: Int { case contact, company, activity }
enum CommType: Int { case text, email }
enum ImportType: Int { case vcard, csv }
enum Justification: Int { case left, center, right }
enum PhotoSide: Int { case width, height}
enum Menu: Int { case sort, duplicates, addressbooks,customer, product,market, invoice,reports }
enum SettingsType: Int { case customer, company, product, market }
enum Sort: Int { case ascending, descending, none }
enum PeopleSort: Int { case first, last }
enum CompanySort: Int { case name, city, market }
enum SortMethod: Int { case alpha, date, market, city, none }
enum TimeFrame: Int { case today, thisweek, upcoming }
enum TimerState: Int { case start, stop}

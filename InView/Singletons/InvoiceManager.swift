//
//  InvoiceItems.swift
//  InView-2
//
//  Created by Roger Vogel on 2/27/23.
//

import Foundation
import UIKit

struct InvoiceManager {
    
    // MARK: - SINGLETON
    static let shared = InvoiceManager()
    
    func createInvoiceItems(company: Company) -> [Product] {
        
        var productsPendingInvoice = [Product]()
     
        for project in company.projects! {
            
            for product in (project as! Project).products! {
                
                let theProduct = product as! Product
                if theProduct.invoiced == Invoiced.pending { productsPendingInvoice.append(theProduct) }
            }
        }
        
        return productsPendingInvoice
    }
}

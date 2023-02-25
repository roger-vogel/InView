//
//  CompanyInvoiceView.swift
//  InView-2
//
//  Created by Roger Vogel on 2/19/23.
//

import UIKit
import WebKit
import PDFKit

class CompanyInvoiceView: ParentView {
    
    // MARK: - STORY BOARD OUTLETS
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - COMPUTED PROPERTIES
    var invoicePDFData: Data {
        
        let format = UIGraphicsPDFRendererFormat()
        let metaData = [kCGPDFContextTitle: "Invoice", kCGPDFContextAuthor: "InView" ]
        
        format.documentInfo = metaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            
            context.beginPage()
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes = [
                
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
            
            let text = "Hello, World!"
            let textRect = CGRect(x: 100, y: 100,width: 200,height: 20) // x = left margin, y = top margin
            
            text.draw(in: textRect, withAttributes: attributes)
        }
        
        return data
    }
    
    // MARK: - PROPERTIES
    var theCompany: Company?
    
   // MARK: METHODS
    func setCompany(company: Company) {
        
        theCompany = company
        displayInvoice()
    }
    
    func displayInvoice() {
        
        let pdfDocument = PDFDocument(data: invoicePDFData)
        
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentDirectoryURL.appendingPathComponent("invoice.pdf")
      
        pdfDocument!.write(to: fileURL)
        webView.load(URLRequest(url: fileURL))
    }
    
    // MARK: ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.companyController.companyDetailsView.showView()
    }
}


/*
 // Save the file to disk and return the resulting url
 let fileManager = FileManager()
 let fileData = Data(base64Encoded: selectedDocument!.content!)
 let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
 let fileURL = documentDirectoryURL.appendingPathComponent(selectedDocument!.name! + "." + selectedDocument!.fileExtension!)

 if fileManager.fileExists(atPath: fileURL.path) {
 
     do { try fileManager.removeItem(at: fileURL) }
     catch { NSLog( "\(error)") }
 }

 guard fileManager.createFile(atPath: fileURL.path, contents: fileData) else {
     
     NSLog("Creation error")
     AlertManager(controller: GlobalData.shared.activeController!).popupMessage(aMessage: "There was a problem accessing this content, please try agin or contact support", aViewDelay: 3.0)
   
     return nil
 }
 
 */

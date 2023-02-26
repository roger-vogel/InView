//
//  CompanyInvoiceView.swift
//  InView-2
//
//  Created by Roger Vogel on 2/19/23.
//

import UIKit
import WebKit
import PDFKit
import ColorManager
import DateManager
import Extensions

class CompanyInvoiceView: ParentView {
    
    // MARK: - STORY BOARD OUTLETS
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: PROPERTIES
    var yIndex = 0
    var invoiceInfo: Invoice?
    var textRect: CGRect?
    var attributes: [NSAttributedString.Key: NSObject]?
    var infoOffset: CGFloat = 120
    let addressFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    
    // MARK: - COMPUTED PROPERTIES
    var invoicePDFData: Data {
        
        let format = UIGraphicsPDFRendererFormat()
        let metaData = [kCGPDFContextTitle: "Invoice", kCGPDFContextAuthor: "InView" ]
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        invoiceInfo = parentController!.contactController.coreData!.invoices!.first!
        format.documentInfo = metaData as [String: Any]
        
        let data = renderer.pdfData { (context) in
            
        // MARK: - INITIALIZATION
            context.beginPage()
            
            let coreData = parentController!.contactController.coreData!
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
        // MARK: LOGO IMAGE
            if !coreData.invoices!.isEmpty {
                
                let logoData = Data(base64Encoded: invoiceInfo!.logo!)!
                let logoImage = UIImage(data: logoData)
                let imageRect = CGRect(x: 20, y: 20, width: 50, height: 50)
              
                logoImage!.draw(in: imageRect)
            }
            
        // MARK: - COMPANY NAME
            attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium),
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: UIColor.label
            ]
    
            textRect = CGRect(x: 80, y: 33, width: 200, height: 40) // x = left margin, y = top margin
            invoiceInfo!.name!.draw(in: textRect!, withAttributes: attributes)
            
        // MARK: - INVOICE TITLE
            let title = "INVOICE"
            let length = title.widthofString(withFont: UIFont.systemFont(ofSize: 20, weight: .medium)) + 10
            textRect = CGRect(x: 612-20-length, y: 35, width: length, height: 40)
            title.draw(in: textRect!, withAttributes: attributes)
            
        // MARK: - COMPANY ADDRESS
            attributes = [
                
                NSAttributedString.Key.font: addressFont,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: UIColor.label
            ]
            
            // Render each line
            for yAddress in 0...5 {
                
                textRect = CGRect(x: 22, y: 80 + (20 * yIndex), width: 300, height: 20)
                
                switch yAddress {
                    
                    case 0:
                        
                        if invoiceInfo!.primaryStreet! != "" {
                            
                            invoiceInfo!.primaryStreet!.draw(in: textRect!, withAttributes: attributes)
                            yIndex += 1
                        }
                        
                    case 1:
                        
                        if invoiceInfo!.subStreet! != "" {
                            
                            invoiceInfo!.subStreet!.draw(in: textRect!, withAttributes: attributes)
                            yIndex += 1
                        }
                        
                    case 2:
                        
                        if invoiceInfo!.city! != "" {
                            
                            invoiceInfo!.city!.draw(in: textRect!, withAttributes: attributes)
                            
                            if invoiceInfo!.state != "" {
                                
                                let theState = States.nameToAbbrev(name: invoiceInfo!.state!)
                                var textOffset = invoiceInfo!.city!.widthofString(withFont: addressFont) + 5
                                
                                textRect!.origin.x += textOffset
                                theState.draw(in: textRect!, withAttributes: attributes)
                                
                                if invoiceInfo!.postalCode! != "" {
                                    
                                    textOffset = theState.widthofString(withFont: addressFont) + 5
                                   
                                    textRect!.origin.x += textOffset
                                    invoiceInfo!.postalCode!.draw(in: textRect!, withAttributes: attributes)
                                }
                            }
                                
                            yIndex += 1
                        }
                        
                    case 3:
                    
                        if invoiceInfo!.phone! != "" {
                            
                            invoiceInfo!.phone!.formattedPhone.draw(in: textRect!, withAttributes: attributes)
                            yIndex += 1
                        }
              
                    case 4:
                    
                        if invoiceInfo!.email! != "" {
                            
                            invoiceInfo!.email!.draw(in: textRect!, withAttributes: attributes)
                            yIndex += 1
                        }
                    
                    case 5:
                    
                        if invoiceInfo!.website! != "" {
                            
                            invoiceInfo!.website!.draw(in: textRect!, withAttributes: attributes)
                            yIndex += 1
                        }
                        
                    default: break
                }
            }
            
        // MARK: - DATE AND INFO
            // Render each line
            for yInfo in 0...4 {

                switch yInfo {

                    case 0:

                        // Propeties
                        let dateLength = "Date".widthofString(withFont: addressFont)
                        let today = DateManager().dateString
                    
                        // Draw date title
                        textRect = CGRect(x: 612-20-Int(dateLength + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                        "Date".draw(in: textRect!, withAttributes: attributes)
                    
                        // Draw date
                    //    textRect!.origin.x += dateLength + 30
                    //    textRect!.size.width = today.widthofString(withFont: addressFont) + 10
                    //    today.draw(in: textRect!, withAttributes: attributes)
                
                    case 1:

                        textRect = CGRect(x: 612-20-Int("Invoice #".widthofString(withFont: addressFont) + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                        "Invoice #".draw(in: textRect!, withAttributes: attributes)
                
                    case 2:

                        textRect = CGRect(x: 612-20-Int("Due Date".widthofString(withFont: addressFont) + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                        "Due Date".draw(in: textRect!, withAttributes: attributes)
                    
                    case 3:

                        textRect = CGRect(x: 612-20-Int("PO Reference".widthofString(withFont: addressFont) + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                        "PO Reference".draw(in: textRect!, withAttributes: attributes)
              
                    case 4:

                        textRect = CGRect(x: 612-20-Int("Project ID / Name".widthofString(withFont: addressFont) + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                        "Project ID / Name".draw(in: textRect!, withAttributes: attributes)
                       
                    default: break
                }
            }
            
        // MARK: - BILL TO
            attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.backgroundColor: ColorManager(r: 2, g: 65, b: 140, a: 255).uicolor
            ]
            
            let text = "  BILL TO".rightPadSpaces(count: 50)
            textRect = CGRect(x: 20, y: 200, width: 300, height: 34)
            text.draw(in: textRect!, withAttributes: attributes)
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

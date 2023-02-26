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

class CompanyInvoiceView: ParentView {
    
    // MARK: - STORY BOARD OUTLETS
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: PROPERTIES
    var invoiceInfo: Invoice?
    var textRect: CGRect?
    var attributes: [NSAttributedString.Key: NSObject]?
    
    // MARK: - COMPUTED PROPERTIES
    var invoicePDFData: Data {
        
        let format = UIGraphicsPDFRendererFormat()
        let metaData = [kCGPDFContextTitle: "Invoice", kCGPDFContextAuthor: "InView" ]
        
        invoiceInfo = parentController!.contactController.coreData!.invoices!.first!
        
        format.documentInfo = metaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            
            context.beginPage()
            
            let coreData = parentController!.contactController.coreData!
            let paragraphStyle = NSMutableParagraphStyle()
        
            paragraphStyle.alignment = .left
            
            // MARK: Logo Image
            if !coreData.invoices!.isEmpty {
                
                let logoData = Data(base64Encoded: invoiceInfo!.logo!)!
                let logoImage = UIImage(data: logoData)
                let imageRect = CGRect(x: 20, y: 20, width: 50, height: 50)
              
                logoImage!.draw(in: imageRect)
            }
            
            // MARK: Company Name
            textRect = CGRect(x: 80, y: 33, width: 200, height: 40) // x = left margin, y = top margin
            attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium),NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.foregroundColor: UIColor.label]
            invoiceInfo!.name!.draw(in: textRect!, withAttributes: attributes)
            
            // MARK: Invoice Title
            let title = "INVOICE"
            attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium),NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.foregroundColor: UIColor.label]
            let length = title.widthofString(withFont: UIFont.systemFont(ofSize: 20, weight: .medium)) + 10
            textRect = CGRect(x: 612-20-length, y: 35, width: length, height: 40)
            title.draw(in: textRect!, withAttributes: attributes)
            
            // MARK: Company Address
            attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular),NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.foregroundColor: ThemeColors.darkGray.uicolor]
            
            var yIndex = 0
            let addressFont = UIFont.systemFont(ofSize: 14, weight: .regular)
           
            for originY in 0...5 {
                
                textRect = CGRect(x: 22, y: 80 + (20 * yIndex), width: 300, height: 20)
                
                switch originY {
                    
                    case 0:
                        
                        if invoiceInfo!.primaryStreet! != "" {
                            
                            invoiceInfo!.primaryStreet!.draw(in: textRect!, withAttributes: attributes)
                            yIndex += 1
                        }
                        
                    case 1:
                        
                    
                    invoiceInfo!.subStreet!.draw(in: textRect!, withAttributes: attributes)
                        if invoiceInfo!.subStreet! != "" {
                            yIndex += 1
                        }
                        
                    case 2:
                        
                        if invoiceInfo!.city! != "" {
                            
                            invoiceInfo!.city!.draw(in: textRect!, withAttributes: attributes)
                            
                            if invoiceInfo!.state != "" {
                                
                                let theState = States.nameToAbbrev(name: invoiceInfo!.state!)
                                var textOffset = invoiceInfo!.city!.widthofString(withFont: addressFont) + 20
                                
                                textRect!.origin.x += textOffset
                                theState.draw(in: textRect!, withAttributes: attributes)
                                
                                if invoiceInfo!.postalCode! != "" {
                                    
                                    textOffset = theState.widthofString(withFont: addressFont) + 10
                                   
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



/*
 NSAttributedString.Key.backgroundColor: ColorManager(r: 2, g: 65, b: 140, a: 255).uicolor
 */

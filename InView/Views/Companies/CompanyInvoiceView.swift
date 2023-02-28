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

struct Padding { var before: Int = 0; var after: Int = 0 }

class CompanyInvoiceView: ParentView {
    
    // MARK: - STORY BOARD OUTLETS
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: PROPERTIES
    var invoiceInfo: Invoice?
    var textRect: CGRect?
    var infoOffset: CGFloat = 120
    let addressFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    let heightFont = UIFont.systemFont(ofSize: 10, weight: .regular)
    let paragraphStyle = NSMutableParagraphStyle()
    var productPendingInvoice: [Product]?
    var pageWidth = 612
    
    // MARK: - COMPUTED PROPERTIES
    var invoicePDFData: Data {
        
        let format = UIGraphicsPDFRendererFormat()
        let metaData = [kCGPDFContextTitle: "Invoice", kCGPDFContextAuthor: "InView" ]
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let coreData = parentController!.contactController.coreData!
     
        invoiceInfo = parentController!.contactController.coreData!.invoices!.first!
        format.documentInfo = metaData as [String: Any]
        
        let data = renderer.pdfData { (context) in
            
            // Initialization
            context.beginPage()
            paragraphStyle.alignment = .left
     
            // Logo image
            if !coreData.invoices!.isEmpty { drawLogo() }
           
            // Top line: Company name and invoice title
            drawCompanyName()
            drawInvoiceTitle()
   
            // Company addressd
            drawCompanyAddress()
            
            // Invoice date and other info
            drawInvoiceInfo()
            
            // BILL TO and SHIP TO info bar
            let headerGap = pageWidth - 540
            drawInfoBar(title: "BILL TO", inRect: CGRect(x: 20, y: 200, width: 250, height: 18))
            drawInfoBar(title: "SHIP TO", inRect: CGRect(x: 270 + headerGap, y: 200, width: 250, height: 18))
       
        
            // BILL TO address
            drawBillToAddress()
            
            // SHIP TO address
            drawShipToAddress(originX: 270 + headerGap)
            
            
            // Product description info bar
            //let width = drawInfoBarFromLeft(title: "Description", textRect: CGRect(x: 20, y: 315, width: 0, height: 36), padding: Padding(before: 2, after: 60))
            
            // Invoice line items
            // drawInvoiceLineItems(textRect: CGRect(x: 20, y: 350, width: width, height: 40))
        }
        
        return data
    }
    
    // MARK: - PROPERTIES
    var theCompany: Company?
    
    // MARK: - INITIALIZATON
    
    // MARK: METHODS
    func setCompany(company: Company) {
        
        theCompany = company
     
        productPendingInvoice = InvoiceManager.shared.createInvoiceItems(company: theCompany!)
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

// MARK: - DRAWING METHODS
extension CompanyInvoiceView {
    
    func drawLogo() {
        
        guard invoiceInfo!.hasLogo else { return }
        
        let logoData = Data(base64Encoded: invoiceInfo!.logo!)!
        let logoImage = UIImage(data: logoData)
        let imageRect = CGRect(x: 20, y: 20, width: 50, height: 50)
      
        logoImage!.draw(in: imageRect)
    }
    
    func drawCompanyName() {
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium),
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]

        let length = invoiceInfo!.name!.textSize(font: UIFont.systemFont(ofSize: 20, weight: .medium))
        textRect = invoiceInfo!.hasLogo ? CGRect(x: 80, y: 33, width: length.width, height: 40) : CGRect(x: 20, y: 33, width: length.width, height: 40)
        invoiceInfo!.name!.draw(in: textRect!, withAttributes: attributes)
    }
    
    func drawInvoiceTitle() {
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium),
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        
        let title = "INVOICE"
        let length = title.textSize(font: UIFont.systemFont(ofSize: 20, weight: .medium))
        textRect = CGRect(x: 612-20-length.width, y: 35, width: length.width, height: 40)
        title.draw(in: textRect!, withAttributes: attributes)
    }
    
    func drawCompanyAddress() {
        
        var yIndex = 0
        
        let attributes = [
            
            NSAttributedString.Key.font: addressFont,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        
        // Render each line
        for yAddress in 0...5 {
            
            textRect = CGRect(x: 22, y: 80 + (20 * yIndex), width: 0, height: 20)
            
            switch yAddress {
                
                case 0:
                    
                    if invoiceInfo!.primaryStreet! != "" {
                        
                        textRect!.size.width = invoiceInfo!.primaryStreet!.textSize(font: addressFont).width
                        invoiceInfo!.primaryStreet!.draw(in: textRect!, withAttributes: attributes)
                        yIndex += 1
                    }
                    
                case 1:
                    
                    if invoiceInfo!.subStreet! != "" {
                        
                        textRect!.size.width = invoiceInfo!.subStreet!.textSize(font: addressFont).width
                        invoiceInfo!.subStreet!.draw(in: textRect!, withAttributes: attributes)
                        yIndex += 1
                    }
                    
                case 2:
                    
                    if invoiceInfo!.city! != "" {
                        
                        textRect!.size.width = invoiceInfo!.city!.textSize(font: addressFont).width
                        invoiceInfo!.city!.draw(in: textRect!, withAttributes: attributes)
                        
                        if invoiceInfo!.state != "" {
                            
                            let theState = States.nameToAbbrev(name: invoiceInfo!.state!)
                            var textOffset = invoiceInfo!.city!.textSize(font: addressFont).width + 5
                            
                            textRect!.origin.x += textOffset
                            textRect!.size.width = theState.textSize(font: addressFont).width
                        
                            theState.draw(in: textRect!, withAttributes: attributes)
                            
                            if invoiceInfo!.postalCode! != "" {
                                
                                textOffset = theState.textSize(font: addressFont).width + 5
                               
                                textRect!.origin.x += textOffset
                                textRect!.size.width = invoiceInfo!.postalCode!.textSize(font: addressFont).width
                                invoiceInfo!.postalCode!.draw(in: textRect!, withAttributes: attributes)
                            }
                        }
                            
                        yIndex += 1
                    }
                    
                case 3:
                
                    if invoiceInfo!.phone! != "" {
                        
                        textRect!.size.width = invoiceInfo!.phone!.formattedPhone.textSize(font: addressFont).width
                        invoiceInfo!.phone!.formattedPhone.draw(in: textRect!, withAttributes: attributes)
                        yIndex += 1
                    }
          
                case 4:
                
                    if invoiceInfo!.email! != "" {
                        
                        textRect!.size.width = invoiceInfo!.email!.textSize(font: addressFont).width
                        invoiceInfo!.email!.draw(in: textRect!, withAttributes: attributes)
                        yIndex += 1
                    }
                
                case 5:
                
                    if invoiceInfo!.website! != "" {
                        
                        textRect!.size.width = invoiceInfo!.website!.textSize(font: addressFont).width
                        invoiceInfo!.website!.draw(in: textRect!, withAttributes: attributes)
                        yIndex += 1
                    }
                    
                default: break
            }
        }
    }
    
    func drawInvoiceInfo() {
        
        let attributes = [
            
            NSAttributedString.Key.font: addressFont,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        
        // Render each line
        for yInfo in 0...4 {

            switch yInfo {

                case 0:

                    // Propeties
                    let dateLength = "Date".textSize(font: addressFont).width
                    let today = DateManager().dateString
                
                    // Draw date title
                    textRect = CGRect(x: 612-20-Int(dateLength + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                    "Date".draw(in: textRect!, withAttributes: attributes)
                
                    // Draw date
                    textRect!.origin.x += (dateLength + 15)
                    textRect!.size.width = today.textSize(font: addressFont).width + 2
                    today.draw(in: textRect!, withAttributes: attributes)
            
                case 1:

                    textRect = CGRect(x: 612-20-Int("Invoice #".textSize(font: addressFont).width + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                    "Invoice #".draw(in: textRect!, withAttributes: attributes)
            
                case 2:

                    textRect = CGRect(x: 612-20-Int("Due Date".textSize(font: addressFont).width + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                    "Due Date".draw(in: textRect!, withAttributes: attributes)
                
                case 3:

                    textRect = CGRect(x: 612-20-Int("PO Reference".textSize(font: addressFont).width + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                    "PO Reference".draw(in: textRect!, withAttributes: attributes)
          
                case 4:

                    textRect = CGRect(x: 612-20-Int("Project ID / Name".textSize(font: addressFont).width + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                    "Project ID / Name".draw(in: textRect!, withAttributes: attributes)
                   
                default: break
            }
        }
    }
    
    func drawBillToAddress() {
        
        var yIndex = 0
        
        let attributes = [
            
            NSAttributedString.Key.font: addressFont,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        
        // Render each line
        for yAddress in 0...4 {
            
            textRect = CGRect(x: 22, y: 225 + (20 * yIndex), width: 0, height: 20)
            
            switch yAddress {
                
                case 0:
                
                    if theCompany!.name! != "" {
                        
                        textRect!.size.width = theCompany!.name!.textSize(font: addressFont).width
                        theCompany!.name!.draw(in: textRect!, withAttributes: attributes)
                        yIndex += 1
                    }
                
                case 1:
                    
                    if theCompany!.primaryStreet! != "" {
                        
                        textRect!.size.width = theCompany!.primaryStreet!.textSize(font: addressFont).width
                        theCompany!.primaryStreet!.draw(in: textRect!, withAttributes: attributes)
                        yIndex += 1
                    }
                    
                case 2:
                    
                    if theCompany!.subStreet! != "" {
                        
                        textRect!.size.width = theCompany!.subStreet!.textSize(font: addressFont).width
                        theCompany!.subStreet!.draw(in: textRect!, withAttributes: attributes)
                        yIndex += 1
                    }
                    
                case 3:
                    
                    if theCompany!.city! != "" {
                        
                        textRect!.size.width = theCompany!.city!.textSize(font: addressFont).width
                        theCompany!.city!.draw(in: textRect!, withAttributes: attributes)
                        
                        if theCompany!.state != "" {
                            
                            let theState = States.nameToAbbrev(name: theCompany!.state!)
                            var textOffset = theCompany!.city!.textSize(font: addressFont).width + 5
                            
                            textRect!.origin.x += textOffset
                            textRect!.size.width = theState.textSize(font: addressFont).width
                        
                            theState.draw(in: textRect!, withAttributes: attributes)
                            
                            if theCompany!.postalCode! != "" {
                                
                                textOffset = theState.textSize(font: addressFont).width + 5
                               
                                textRect!.origin.x += textOffset
                                textRect!.size.width = theCompany!.postalCode!.textSize(font: addressFont).width
                                theCompany!.postalCode!.draw(in: textRect!, withAttributes: attributes)
                            }
                        }
                            
                        yIndex += 1
                    }
                    
                case 4:
                
                    if theCompany!.phone! != "" {
                        
                        textRect!.size.width = theCompany!.phone!.formattedPhone.textSize(font: addressFont).width
                        theCompany!.phone!.formattedPhone.draw(in: textRect!, withAttributes: attributes)
                        yIndex += 1
                    }
          
                default: break
            }
        }
    }
    
    func drawShipToAddress(originX: Int) {
        
        var yIndex = 0
        
        let attributes = [
            
            NSAttributedString.Key.font: addressFont,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        
        // Render each line
        for yAddress in 0...4 {
            
            textRect = CGRect(x: originX, y: 225 + (20 * yIndex), width: 0, height: 20)
            
            switch yAddress {
                
                case 0:
                
                    if theCompany!.name! != "" {
                        
                        textRect!.size.width = theCompany!.name!.textSize(font: addressFont).width
                        theCompany!.name!.draw(in: textRect!, withAttributes: attributes)
                        yIndex += 1
                    }
                
                case 1:
                    
                    if theCompany!.primaryStreet! != "" {
                        
                        textRect!.size.width = theCompany!.primaryStreet!.textSize(font: addressFont).width
                        theCompany!.primaryStreet!.draw(in: textRect!, withAttributes: attributes)
                        yIndex += 1
                    }
                    
                case 2:
                    
                    if theCompany!.subStreet! != "" {
                        
                        textRect!.size.width = theCompany!.subStreet!.textSize(font: addressFont).width
                        theCompany!.subStreet!.draw(in: textRect!, withAttributes: attributes)
                        yIndex += 1
                    }
                    
                case 3:
                    
                    if theCompany!.city! != "" {
                        
                        textRect!.size.width = theCompany!.city!.textSize(font: addressFont).width
                        theCompany!.city!.draw(in: textRect!, withAttributes: attributes)
                        
                        if theCompany!.state != "" {
                            
                            let theState = States.nameToAbbrev(name: theCompany!.state!)
                            var textOffset = theCompany!.city!.textSize(font: addressFont).width + 5
                            
                            textRect!.origin.x += textOffset
                            textRect!.size.width = theState.textSize(font: addressFont).width
                        
                            theState.draw(in: textRect!, withAttributes: attributes)
                            
                            if theCompany!.postalCode! != "" {
                                
                                textOffset = theState.textSize(font: addressFont).width + 5
                               
                                textRect!.origin.x += textOffset
                                textRect!.size.width = theCompany!.postalCode!.textSize(font: addressFont).width
                                theCompany!.postalCode!.draw(in: textRect!, withAttributes: attributes)
                            }
                        }
                            
                        yIndex += 1
                    }
                    
                case 4:
                
                    if theCompany!.phone! != "" {
                        
                        textRect!.size.width = theCompany!.phone!.formattedPhone.textSize(font: addressFont).width
                        theCompany!.phone!.formattedPhone.draw(in: textRect!, withAttributes: attributes)
                        yIndex += 1
                    }
          
                default: break
            }
        }
    }
    
    func drawInvoiceLineItems(textRect: CGRect) {
        
        let productsToInvoice = InvoiceManager.shared.createInvoiceItems(company: theCompany!)
        var theTextRect = textRect
        var attributes: [NSAttributedString.Key : NSObject]?
        
        for (index,value) in productsToInvoice.enumerated() {
            
            if index % 2 == 0 {
                
                attributes = [
                    
                    NSAttributedString.Key.font: addressFont,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.foregroundColor: UIColor.label,
                    NSAttributedString.Key.backgroundColor: ThemeColors.lightGray.uicolor
                ]
                
            } else {
                
                attributes = [
                    
                    NSAttributedString.Key.font: addressFont,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.foregroundColor: UIColor.label,
                    NSAttributedString.Key.backgroundColor: UIColor.systemTeal
                ]
            }
            
            let workingPad = value.productDescription!.padToWidth(width: theTextRect.width, font: addressFont)
            let paddedDescription = workingPad.shiftPadToFront(count: 2)
            let borderPad = " ".padToWidth(width: theTextRect.width, font: addressFont)
           
            theTextRect.origin.y = CGFloat(333 + (Int(theTextRect.size.height) * index))
            borderPad.draw(in: theTextRect, withAttributes: attributes)
            
            theTextRect.origin.y = CGFloat(343 + (Int(theTextRect.size.height) * index))
            borderPad.draw(in: theTextRect, withAttributes: attributes)
            
            theTextRect.origin.y = CGFloat(336 + (Int(theTextRect.size.height) * index))
            paddedDescription.draw(in: theTextRect, withAttributes: attributes)
            
           
        }
    }
    
    func drawInfoBar(title: String? = "", inRect: CGRect, withFont: UIFont? = UIFont.systemFont(ofSize: 14, weight: .semibold)) {
        
        let context = UIGraphicsGetCurrentContext()
        context!.addRect(inRect)
        
        let font = withFont!
        
        ColorManager(r: 2, g: 65, b: 140, a: 255).uicolor.setFill()
        UIColor.clear.setStroke()
        
        context!.drawPath(using: .fillStroke)
        
        if title != "" {
            
            let attributes = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.backgroundColor: UIColor.clear
            ]
        
            var theTextRect = inRect
            let textSize = "H".textSize(font: font)
         
            theTextRect.origin.x += 3
            theTextRect.origin.y += (inRect.size.height/2 - textSize.height/2)
            title!.draw(in: theTextRect, withAttributes: attributes)
        }
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

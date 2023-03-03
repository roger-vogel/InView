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
import AlertManager

struct Padding { var before: Int = 0; var after: Int = 0 }
struct Column { var title: String = ""; var width: CGFloat; var justificaton: Justification? = .left }
struct Widths {
    
    var description: CGFloat
    var unit: CGFloat
    var qty: CGFloat
    var price: CGFloat
    var total: CGFloat
    var totalToPrice: Int { return Int(description + unit + qty) }
    var totalToTotal: Int { return totalToPrice + Int(total) }
    
}

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
    var pageWidth: CGFloat = 612
    var commentBoxY: Int?
    var widths: Widths?
    
    // MARK: - COMPUTED PROPERTIES
    var invoicePDFData: Data {
        
        let format = UIGraphicsPDFRendererFormat()
        let metaData = [kCGPDFContextTitle: "Invoice", kCGPDFContextAuthor: "InView" ]
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let coreData = parentController!.contactController.coreData!
        
        widths = Widths(description: (pageWidth/2)-55, unit: 65, qty: 65, price: 85, total: pageWidth - ((pageWidth/2)+210))
       
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
            drawInfoBar(title: "BILL TO", inRect: CGRect(x: 20, y: 200, width: 250, height: 18), background: ThemeColors.blue, foreground: ColorManager().white)
            drawInfoBar(title: "SHIP TO", inRect: CGRect(x: 270 + headerGap, y: 200, width: 250, height: 18), background: ThemeColors.blue, foreground: ColorManager().white)
       
            // BILL TO and SHIP TO addresses
            let billingY = drawBillToAddress()
            let shippingY = drawShipToAddress(originX: 270 + Int(headerGap))
            let maxY = max(billingY,shippingY)
          
            // Draw line item header
            let theColumns = [
                
                Column( title: "Description", width: widths!.description),
                Column( title: "Unit", width: widths!.unit, justificaton: .right),
                Column( title: "QTY", width: widths!.qty, justificaton: .right),
                Column( title: "Unit Price", width: widths!.price, justificaton: .right),
                Column( title: "Amount", width: widths!.total, justificaton: .right)
            ]
            
            drawHeader(yLocation: maxY + 15, height: 18, font: UIFont.systemFont(ofSize: 12, weight: .semibold), columns: theColumns)
            drawLineItems(yLocation: maxY + 15 + 20, height: 20, font: UIFont.systemFont(ofSize: 12, weight: .semibold))
            
            drawCommentBox()
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
        
        webView.reloadFromOrigin()
        let pdfDocument = PDFDocument(data: invoicePDFData)
        
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentDirectoryURL.appendingPathComponent("invoice.pdf")
      
        pdfDocument!.write(to: fileURL)
        webView.load(URLRequest(url: fileURL))
    }
    
    // MARK: ACTION HANDLERS
    @IBAction func onReturn(_ sender: Any) {
        
        parentController!.companyController.companyDetailsView.showView(withTabBar: false)
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
    
    func drawBillToAddress() -> Int {
        
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
        
        return 225 + (20 * yIndex)
    }
    
    func drawShipToAddress(originX: Int) -> Int {
        
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
        
        return 225 + (20 * yIndex)
    }
    
    func drawHeader(yLocation: Int, height: Int, font: UIFont, columns: [Column]) {
        
        var xSegment = 20
    
        for column in columns {
            
            var paddedTitle: String?
            
            switch column.justificaton {
                
                case .left: paddedTitle = column.title.justified(width: column.width, justification: .left, font: font)
                case .center: paddedTitle = column.title.justified(width: column.width, justification: .center, font: font)
                case .right: paddedTitle = column.title.justified(width: column.width, justification: .right, font: font)
        
                default: break
            }
            
            drawInfoBar(title: paddedTitle, inRect: CGRect(x: xSegment, y: yLocation, width: Int(column.width), height: height), withFont: font, background: ThemeColors.blue, foreground: ColorManager(color: .white))
            xSegment += Int(column.width)
        }
    }
    
    func drawLineItems(yLocation: Int, height: Int, font: UIFont) {
        
        var lineBackgroundColor: ColorManager?
        let productsToInvoice = InvoiceManager.shared.createInvoiceItems(company: theCompany!)
        var theYLocation = yLocation
    
        for (index,value) in productsToInvoice.enumerated() {
            
            var xSegment = 20
           
            // The column values for this line
            let theColumns = [
                
                Column( title: value.productDescription!, width: widths!.description),
                Column( title: String(value.units).formattedValue, width: widths!.unit, justificaton: .right),
                Column( title: String(value.quantity).formattedValue, width: widths!.qty, justificaton: .right),
                Column( title: String(value.unitPrice).formattedDollar, width: widths!.price, justificaton: .right),
                Column( title: String(Double(value.quantity) * value.unitPrice).formattedDollar, width: widths!.total, justificaton: .right)
            ]
            
            // Set the background color (alternating white and gray)
            if index % 2 == 0 { lineBackgroundColor = ColorManager(color: .white) }
            else { lineBackgroundColor = ThemeColors.lightGray }
               
            // Set the column justifications
            for column in theColumns {
                
                var paddedTitle: String?
                
                switch column.justificaton {
                    
                    case .left: paddedTitle = column.title.justified(width: column.width, justification: .left, font: font)
                    case .center: paddedTitle = column.title.justified(width: column.width, justification: .center, font: font)
                    case .right: paddedTitle = column.title.justified(width: column.width, justification: .right, font: font)
                        
                    default: break
                }
                
                // Draw the column
                drawInfoBar(title: paddedTitle, inRect: CGRect(x: xSegment, y: theYLocation, width: Int(column.width), height: height), withFont: font, background: lineBackgroundColor!, foreground: ColorManager(color: .label))
              
                xSegment += Int(column.width)
                
            }
            
            theYLocation += height
        }
        
        if productsToInvoice.count < 13 {
            
            for index in productsToInvoice.count...13 {
                
                if index % 2 == 0 { lineBackgroundColor = ColorManager(color: .white) }
                else { lineBackgroundColor = ThemeColors.lightGray }
                
                // Draw the column
                drawInfoBar(title: " ", inRect: CGRect(x: 20, y: theYLocation, width: 560, height: height), withFont: font, background: lineBackgroundColor!, foreground: ColorManager(color: .label))
                theYLocation += height
            }
        }
        
        commentBoxY = theYLocation + 20
    }
    
    func drawCommentBox() {
        
        var yLocation = commentBoxY!
        let context = UIGraphicsGetCurrentContext()
        let inRect = CGRect(x: 20, y: yLocation, width: Int(pageWidth/2), height: 60)
        var columnValue: String?
        let font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        var invoiceSubtotal: Double = 0
        for product in productPendingInvoice! { invoiceSubtotal += (Double(product.quantity) * product.unitPrice) }
        let tax = invoiceInfo!.tax * invoiceSubtotal
        let discount: Double = 0.05 * invoiceSubtotal
      
        context!.addRect(inRect)
        UIColor.white.setFill()
        UIColor.label.setStroke()
        context!.drawPath(using: .fillStroke)
        
        drawInfoBar(title: "Comments", inRect: CGRect(x: 20, y: yLocation, width: Int(pageWidth/2), height: 18), background: ThemeColors.blue, foreground: ColorManager(color: .white))
        
        for (index,value) in ["Subtotal","Discount","Taxes","Invoice Total"].enumerated() {
            
            let justifiedText = value.justified(width: widths!.price, justification: .right, font: font) + "   "
            drawInfoBar(title: justifiedText, inRect: CGRect(x: widths!.totalToPrice - 50, y: yLocation-18, width: 100, height: 20), background: ColorManager(color: .white), foreground: ColorManager(color: .label))
            
            switch index {
                
                case 0: columnValue = String(format: "%.02f", invoiceSubtotal).formattedDollar
                case 1: columnValue = String(format: "-%.02f", discount).formattedDollar
                case 2: columnValue = String(format: "%.02f", tax).formattedDollar
                case 3: columnValue = String(format: "%.02f", invoiceSubtotal - (0.1 * invoiceSubtotal) + tax).formattedDollar
               
                default: break
            }
            
            let justifiedValue = columnValue!.justified(width: widths!.price, justification: .right, font: font)
            let offset = index == 2 ? 2 : 0
        
            drawInfoBar(title: justifiedValue, inRect: CGRect(x: widths!.totalToTotal + offset, y: yLocation-18, width: 100, height: 20), background: ColorManager(color: .white), foreground: ColorManager(color: .label))
         
            yLocation += 20
        }
    }
    
    func drawInfoBar(title: String? = "", inRect: CGRect, withFont: UIFont? = UIFont.systemFont(ofSize: 14, weight: .semibold), background: ColorManager, foreground: ColorManager) {
        
        let context = UIGraphicsGetCurrentContext()
        context!.addRect(inRect)
        
        let font = withFont!
        
        background.uicolor.setFill()
        UIColor.clear.setStroke()
        
        context!.drawPath(using: .fillStroke)
        
        if title != "" {
            
            let attributes = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: foreground.red, green: foreground.green, blue: foreground.blue, alpha: foreground.alpha),
                NSAttributedString.Key.backgroundColor: UIColor(displayP3Red: background.red, green: background.green, blue: background.blue, alpha: background.alpha)
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
 
 
 
 func justifyText(text: String, font: UIFont, columnWidth: CGFloat, justify: Justification) -> String {
     
     let justifiedText = text
     let widthOfSpace = " ".textSize(font: font).width
     let textSize = justifiedText.textSize(font: font)
     let paddingNeeded = columnWidth-textSize.width
   
     switch justify {
         
         case .left:
             return text
         
         case .right:
             let padding = paddingNeeded/widthOfSpace
             return justifiedText.padWithSpaces(before: Int(padding))
             
         case .center:
             let padding = (paddingNeeded/2)/widthOfSpace
             return justifiedText.padWithSpaces(before: Int(padding), after: Int(padding))
     }
 }
 */

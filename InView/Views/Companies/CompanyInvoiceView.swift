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

struct Column {
    
    var title: String
    var rect: CGRect
    var justification: Justification
}

class CompanyInvoiceView: ParentView {
    
    // MARK: - STORY BOARD OUTLETS
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: PROPERTIES
    var theCompany: Company?
    let pageWidth: CGFloat = 612
    let margin: CGFloat = 20
    let pageWidthMargined: CGFloat = 572
    let halfPageWidth: CGFloat = 286
    var infoOffset: CGFloat = 120
    let addressFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    let heightFont = UIFont.systemFont(ofSize: 10, weight: .regular)
    
    var paragraphStyle = NSMutableParagraphStyle()
    var invoiceInfo: DefaultInvoiceValue?
    var textRect: CGRect?
    var productPendingInvoice: [Product]?
    var commentBoxY: Int?
    var theColumns: [Column]?
    var totalColumnsWidth: CGFloat = 545
    var invoiceOptions = InvoiceOptions()
    var fileURL: URL?
  
    // MARK: - COMPUTED PROPERTIES
    var invoicePDFData: Data {
        
        let format = UIGraphicsPDFRendererFormat()
        let metaData = [kCGPDFContextTitle: "Invoice", kCGPDFContextAuthor: "InView" ]
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let coreData = parentController!.contactController.coreData!
        let theColumns = [
                Column(title: " Description", rect: CGRect(x: margin, y: 0, width: 230, height: 18), justification: .left),
                Column(title: "Unit", rect: CGRect(x: margin + 230, y: 0, width: 72, height: 18), justification: .left),
                Column(title: "Qty", rect: CGRect(x: margin + 302, y: 0, width: 65, height: 18), justification: .right),
                Column(title: "Unit Price", rect: CGRect(x: margin + 365, y: 0, width: 85, height: 18), justification: .right),
                Column(title: "Amount ", rect: CGRect(x: margin + 445, y: 0, width: 120, height: 18), justification: .right)
            ]
        
        invoiceInfo = parentController!.contactController.coreData!.defaultInvoiceValues!.first!
        format.documentInfo = metaData as [String: Any]
        
        let data = renderer.pdfData { (context) in
            
            // Initialization
            context.beginPage()
            paragraphStyle.alignment = .left
     
            // Logo image
            if !coreData.defaultInvoiceValues!.isEmpty { drawLogo() }
           
            // Top line: Company name and invoice title
            drawCompanyName()
            drawInvoiceTitle()
   
            // Company addressd
            drawCompanyAddress()
            
            // Invoice date and other info
            drawInvoiceInfo()
            
            // BILL TO and SHIP TO info bar
            let headerGap = pageWidth - 540
            drawInfoBar(title: " BILL TO", inRect: CGRect(x: 20, y: 200, width: 250, height: 18), background: ThemeColors.blue, foreground: ColorManager().white)
            drawInfoBar(title: " SHIP TO", inRect: CGRect(x: 270 + headerGap, y: 200, width: 250, height: 18), background: ThemeColors.blue, foreground: ColorManager().white)
       
            // BILL TO and SHIP TO addresses
            let billingY = drawBillToAddress()
            let shippingY = drawShipToAddress(originX: 270 + Int(headerGap))
            let maxY = max(billingY,shippingY)
           
            drawHeader(yLocation: maxY + 15, height: 18, font: UIFont.systemFont(ofSize: 12, weight: .semibold), columns: theColumns)
            drawLineItems(yLocation: maxY + 15 + 20, height: 20, font: UIFont.systemFont(ofSize: 12, weight: .semibold), columns: theColumns)
            
            drawCommentBox()
            drawThankYou()
        }
        
        return data
    }
   
    // MARK: METHODS
    func setCompany(company: Company, options: InvoiceOptions) {
        
        theCompany = company
        invoiceOptions = options
     
        productPendingInvoice = InvoiceManager.shared.createInvoiceItems(company: theCompany!)
        displayInvoice()
    }
  
    func displayInvoice() {
        
        webView.reloadFromOrigin()
        let pdfDocument = PDFDocument(data: invoicePDFData)
        
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = documentDirectoryURL.appendingPathComponent("invoice.pdf")
      
        pdfDocument!.write(to: fileURL!)
        webView.load(URLRequest(url: fileURL!))
    }
    
    // MARK: ACTION HANDLERS
    @IBAction func onSend(_ sender: Any) {
        
        AlertManager(controller: parentController!).popupWithCustomButtons(aMessage: "Send Invoice", buttonTitles: ["Email","Text","Cancel"], theStyle: [.default,.default,.destructive], theType: .actionSheet) { choice in
            
            let fileData = FileManager().contents(atPath: self.fileURL!.path(percentEncoded: true))
            
            if choice == 0 {
                
                let title = "Your invoice from " + self.theCompany!.name!
                let body = "Attached please find our invoice."
                self.parentController!.sendEmailWithAttachment(contentTitle: title, theBody: body, theSignature: self.invoiceInfo!.emailSignature!, fileType: "pdf", theData: fileData!)
                
            } else if choice == 1 {
           
                self.parentController!.sendMessageWithAttachment(contentTitle: self.invoiceOptions.invoiceNumber!, fileType: "pdf", theData: fileData!)
            }
        }
    }
    
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

                    // Date
                    let dateLength = "Date".textSize(font: addressFont).width
                    let today = DateManager().dateString
                
                    // Draw date
                    textRect = CGRect(x: 612-20-Int(dateLength + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                    "Date".draw(in: textRect!, withAttributes: attributes)
                
                    // Draw date
                    textRect!.origin.x += (dateLength + 15)
                    textRect!.size.width = today.textSize(font: addressFont).width + 2
                    today.draw(in: textRect!, withAttributes: attributes)
            
                case 1:
                
                    let invoiceLength = "Invoice #".textSize(font: addressFont).width

                    textRect = CGRect(x: 612-20-Int(invoiceLength + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                    "Invoice #".draw(in: textRect!, withAttributes: attributes)
                
                     // Draw invoice number
                     textRect!.origin.x += (invoiceLength + 15)
                     textRect!.size.width = invoiceOptions.invoiceNumber!.textSize(font: addressFont).width + 2
                     invoiceOptions.invoiceNumber!.draw(in: textRect!, withAttributes: attributes)
             
                case 2:

                    let termsLength = "Due Date".textSize(font: addressFont).width
                
                    textRect = CGRect(x: 612-20-Int(termsLength + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                    "Due Date".draw(in: textRect!, withAttributes: attributes)
                
                    // Draw terms
                    textRect!.origin.x += (termsLength + 15)
                    textRect!.size.width = invoiceOptions.terms!.textSize(font: addressFont).width + 2
                    invoiceOptions.terms!.draw(in: textRect!, withAttributes: attributes)
                
                case 3:

                    let poLength = "PO Reference".textSize(font: addressFont).width
                    textRect = CGRect(x: 612-20-Int(poLength + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                    "PO Reference".draw(in: textRect!, withAttributes: attributes)
                
                    // Draw po reference
                    textRect!.origin.x += (poLength + 15)
                    textRect!.size.width = invoiceOptions.poReference!.textSize(font: addressFont).width + 2
                    invoiceOptions.poReference!.draw(in: textRect!, withAttributes: attributes)
              
                case 4:

                    let nameLength = "Project ID / Name".textSize(font: addressFont).width
                    textRect = CGRect(x: 612-20-Int(nameLength + infoOffset), y: 80 + (20 * yInfo), width: Int(infoOffset), height: 20)
                    "Project ID / Name".draw(in: textRect!, withAttributes: attributes)
                
                    // Draw po reference
                    textRect!.origin.x += (nameLength + 15)
                    textRect!.size.width = invoiceOptions.projectName!.textSize(font: addressFont).width + 2
                    invoiceOptions.projectName!.draw(in: textRect!, withAttributes: attributes)
          
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
        
        var xOffset = Int(margin)
        var justifiedRect: CGRect?
    
        for column in columns {
            
            if column.justification == .left { justifiedRect = column.rect }
            else if column.justification == .right { justifiedRect = column.title.justified(textRect: column.rect, justification: .right, font: font) }
            else if column.justification == .center { justifiedRect = column.title.justified(textRect: column.rect, justification: .center, font: font) }
            
            let justificationOffset = justifiedRect!.origin.x - column.rect.origin.x
    
            drawInfoBar(title: column.title, inRect: CGRect(x: xOffset, y: yLocation, width: Int(column.rect.width), height: height), withOffset: justificationOffset, withFont: font, background: ThemeColors.blue, foreground: ColorManager(color: .white))
            xOffset += Int(column.rect.width)
        }
    }
    
    func drawLineItems(yLocation: Int, height: Int, font: UIFont, columns: [Column]) {
        
        var lineBackgroundColor: ColorManager?
        let productsToInvoice = InvoiceManager.shared.createInvoiceItems(company: theCompany!)
        var theYLocation = yLocation
    
        for (index,value) in productsToInvoice.enumerated() {
    
            var xOffset = margin
            var title: String?

            // Set the background color (alternating white and gray)
            if index % 2 == 0 { lineBackgroundColor = ColorManager(color: .white) }
            else { lineBackgroundColor = ThemeColors.lightGray }
               
            for (columnIndex,columnValue) in columns.enumerated() {
                
                var theTextRect = columnValue.rect
                theTextRect.origin.y = CGFloat(theYLocation)
                
                switch columnIndex {
                    
                    case ColumnType.shared.description: title = value.productDescription
                    case ColumnType.shared.unit: title = value.unitDescription
                    case ColumnType.shared.qty: title = String(value.quantity).formattedValue
                    case ColumnType.shared.price: title = String(value.unitPrice).formattedDollar
                    case ColumnType.shared.total: title = String(Double(value.quantity) * value.unitPrice).formattedDollar
                        
                    default: break
                }
                
                let justifiedTextRect = title!.justified(textRect: columnValue.rect, justification: columnValue.justification, font: font)
                let offset = justifiedTextRect.origin.x - theTextRect.origin.x
              
                theTextRect.origin.x = xOffset
                theTextRect.origin.y = CGFloat(theYLocation)
                
                // Draw the column
                drawInfoBar(title: title, inRect: theTextRect, withOffset: offset, withFont: font, background: lineBackgroundColor!, foreground: ColorManager(color: .label))
                xOffset += columnValue.rect.width
             
            }

            theYLocation += height
        }
        
        if productsToInvoice.count < 13 {
            
            for index in productsToInvoice.count...13 {
                
                if index % 2 == 0 { lineBackgroundColor = ColorManager(color: .white) }
                else { lineBackgroundColor = ThemeColors.lightGray }
                
                // Draw the column
                drawInfoBar(inRect: CGRect(x: Int(margin), y: theYLocation, width: Int(pageWidthMargined), height: height), withFont: font, background: lineBackgroundColor!, foreground: ColorManager(color: .label))
                theYLocation += height
            }
        }
        
        commentBoxY = theYLocation + 20
    }
    
    func drawCommentBox() {
        
        var yLocation = commentBoxY!
        let context = UIGraphicsGetCurrentContext()
        let inRect = CGRect(x: Int(margin), y: yLocation, width: Int(halfPageWidth), height: 60)
        var columnValue: String?
        let font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        var invoiceSubtotal: Double = 0
        
        for product in productPendingInvoice! { invoiceSubtotal += (Double(product.quantity) * product.unitPrice) }
        
        let discount: Double = invoiceOptions.discount * invoiceSubtotal
        let tax = invoiceInfo!.tax * (invoiceSubtotal-discount)
      
        context!.addRect(inRect)
        UIColor.white.setFill()
        UIColor.label.setStroke()
        context!.drawPath(using: .fillStroke)
        
        drawInfoBar(title: " Comments", inRect: CGRect(x: Int(margin), y: yLocation, width: Int(halfPageWidth), height: 18), withOffset: 0, background: ThemeColors.blue, foreground: ColorManager(color: .white))
        
        for (index,value) in ["Subtotal","Discount","Taxes","Invoice Total"].enumerated() {
            
            var theTextRect = CGRect(x: Int(margin + 300), y: yLocation - 18, width: 100, height: 20)
            var justifiedRect = value.justified(textRect: theTextRect, justification: .right, font: font)
            var offset = justifiedRect.origin.x - theTextRect.origin.x
            
            drawInfoBar(title: value, inRect: theTextRect, withOffset: offset, background: ColorManager(color: .white), foreground: ColorManager(color: .label))
            
            switch index {
                
                case 0: columnValue = String(format: "%.02f", invoiceSubtotal).formattedDollar
                case 1: columnValue = "-" + String(format: "%.02f", discount).formattedDollar
                case 2: columnValue = String(format: "%.02f", tax).formattedDollar
                case 3: columnValue = String(format: "%.02f", invoiceSubtotal - (0.1 * invoiceSubtotal) + tax).formattedDollar
               
                default: break
            }
            
            theTextRect = CGRect(x: Int(margin) + 440 + (index == 2 ? 1 : 0), y: yLocation - 18, width: 120, height: 20)
            justifiedRect = columnValue!.justified(textRect: theTextRect, justification: .right, font: font)
            offset = justifiedRect.origin.x - theTextRect.origin.x
            
            drawInfoBar(title: columnValue!, inRect: theTextRect, withOffset: offset, background: ColorManager(color: .white), foreground: ColorManager(color: .label))
            yLocation += 20
        }
    }
    
    func drawInfoBar(title: String? = "", inRect: CGRect, withOffset: CGFloat? = 0, withFont: UIFont? = UIFont.systemFont(ofSize: 14, weight: .semibold), background: ColorManager, foreground: ColorManager) {
        
        let font = withFont!
        let context = UIGraphicsGetCurrentContext()
      
        // Draw box
        context!.addRect(inRect)
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
         
            // Draw text
            theTextRect.origin.x = inRect.origin.x + withOffset!
            theTextRect.origin.y += (inRect.size.height/2 - textSize.height/2)
            title!.draw(in: theTextRect, withAttributes: attributes)
        }
    }
    
    func drawThankYou() {
        
        let font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]

        let message = "Thank You For Your Business!"
        let JustifiedMessageRect = message.justified(textRect: CGRect(x: margin, y: CGFloat(commentBoxY! + 70), width: halfPageWidth, height: message.textSize(font: font).height + 10), justification: .center, font: font)

        message.draw(in: JustifiedMessageRect, withAttributes: attributes)
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

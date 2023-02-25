//
//  ProjectDocumentView.swift
//  InView
//
//  Created by Roger Vogel on 10/11/22.
//

import UIKit
import QuickLook
import AlertManager

class ProjectDocumentView: ParentView {
   
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var documentCollectionView: UICollectionView!
    @IBOutlet weak var editModeButton: UIButton!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var recordCountLabel: UILabel!
    
    // MARK: - PROPERTIES
    var selectedIndex: Int?
    var selectedDocument: Document?
    var selectedCell: DocumentCollectionCell?
    
    var isEditMode: Bool = false
    var theProject: Project?
    var currentViewURL: URL?
    var theDocuments = [Document]()
    var quickLookController = QLPreviewController()
    var documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.content] )
    
    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        documentCollectionView.delegate = self
        documentCollectionView.dataSource = self
        documentCollectionView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
        quickLookController.delegate = self
        quickLookController.dataSource = self
       
        documentPicker.delegate = self
      
        
        super.initView(inController: inController)
    }

    // MARK: - METHODS
    func setProjectRecord(project: Project) {
        
        theProject = project
        projectNameLabel.text = theProject!.name
        reloadDocumentCollection()
    }
    
    func reloadDocumentCollection() {
       
        theDocuments.removeAll()
        
        for setItem in theProject!.documents! { theDocuments.append(setItem as! Document) }
    
        theDocuments.sort { $0.timestamp! > $1.timestamp! }
        documentCollectionView.reloadData()
    
        let description = theProject!.documents!.count == 1 ? "Document" : "Documents"
        recordCountLabel.text = String(format: "%d " + description, theProject!.documents!.count )
       
    }
    
    // Add a new document(s) from picker
    func addNewDocuments(urls: [URL]) {
 
        for url in urls {
            
            let newDocument = Document(context: GlobalData.shared.viewContext)
            let fileName = url.lastPathComponent
            let nameComponents = fileName.split(separator: ".")
            
            newDocument.id = UUID()
            newDocument.timestamp = Date()
            
            // Store document name and extension
            if nameComponents.count > 1 {
                
                newDocument.name = String(nameComponents[0])
                newDocument.fileExtension = String(nameComponents.last!)
                
            } else {
                
                newDocument.name = fileName
                newDocument.fileExtension = ""
            }
            
            readFile(url: url) { fileData in
                
                newDocument.content = fileData.base64EncodedString()
                self.theProject!.addToDocuments(newDocument)
            }
        }
        
        GlobalData.shared.saveCoreData()
        reloadDocumentCollection()
    }
    
    // Create a url for the selected document
    func createDocumentURL() -> URL? {
        
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
        
        currentViewURL = fileURL
        return currentViewURL!
    }
    
    func readFile(url: URL, atCompletion: @escaping (Data)-> Void) {
        
        var error: NSError? = nil
        
        NSFileCoordinator().coordinate(readingItemAt: url, error: &error) { (url) in
                
            let accessGranted = url.startAccessingSecurityScopedResource()
            guard accessGranted else { NSLog("ACCESS NOT GRANTED"); return }
            
            // Get the file data
            let fileData = FileManager().contents(atPath: url.path)
            
            url.stopAccessingSecurityScopedResource()
            atCompletion(fileData!)
        }
    }

    // MARK: - ACTION HANDLERS
    @IBAction func onPlus(_ sender: Any) {
        
        parentController!.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func onReturn(_ sender: Any) { parentController!.projectController.projectDetailsView.showView(withTabBar: false) }
   
    @IBAction func onEditMode(_ sender: UIButton) {
        
        isEditMode = !isEditMode
        if !isEditMode && selectedCell != nil { selectedCell!.onCloseEdit() }
        
        var buttonImage: UIImage?
        buttonImage = isEditMode ? UIImage(systemName: "pencil.circle.fill") : UIImage(systemName: "pencil.circle")
        sender.setImage(buttonImage, for: .normal)
       
        reloadDocumentCollection()
    }
}

// MARK: - COLLECTION VIEW DELEGATE PROTOCOL
extension ProjectDocumentView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    // Number of items in a section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard theProject != nil else { return 0 }
        return theProject!.documents!.count
    }
    
    // Dequeue cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "documentCollectionStyle", for: indexPath) as! DocumentCollectionCell
        let document = theDocuments[indexPath.row]
    
        cell.delegate = self
        cell.myIndex = indexPath.row
        cell.deleteIcon.isHidden = !isEditMode
     
        var fileType = FileTypes.types[document.fileExtension!.lowercased()]
        if fileType == nil { fileType = "" }
        
        cell.documentNameTextField.text = document.name!
        
        cell.documentTypeLabel.text = fileType
        cell.documentNameTextField.isEnabled = isEditMode
        cell.documentNameTextField.borderStyle = isEditMode ? UITextField.BorderStyle.roundedRect : UITextField.BorderStyle.none
        cell.documentNameTextField.backgroundColor = isEditMode ? .white : .clear
    
        return cell
    }
    
    // Select cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isEditMode && selectedCell != nil { selectedCell!.onCloseEdit() }
        
        selectedCell = collectionView.cellForItem(at: indexPath) as? DocumentCollectionCell
        selectedDocument = theDocuments[indexPath.row]
        selectedIndex = indexPath.row
        
        if isEditMode {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Delete Document", aMessage: "Are your sure you want to delete " + selectedDocument!.name!, buttonTitles: ["CANCEL","DELETE"], theStyle: [.cancel,.destructive], theType: .actionSheet) { choice in
                
                if choice == 1 {
                    
                    self.theProject!.removeFromDocuments(self.selectedDocument!)
                    self.theDocuments.remove(at: indexPath.row)
                    self.reloadDocumentCollection()
                    self.onEditMode(self.editModeButton)
                }
            }
            
        } else {
            
            parentController!.projectController.launchPrimaryView = false
        
            quickLookController.currentPreviewItemIndex = 0
            quickLookController.reloadData()
            parentController!.present(self.quickLookController, animated: true, completion: nil)
        }
    }
}

// MARK: QUICK LOOK CONTROLLER DELEGATE
extension ProjectDocumentView: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { return 1 }
    
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        
        // Delete from temp disk after viewing
        let fileManager = FileManager()
        
        do { try fileManager.removeItem(at: currentViewURL!) }
        catch { NSLog( "\(error)") }
    }
     
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
       
        return createDocumentURL()! as QLPreviewItem
    }
}

// MARK: DOCUMENT PICKER DELEGATE PROTOCOL
extension ProjectDocumentView: UIDocumentPickerDelegate {
   
    func documentPicker(_ picker: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard urls.count > 0 else { return }
        addNewDocuments(urls: urls)
    }
    
    func documentPickerWasCancelled(_ picker: UIDocumentPickerViewController) { parentController!.dismiss(animated: true) }
}

// MARK: - PROJECT COLLLECTION CELL DELEGATE PROTOCOL
extension ProjectDocumentView: ProjectCollectionCellDelegate {
    
    func nameEditingInProgress() { }
        
    func nameEditingCompleted(name: String, forCellIndex: Int) {
        
        theDocuments[forCellIndex].name = name
        
        for document in theProject!.documents! {
            
            let theDocument = document as! Document
            if theDocuments[forCellIndex].id == theDocument.id { theDocument.name = name }
        }
        
        GlobalData.shared.saveCoreData()
    }
}

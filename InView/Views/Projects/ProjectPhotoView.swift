//
//  ProjectPhotoView.swift
//  InView
//
//  Created by Roger Vogel on 10/10/22.
//

import UIKit
import QuickLook
import AlertManager

class ProjectPhotoView: ParentView {
  
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var editModeButton: UIButton!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var recordCountLabel: UILabel!
    
    // MARK: - PROPERTIES
    var isEditMode: Bool = false
    var theProject: Project?
    var thePhotos = [Photo]()
    var imagePickerController = UIImagePickerController()
   
    var selectedPhoto: Photo?
    var selectedPhotoIndex: Int?

    // MARK: - INITIALIZATION
    override func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
       
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        photoCollectionView.contentSize = CGSize(width: self.frame.width/2, height: self.frame.width/3)
     
        imagePickerController.delegate = self
      
        super.initView(inController: inController)
    }
    
    // MARK: - METHODS
    func setProjectRecord(project: Project) {
        
        theProject = project
        projectNameLabel.text = theProject!.name
        reloadPhotoCollection()
    }
    
    func reloadPhotoCollection() {
       
        thePhotos.removeAll()
        
        for setItem in theProject!.photos! { thePhotos.append(setItem as! Photo) }
    
        thePhotos.sort { $0.timestamp! > $1.timestamp! }
        photoCollectionView.reloadData()
    
        let description = theProject!.photos!.count == 1 ? "Photo" : "Photos"
        recordCountLabel.text = String(format: "%d " + description, theProject!.photos!.count )
       
    }
   
    // MARK: - ACTION HANDLERS
    @IBAction func onPlus(_ sender: Any) {
        
        AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Choose Photo Source", buttonTitles: ["Use the Camera","Photo Library","Cancel"], theStyle: [.default,.default,.destructive], theType: .actionSheet) { choice in
            
            switch choice {
                
                case 0:
                   
                    self.parentController!.projectController.launchPrimaryView = false
                    self.imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                    self.parentController!.present(self.imagePickerController, animated: true, completion: nil)
                    
                case 1:
                    
                    self.parentController!.projectController.launchPrimaryView = false
                    self.imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                    self.parentController!.present(self.imagePickerController, animated: true, completion: nil)
        
                default: break
            }
        }
    }
    
    @IBAction func onEditMode(_ sender: UIButton) {
        
        isEditMode = !isEditMode
       
        var buttonImage: UIImage?
        buttonImage = isEditMode ? UIImage(systemName: "pencil.circle.fill") : UIImage(systemName: "pencil.circle")
        sender.setImage(buttonImage, for: .normal)
        
        reloadPhotoCollection()
    }
    
    @IBAction func onReturn(_ sender: Any) { parentController!.projectController.projectDetailsView.showView(withTabBar: false) }
}

// MARK: - COLLECTION VIEW DELEGATE PROTOCOL
extension ProjectPhotoView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Report number or sections
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    // Report number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard theProject != nil else { return 0 }
        return theProject!.photos!.count
    }
    
    // Dequeue a cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionStyle", for: indexPath) as! PhotoCollectionCell
        let photo = thePhotos[indexPath.row]
        
        cell.delegate = self
        cell.myIndex = indexPath.row
        cell.deleteIcon.isHidden = !isEditMode
        cell.photoNameTextField.text = photo.name!
        
        cell.photoNameTextField.isEnabled = isEditMode
        cell.photoNameTextField.borderStyle = isEditMode ? UITextField.BorderStyle.roundedRect : UITextField.BorderStyle.none
        cell.photoNameTextField.backgroundColor = isEditMode ? .white : .clear
        
        let photoData = Data(base64Encoded: thePhotos[indexPath.row].photo!)!
        cell.photoImageView.image = UIImage(data: photoData)!
        cell.deleteIcon.isHidden = !isEditMode
        
        return cell
    }
    
    // Cell selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedPhoto = thePhotos[indexPath.row]
        selectedPhotoIndex = indexPath.row
        
        if isEditMode {
            
            AlertManager(controller: GlobalData.shared.activeController!).popupWithCustomButtons(aTitle: "Delete Photo", aMessage: "Are your sure you want to delete this photo?", buttonTitles: ["CANCEL","DELETE"], theStyle: [.cancel,.destructive], theType: .actionSheet) { choice in
                
                if choice == 1 {
                    
                    self.theProject!.removeFromPhotos(self.selectedPhoto!)
                    self.thePhotos.remove(at: indexPath.row)
                    self.onEditMode(self.editModeButton)
                    self.reloadPhotoCollection()
                }
            }
            
        } else {
            
            selectedPhotoIndex = indexPath.row
            
            parentController!.projectController.projectPhotoViewer.setPhoto(photo: selectedPhoto!)
            parentController!.projectController.projectPhotoViewer.showView(withTabBar: false)
        }
    }
}

// MARK: - IMAGE PICKER CONTROLLER DELEGATE
extension ProjectPhotoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        parentController!.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        let theImage = info[.originalImage] as? UIImage
        let encodedImage = theImage!.jpegData(compressionQuality: 0.5)!.base64EncodedString()
        let newImage = Photo(context: GlobalData.shared.viewContext)
            
        newImage.id = UUID()
        newImage.timestamp = Date()
        newImage.name = "New Photo"
        newImage.photo = encodedImage
        
        theProject!.addToPhotos(newImage)
        GlobalData.shared.saveCoreData()
        
        reloadPhotoCollection()
        
        parentController!.dismiss(animated: true)
       
    }
}

// MARK: - DOCUMENT CELL DELEGATE PROTOCOL
extension ProjectPhotoView: ProjectCollectionCellDelegate {
  
    func nameEditingInProgress() { }
   
    func nameEditingCompleted(name: String, forCellIndex: Int) {
        
        thePhotos[forCellIndex].name = name
        
        for photo in theProject!.photos! {
            
            let thePhoto = photo as! Photo
            if thePhotos[forCellIndex].id == thePhoto.id { thePhoto.name = name }
        }
        
        GlobalData.shared.saveCoreData()
    }
}

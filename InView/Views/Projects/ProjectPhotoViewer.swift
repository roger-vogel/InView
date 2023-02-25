//
//  ProjectPhotoViewerView.swift
//  InView
//
//  Created by Roger Vogel on 10/10/22.
//

import UIKit
import DateManager

class ProjectPhotoViewer: ParentView {

    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var photoInfoLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var aspectButton: UIButton!
    @IBOutlet weak var photoNameLabel: UILabel!
    
    // MARK: - PROPERTIE
    var thePhoto: Photo?
   
    // MARK: - METHODS
    func setPhoto(photo: Photo) {
        
        photoNameLabel.text = photo.name!
        photoInfoLabel.text = DateManager(date: photo.timestamp).dateAndTimeString
      
        let photoData = Data(base64Encoded: photo.photo!)!
        let theImage = UIImage(data: photoData)!
      
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.image = theImage
        
        aspectButton.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right.circle"), for: .normal)
    }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onAspect(_ sender: UIButton) {
        
        if photoImageView.contentMode == .scaleAspectFit {
            
            photoImageView.contentMode = .scaleAspectFill
            sender.setImage(UIImage(systemName: "arrow.down.right.and.arrow.up.left.circle"), for: .normal)
            photoInfoLabel.backgroundColor = .white
            photoInfoLabel.alpha = 0.75
        
        } else{
            
            photoImageView.contentMode = .scaleAspectFit
            sender.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right.circle"), for: .normal)
            photoInfoLabel.backgroundColor = .clear
            photoInfoLabel.alpha = 1.0
        }
    }

    @IBAction func onReturn(_ sender: Any) {
        
        dismissKeyboard()
        parentController!.projectController.projectPhotoView.showView(withTabBar: false)
    }
}

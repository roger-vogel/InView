//
//  PhotoCollectionCell.swift
//  InView
//
//  Created by Roger Vogel on 10/10/22.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var photoNameTextField: UITextField!
    
    // MARK: - PROPERTIES
    var myIndex: Int?
    weak var delegate: ProjectCollectionCellDelegate?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
        
        photoImageView.roundCorners(corners: .all, radius: 10)
        deleteIcon.isHidden = true
        
        photoNameTextField.borderStyle = .none
        photoNameTextField.backgroundColor = .clear
        photoNameTextField.isEnabled = false
       
        super.awakeFromNib()
    }
    
    // MARK: - METHODS
    func onCloseEdit() { onPrimaryAction(self) }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onEditBegan(_ sender: Any) { delegate!.nameEditingInProgress() }
    
    @IBAction func onPrimaryAction(_ sender: Any) {
        
        endEditing(true)
        delegate!.nameEditingCompleted(name: photoNameTextField.text!, forCellIndex: myIndex!)
    }
        
}

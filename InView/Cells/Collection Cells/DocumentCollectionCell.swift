//
//  DocumentCollectionCell.swift
//  InView
//
//  Created by Roger Vogel on 10/11/22.
//

import UIKit

class DocumentCollectionCell: UICollectionViewCell {
    
    // MARK: - STORYBOARD CONNECTORS
    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var documentTypeLabel: UILabel!
    @IBOutlet weak var documentNameTextField: UITextField!
    @IBOutlet weak var deleteIcon: UIImageView!
    
    // MARK: - PROPERTIES
    var myIndex: Int?
    weak var delegate: ProjectCollectionCellDelegate?
    
    // MARK: - INITIALIZATION
    override func awakeFromNib() {
        
        deleteIcon.isHidden = true
        documentNameTextField.borderStyle = .none
        documentNameTextField.backgroundColor = .clear
        documentNameTextField.isEnabled = false
       
        super.awakeFromNib()
    }
    
    // MARK: - METHODS
    func onCloseEdit() { onPrimaryAction(self) }
    
    // MARK: - ACTION HANDLERS
    @IBAction func onEditingBegan(_ sender: Any) { delegate!.nameEditingInProgress() }
        
    @IBAction func onPrimaryAction(_ sender: Any) {
        
        endEditing(true)
        delegate!.nameEditingCompleted(name: documentNameTextField.text!, forCellIndex: myIndex!)
    }
}

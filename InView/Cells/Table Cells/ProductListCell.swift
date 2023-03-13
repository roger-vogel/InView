//
//  ProductListCell.swift
//  InView-2
//
//  Created by Roger Vogel on 3/12/23.
//

import UIKit

class ProductListCell: UITableViewCell {
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var unitMeasureTextField: UITextField!
    @IBOutlet weak var unitPriceTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryTextField.setPadding(left: 4, right: 4)
        categoryTextField.addRightBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        categoryTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        
        descriptionTextField.setPadding(left: 4, right: 4)
        descriptionTextField.addRightBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        descriptionTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        
        unitMeasureTextField.setPadding(left: 4, right: 4)
        unitMeasureTextField.addRightBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        unitMeasureTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
        
        unitPriceTextField.setPadding(left: 4, right: 8)
        unitPriceTextField.addBottomBorder(with: ThemeColors.mediumGray.uicolor, andWidth: 1.0)
    }
}

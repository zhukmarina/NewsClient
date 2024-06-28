//
//  CategoryCollectionViewCell.swift
//  NewsClient
//
//  Created by Marina Zhukova on 19.06.2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
 
    func configure(with category: String){
        categoryTitleLabel.text = category
    }
    
    override func awakeFromNib() {
           super.awakeFromNib()
       }
}




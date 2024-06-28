//
//  LocalCollectionViewCell.swift
//  NewsClient
//
//  Created by Marina Zhukova on 14.06.2024.
//

import UIKit

class LocalCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with article: CDNewsInfo) {
        titleLabel?.text = article.title
     authorLabel?.text = article.author
        dateLabel.text = DateFormatterHelper.formatDateString(from: article.datePub ?? "",
                                                                       inputFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'",
                                                                       outputFormat: "dd MMM yyyy, HH:mm")
              
     sourceLabel?.text = article.sourceName
       
        if let imageURLString = article.image, let imageURL = URL(string: imageURLString) {
                   imageView.loadImage(from: imageURL)
               } else {
                   imageView.image = UIImage(named: "placeholder")
               }
       }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

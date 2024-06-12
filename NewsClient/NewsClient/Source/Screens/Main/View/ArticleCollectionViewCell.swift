//  ArticleCollectionViewCell.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with article: DMNewsInfo.Articles) {
        titleLabel?.text = article.title
        authorLabel?.text = article.author
        dateLabel?.text = article.publishedAt
        
    }
}




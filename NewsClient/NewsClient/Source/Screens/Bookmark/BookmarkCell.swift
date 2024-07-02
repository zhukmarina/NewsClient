//
//  BookmarkCell.swift
//  NewsClient
//
//  Created by Marina Zhukova on 20.06.2024.
//
import UIKit


class BookmarkCell: UICollectionViewCell{
    @IBOutlet weak var titleLabel: UILabel!
      @IBOutlet weak var authorLabel: UILabel!
      @IBOutlet weak var dateLabel: UILabel!
      @IBOutlet weak var sourceLabel: UILabel!
  
      @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
               super.awakeFromNib()
      
    }
    func configure(with article: CDNewsInfo) {
           titleLabel?.text = article.title
           authorLabel?.text = article.author
           dateLabel?.text = DateFormatterHelper.formatDateString(from: article.datePub ?? "",
                                                                       inputFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'",
                                                                       outputFormat: "dd MMM yyyy, HH:mm")
           sourceLabel?.text = article.sourceName
         
           
           if let imageURLString = article.image, let imageURL = URL(string: imageURLString) {
               thumbnailImageView?.loadImage(from: imageURL)
           } else {
               thumbnailImageView.image = UIImage(named: "placeholder")
           }
       }

   }

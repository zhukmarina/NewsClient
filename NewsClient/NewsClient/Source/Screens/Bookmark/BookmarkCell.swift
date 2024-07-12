//  BookmarkCell.swift
//  NewsClient
//
//  Created by Marina Zhukova on 20.06.2024.
//
import UIKit

class BookmarkCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var redirectToSafari: UIButton!
    @IBOutlet weak var addToBookmark: UIButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    private var articleURL: URL?
    var coreDataService: CoreDataService?
    var article: CDNewsInfo?
    
    func configure(with article: CDNewsInfo) {
        titleLabel?.text = article.title
        authorLabel?.text = article.author
        dateLabel?.text = DateFormatterHelper.formatDateString(from: article.datePub ?? "", inputFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'", outputFormat: "dd MMM yyyy, HH:mm")
        sourceLabel?.text = article.sourceName
        
        if let urlString = article.url, let url = URL(string: urlString) {
            articleURL = url
        } else {
            articleURL = nil
        }
        
        if let imageURLString = article.image, let imageURL = URL(string: imageURLString) {
            thumbnailImageView?.loadImage(from: imageURL)
        } else {
            thumbnailImageView.image = UIImage(named: "placeholder")
        }
        
        self.article = article
        updateBookmarkButton(for: article)
    }
    
    private func updateBookmarkButton(for article: CDNewsInfo) {
        guard let coreDataService = coreDataService else { return }
        let isBookmarked = coreDataService.isArticleBookmarked(article)
        let bookmarkImageName = isBookmarked ? "bookmark.fill" : "bookmark"
        addToBookmark.setImage(UIImage(systemName: bookmarkImageName), for: .normal)
        print(isBookmarked)
    }
    
    @IBAction func addToBookmarkAction(_ sender: UIButton) {
        guard let coreDataService = coreDataService, let article = article else { return }
        let isBookmarked = coreDataService.isArticleBookmarked(article)
        
        if isBookmarked {
            coreDataService.deleteBookmark(with: article) {
                self.updateBookmarkButton(for: article)
            }
        } else {
            coreDataService.insertBookmark(with: article) {
                self.updateBookmarkButton(for: article)
            }
        }
        print(isBookmarked)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        redirectToSafari.addTarget(self, action: #selector(redirectToSafariButtonTapped), for: .touchUpInside)
    }
    
    @objc private func redirectToSafariButtonTapped() {
        guard let url = articleURL else {
            print("Invalid URL")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

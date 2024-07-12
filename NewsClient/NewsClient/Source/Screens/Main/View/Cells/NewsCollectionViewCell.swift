//  NewsCollectionViewCell.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var redirectToSafarilLabel: UIButton!
    @IBOutlet weak var addToBookmarkButton: UIButton!
    
    private var articleURL: URL?
    var coreDataService: CoreDataService?
    var articles: [DMNewsInfo.Articles] = []
    var selectedIndex: Int?

    func configure(with article: DMNewsInfo.Articles, at index: Int, articles: [DMNewsInfo.Articles]) {
        titleLabel?.text = article.title
        authorLabel?.text = article.author
        dateLabel?.text = DateFormatterHelper.formatDateString(from: article.publishedAt, inputFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'", outputFormat: "dd MMM yyyy, HH:mm")
        sourceLabel?.text = article.source.name
        
        if let urlString = article.url, let url = URL(string: urlString) {
            articleURL = url
        } else {
            articleURL = nil
        }
        
        if let imageURLString = article.urlToImage, let imageURL = URL(string: imageURLString) {
            imageView.loadImage(from: imageURL)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
        
        self.articles = articles
        self.selectedIndex = index
        
        updateBookmarkButton(for: article)
    }
    
    private func updateBookmarkButton(for article: DMNewsInfo.Articles) {
        guard let coreDataService = coreDataService else { return }
        let isBookmarked = coreDataService.isArticleBookmarked(article)
        let bookmarkImageName = isBookmarked ? "bookmark.fill" : "bookmark"
        addToBookmarkButton.setImage(UIImage(systemName: bookmarkImageName), for: .normal)
        print(isBookmarked)
    }
    
    @IBAction func addToBookmarkAction(_ sender: UIButton) {
        guard let coreDataService = coreDataService else { return }
        guard let selectedIndex = selectedIndex, selectedIndex < articles.count else {
            print("Invalid selectedIndex")
            return
        }
        
        let article = articles[selectedIndex]
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
        redirectToSafarilLabel.addTarget(self, action: #selector(redirectToSafariButtonTapped), for: .touchUpInside)
    }
    
    @objc private func redirectToSafariButtonTapped() {
        guard let url = articleURL else {
            print("Invalid URL")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

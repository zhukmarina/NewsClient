import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var datePubLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var articles: [DMNewsInfo.Articles] = []
    var selectedIndex: Int = 0
    var coreDataService: CoreDataService!

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataService = CoreDataService()
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }

    private func setupView() {
        guard articles.indices.contains(selectedIndex) else {
                   print("Article index out of range")
                   return
               }
        
        let article = articles[selectedIndex]
        titleLabel.text = article.title
        authorLabel.text = article.author
        datePubLabel.text = DateFormatterHelper.formatDateString(from: article.publishedAt,
                                                                       inputFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'",
                                                                       outputFormat: "dd MMM yyyy, HH:mm")
        sourceLabel.text = article.source.name
        descriptionLabel.text = article.description

        if let imageURLString = article.urlToImage, let imageURL = URL(string: imageURLString) {
            imageView.loadImage(from: imageURL)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }

        updateBookmarkButton(for: article)
    }


    @IBAction func addToBookmarkAction(_ sender: UIButton) {
        let article = articles[selectedIndex]
        let isBookmarked = coreDataService.isArticleBookmarked(article)
        
        if isBookmarked {
            coreDataService.deleteBookmark(with: article)
        } else {
            coreDataService.insertBookmark(with: article)
        }
        
        updateBookmarkButton(for: article)
        
       
    }
    
    private func updateBookmarkButton(for article: DMNewsInfo.Articles) {
        let isBookmarked = coreDataService.isArticleBookmarked(article)
        let bookmarkImageName = isBookmarked ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: bookmarkImageName), for: .normal)
    }
}

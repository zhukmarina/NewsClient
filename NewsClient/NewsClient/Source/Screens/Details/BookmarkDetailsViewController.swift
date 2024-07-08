import UIKit

class BookmarkDetailsViewController: UIViewController {
    
    @IBOutlet weak var datePubLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var bookmarkedArticles: [CDNewsInfo] = []
    var selectedIndex: Int = 0
    var coreDataService: CoreDataService!
    weak var bookmarkDelegate: BookmarkDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataService = CoreDataService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    private func setupView() {
        let article = bookmarkedArticles[selectedIndex]
        titleLabel.text = article.title
        authorLabel.text = article.author
        datePubLabel.text = DateFormatterHelper.formatDateString(from: article.datePub ?? "",
                                                                 inputFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'",
                                                                 outputFormat: "dd MMM yyyy, HH:mm")
        sourceLabel.text = article.sourceName
        descriptionLabel.text = article.bodyInfo
        
        if let imageURLString = article.image, let imageURL = URL(string: imageURLString) {
            imageView.loadImage(from: imageURL)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
        
        updateBookmarkButton(for: article)
    }
    
    @IBAction func addToBookmarkAction(_ sender: UIButton) {
        let article = bookmarkedArticles[selectedIndex]
        if article.isBookmarked {
            coreDataService.deleteBookmark(with: article) {
                self.updateBookmarkButton(for: article)
                self.bookmarkDelegate?.didUpdateBookmarkStatus()
            }
        } else {
            coreDataService.insertBookmark(with: article) {
                self.updateBookmarkButton(for: article)
                self.bookmarkDelegate?.didUpdateBookmarkStatus()
            }
        }
    }
    
    private func updateBookmarkButton(for article: CDNewsInfo) {
        let isBookmarked = coreDataService.isArticleBookmarked(article)
        let bookmarkImageName = isBookmarked ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: bookmarkImageName), for: .normal)
        print(isBookmarked)
    }
}

import UIKit

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var bookmarkCollectionView: UICollectionView!
    
    var bookmarks: [CDNewsInfo] = []
    var coreDataService: CoreDataService!
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkCollectionView.delegate = self
        bookmarkCollectionView.dataSource = self
        bookmarkCollectionView.register(UINib(nibName: "BookmarkCell", bundle: nil), forCellWithReuseIdentifier: "BookmarkCell")
        
        coreDataService = CoreDataService()

        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarks()
    }

    func loadBookmarks() {
        guard coreDataService != nil else {
            print("coreDataService is nil")
            return
        }
        bookmarks = coreDataService.fetchBookmarks()
        bookmarkCollectionView.reloadData()
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshBookmarks(_:)), for: .valueChanged)
        bookmarkCollectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshBookmarks(_ sender: Any) {
        loadBookmarks()
        refreshControl.endRefreshing()
    }
}

extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bookmarkCollectionView.dequeueReusableCell(withReuseIdentifier: "BookmarkCell", for: indexPath) as! BookmarkCell
        let bookmarkedArticle = bookmarks[indexPath.item]
        cell.coreDataService = coreDataService
        cell.configure(with: bookmarkedArticle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArticle = bookmarks[indexPath.item]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "BookmarkDetailsViewController") as? BookmarkDetailsViewController {
            detailVC.bookmarkedArticles = [selectedArticle]
            detailVC.selectedIndex = 0
            detailVC.bookmarkDelegate = self
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension BookmarkViewController: BookmarkDelegate {
    func didUpdateBookmarkStatus() {
        loadBookmarks()
    }
}

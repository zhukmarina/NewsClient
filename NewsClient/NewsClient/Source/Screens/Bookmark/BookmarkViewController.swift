import UIKit

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var bookmarkCollectionView: UICollectionView!
    
    var bookmarks: [CDNewsInfo] = []
    var coreDataService = CoreDataService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkCollectionView.delegate = self
        bookmarkCollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarks()
    }

    func loadBookmarks() {
           bookmarks = coreDataService.fetchBookmarks()
           bookmarkCollectionView.reloadData()
       }
    
}

extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bookmarkCollectionView.dequeueReusableCell(withReuseIdentifier: "BookmarkCell", for: indexPath) as! BookmarkCell
        let bookmarkedArticle = bookmarks[indexPath.item]
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

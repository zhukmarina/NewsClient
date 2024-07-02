import UIKit

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var bookmarkCollectionView: UICollectionView!
    
    var bookmarks: [CDNewsInfo] = []
    var coreDataService = CoreDataService.shared  // Використовуємо єдиний екземпляр

    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkCollectionView.delegate = self
        bookmarkCollectionView.dataSource = self
        
//        bookmarkCollectionView.register(UINib(nibName: "BookmarkCell", bundle: nil), forCellWithReuseIdentifier: "BookmarkCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarks()
    }

    func loadBookmarks() {
        bookmarks = coreDataService.fetchBookmarks()
        bookmarkCollectionView.reloadData()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            guard let detailVC = segue.destination as? DetailsViewController else {
//                print("Segue setup failed: destination is not DetailsViewController")
//                return
//            }
//            
//            if let article = sender as? CDNewsInfo {
//                detailVC.articles = [article]
//                detailVC.selectedIndex = 0
//            } else if let articleTuple = sender as? (articles: [CDNewsInfo], selectedIndex: Int) {
//                detailVC.articles = articleTuple.articles
//                detailVC.selectedIndex = articleTuple.selectedIndex
//            } else {
//                print("Invalid sender type: expected CDNewsInfo or (articles: [CDNewsInfo], selectedIndex: Int)")
//            }
//        }
//    }
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
        performSegue(withIdentifier: "showDetail", sender: selectedArticle)
    }
}

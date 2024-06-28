import UIKit

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var bookmarkCollectionView: UICollectionView!
    
    var bookmarks: [CDNewsInfo] = []
//    var coreDataService: CoreDataService!
    var coreDataService = CoreDataService.shared  // Використовуємо єдиний екземпляр

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
        bookmarks = coreDataService.fetchBookmarkedNews()
        bookmarkCollectionView.reloadData()
        print("Loaded \(bookmarks.count) bookmarks")
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
    
   
}

extension BookmarkViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let detailVC = segue.destination as? DetailsViewController,
                  let article = sender as? CDNewsInfo else {
                print("Segue setup failed")
                return
            }
            detailVC.articles = [article]
            detailVC.selectedIndex = 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArticle = bookmarks[indexPath.item]
        performSegue(withIdentifier: "showDetail", sender: selectedArticle)
    }
}


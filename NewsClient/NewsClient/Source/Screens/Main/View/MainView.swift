import UIKit

class MainView: UIView, MainViewProtocol {
    weak var delegate: MainViewDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!

    private var refreshControl: UIRefreshControl!
    private var articles: [DMNewsInfo.Articles] = []
    private var categories: [String] = ["All","General", "Business", "Health","Science", "Sports", "Technology"]
    var coreDataService: CoreDataService!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        categoriesCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self

        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        newsCollectionView.register(UINib(nibName: "NewsCell", bundle: nil), forCellWithReuseIdentifier: "NewsCell")
        
        searchBar.delegate = self
        setupRefreshControl()
    }

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshNews(_:)), for: .valueChanged)
        newsCollectionView.refreshControl = refreshControl
    }

    @objc private func refreshNews(_ sender: Any) {
        delegate?.refreshNews()
    }

    func setupNews(with data: [DMNewsInfo.Articles]) {
        self.articles = data
        newsCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension MainView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == categoriesCollectionView ? categories.count : articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCollectionViewCell else {
                assertionFailure("Failed to dequeue CategoryCollectionViewCell")
                return UICollectionViewCell()
            }
            
            let category = categories[indexPath.item]
            cell.configure(with: category)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as? NewsCollectionViewCell else {
                assertionFailure("Failed to dequeue NewsCollectionViewCell")
                return UICollectionViewCell()
            }
            let article = articles[indexPath.item]
            cell.coreDataService = coreDataService
            cell.configure(with: article, at: indexPath.item, articles: articles)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == newsCollectionView {
            let selectedArticle = articles[indexPath.item]
            delegate?.didSelectArticle(selectedArticle)
        } else {
            let selectedCategory = categories[indexPath.item]
            delegate?.categoryDidChange(to: selectedCategory)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView == categoriesCollectionView ? CGSize(width: 120, height: 50) : CGSize(width: 370, height: 300)
    }
}

extension MainView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        delegate?.searchNews(for: searchText)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {}
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool { return true }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool { return true }
}

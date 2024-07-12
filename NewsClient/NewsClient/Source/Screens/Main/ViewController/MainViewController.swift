import UIKit

class MainViewController: UIViewController {
    var model: MainModelProtocol?
    var contentView: MainViewProtocol!
    var coreDataService = CoreDataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mainView = view as? MainView else {
            fatalError("MainView is not connected properly in the storyboard")
        }
        
        contentView = mainView
        mainView.delegate = self
        mainView.coreDataService = coreDataService
        setupInitialState()
        model?.loadData(forCategory: "all")
        model?.searchNews(for: "")
    }

    private func setupInitialState() {
        let mainModel = MainModel(delegate: self)
        model = mainModel
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let detailVC = segue.destination as? DetailsViewController else {
                print("Segue setup failed: destination is not DetailsViewController")
                return
            }
            
            if let article = sender as? DMNewsInfo.Articles {
                detailVC.articles = [article]
                detailVC.selectedIndex = 0
            } else if let articleTuple = sender as? (articles: [DMNewsInfo.Articles], selectedIndex: Int) {
                detailVC.articles = articleTuple.articles
                detailVC.selectedIndex = articleTuple.selectedIndex
            } else {
                print("Invalid sender type: expected DMNewsInfo.Articles or (articles: [DMNewsInfo.Articles], selectedIndex: Int)")
            }
        }
    }
}

extension MainViewController: MainViewDelegate {
    func categoryDidChange(to category: String) {
        model?.loadData(forCategory: category)
        print("Category did change to: \(category)")
    }
    
    func didSelectArticle(_ article: DMNewsInfo.Articles) {
        performSegue(withIdentifier: "showDetail", sender: article)
    }
    
    func searchNews(for searchIn: String) {
        model?.searchNews(for: searchIn)
    }
    
    func refreshNews() {
        model?.loadData(forCategory: "all")
    }
}

extension MainViewController: MainModelDelegate {
    func dataDidLoad(with data: [DMNewsInfo.Articles]) {
        contentView.setupNews(with: data)
    }
}

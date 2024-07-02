import UIKit

class MainModel {
    weak var delegate: MainModelDelegate?
    
    let networkService: NetworkServiceNews
//    let storageService: CoreDataNews

    init(delegate: MainModelDelegate? = nil) {
        self.delegate = delegate
        self.networkService = ServiceProvider.networkService()
//        self.storageService = ServiceProvider.coreDataService()
    }
}

extension MainModel: MainModelProtocol {

        func loadData(forCategory category: String) {
            DispatchQueue.global(qos: .default).async { [weak self] in
                self?.networkService.loadNews(for: category.lowercased()) { [weak self] newsInfo, error in
                    DispatchQueue.main.async {
                        if let news = newsInfo {
                            self?.delegate?.dataDidLoad(with: news.articles)
                        } else if let error = error {
                            print("Error fetching news data from API: \(error)")
                        }
                    }
                }
            }
        }
    }


import UIKit

class MainModel {
    weak var delegate: MainModelDelegate?
    
    let networkService: NetworkServiceNews
    let storageService: CoreDataNews

    init(delegate: MainModelDelegate? = nil) {
        self.delegate = delegate
        self.networkService = ServiceProvider.networkService()
        self.storageService = ServiceProvider.coreDataService()
    }
}

extension MainModel: MainModelProtocol {
    
    func loadData(forCategory category: String) {
        if let lastUpdateDate = storageService.getLastUpdateDate(), isDataFresh(since: lastUpdateDate) {
            let storedData = storageService.fetchAllNews()
            if !storedData.isEmpty {
                delegate?.dataDidLoad(with: storedData) 
                return
            }
        }
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.networkService.loadNews(for: category.lowercased()) { [weak self] newsInfo, error in
                DispatchQueue.main.async {
                    if let news = newsInfo {
                        self?.storageService.insertNewsInfo(with: news)
                        self?.storageService.saveLastUpdateDate()
                        let fetchedNews = self?.storageService.fetchAllNews() ?? []
                        self?.delegate?.dataDidLoad(with: fetchedNews)
                    } else if let error = error {
                        print("Error fetching news data from API: \(error)")
                    }
                }
            }
        }
    }
    
    private func isDataFresh(since date: Date) -> Bool {
        return Date().timeIntervalSince(date) < 24 * 60 * 60
    }
}

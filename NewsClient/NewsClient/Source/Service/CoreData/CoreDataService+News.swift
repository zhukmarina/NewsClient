import CoreData

protocol CoreDataNews {
    func insertNewsInfo(with info: DMNewsInfo)
    func fetchAllNews() -> [CDNewsInfo]
    func updateBookmarkStatus(for article: CDNewsInfo, isBookmarked: Bool)
    func fetchBookmarkedNews() -> [CDNewsInfo]
    func saveLastUpdateDate()
    func getLastUpdateDate() -> Date? 
}

extension CoreDataService: CoreDataNews {
    
    func insertNewsInfo(with info: DMNewsInfo) {
        for article in info.articles {
            let articlesEntityDescription = NSEntityDescription.entity(forEntityName: "CDNewsInfo", in: context)!
            guard let articlesEntity = NSManagedObject(entity: articlesEntityDescription, insertInto: context) as? CDNewsInfo else {
                assertionFailure("Failed to create CDNewsInfo")
                return
            }

            articlesEntity.title = article.title
            articlesEntity.author = article.author
            articlesEntity.datePub = article.publishedAt
            articlesEntity.bodyInfo = article.description
            articlesEntity.image = article.urlToImage
            articlesEntity.isBookmarked = false // default value for new articles

            print("Inserted article: \(article.title)")
            save(context: context)
        }
    }

    func fetchAllNews() -> [CDNewsInfo] {
        let fetchRequest: NSFetchRequest<CDNewsInfo> = CDNewsInfo.fetchRequest()

        do {
            let fetchedResult = try context.fetch(fetchRequest)
            print("Fetched \(fetchedResult.count) articles")
            return fetchedResult
        } catch {
            print("Failed to fetch news info: \(error)")
            return []
        }
    }

    func updateBookmarkStatus(for article: CDNewsInfo, isBookmarked: Bool) {
        context.performAndWait {
            article.isBookmarked = isBookmarked
            print("Updating article: \(article.title ?? "No Title") to isBookmarked: \(isBookmarked)")
            save(context: context)
        }
    }

    func fetchBookmarkedNews() -> [CDNewsInfo] {
        let fetchRequest: NSFetchRequest<CDNewsInfo> = CDNewsInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isBookmarked == YES")

        do {
            let fetchedResult = try context.fetch(fetchRequest)
            print("Fetched \(fetchedResult.count) bookmarked articles")
            fetchedResult.forEach { article in
                print("Bookmarked Article: \(article.title ?? "No Title")")
            }
            return fetchedResult
        } catch {
            print("Failed to fetch bookmarked news: \(error)")
            return []
        }
    }
    
    func saveLastUpdateDate() {
            let currentDate = Date()
            UserDefaults.standard.set(currentDate, forKey: "lastUpdateDate")
        
   
        }
        
    func getLastUpdateDate() -> Date? {
            return UserDefaults.standard.object(forKey: "lastUpdateDate") as? Date
        
        }
}

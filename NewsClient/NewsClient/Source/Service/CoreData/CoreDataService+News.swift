import CoreData

protocol CoreDataNews {
    func insertBookmark(with article: DMNewsInfo.Articles, completion: @escaping () -> Void)
    func insertBookmark(with article: CDNewsInfo, completion: @escaping () -> Void)
    func fetchBookmarks() -> [CDNewsInfo]
    func isArticleBookmarked(_ article: DMNewsInfo.Articles) -> Bool
    func isArticleBookmarked(_ article: CDNewsInfo) -> Bool
    func deleteBookmark(with article: DMNewsInfo.Articles, completion: @escaping () -> Void)
    func deleteBookmark(with article: CDNewsInfo, completion: @escaping () -> Void)
}

extension CoreDataService: CoreDataNews {
    
    func isArticleBookmarked(_ article: DMNewsInfo.Articles) -> Bool {
        let fetchRequest: NSFetchRequest<CDNewsInfo> = CDNewsInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", article.title)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to fetch bookmark status: \(error)")
            return false
        }
    }
    
    func isArticleBookmarked(_ article: CDNewsInfo) -> Bool {
        let fetchRequest: NSFetchRequest<CDNewsInfo> = CDNewsInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", article.title ?? "")
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to fetch bookmark status: \(error)")
            return false
        }
    }
    
    func insertBookmark(with article: DMNewsInfo.Articles, completion: @escaping () -> Void) {
        let cdArticle = CDNewsInfo(context: context)
        cdArticle.title = article.title
        cdArticle.author = article.author
        cdArticle.sourceName = article.source.name
        cdArticle.datePub = article.publishedAt
        cdArticle.image = article.urlToImage
        cdArticle.url = article.url
        cdArticle.isBookmarked = true
        
        save(context: context)
        DispatchQueue.main.async {
            completion()
        }
    }

    func insertBookmark(with article: CDNewsInfo, completion: @escaping () -> Void) {
        article.isBookmarked = true
        save(context: context)
        DispatchQueue.main.async {
            completion() 
        }
    }
    
    func fetchBookmarks() -> [CDNewsInfo] {
        let fetchRequest: NSFetchRequest<CDNewsInfo> = CDNewsInfo.fetchRequest()
        
        do {
            let fetchedResult = try context.fetch(fetchRequest)
            print("Fetched \(fetchedResult.count) articles")
            return fetchedResult
        } catch {
            print("Failed to fetch bookmarks: \(error)")
            return []
        }
    }
    
    func deleteBookmark(with article: DMNewsInfo.Articles, completion: @escaping () -> Void) {
        context.perform {
            let fetchRequest: NSFetchRequest<CDNewsInfo> = CDNewsInfo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", article.title)
            
            do {
                let bookmarks = try self.context.fetch(fetchRequest)
                for bookmark in bookmarks {
                    self.context.delete(bookmark)
                }
                self.save(context: self.context)
                DispatchQueue.main.async {
                    completion() 
                }
            } catch {
                print("Failed to delete bookmark: \(error)")
            }
        }
    }
    
    func deleteBookmark(with article: CDNewsInfo, completion: @escaping () -> Void) {
        context.perform {
            let fetchRequest: NSFetchRequest<CDNewsInfo> = CDNewsInfo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", article.title ?? "")
            
            do {
                let bookmarks = try self.context.fetch(fetchRequest)
                for bookmark in bookmarks {
                    self.context.delete(bookmark)
                }
                self.save(context: self.context)
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Failed to delete bookmark: \(error)")
            }
        }
    }
}

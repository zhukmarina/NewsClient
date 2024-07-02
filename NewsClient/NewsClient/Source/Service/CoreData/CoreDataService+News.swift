import CoreData

protocol CoreDataNews {
    func insertBookmark(with info: DMNewsInfo.Articles)
    func fetchBookmarks() -> [CDNewsInfo]
    func isArticleBookmarked(_ article: DMNewsInfo.Articles) -> Bool
 
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
    
    func insertBookmark(with article: DMNewsInfo.Articles) {
        let cdArticle = CDNewsInfo(context: context)
        cdArticle.title = article.title
        cdArticle.author = article.author
        cdArticle.sourceName = article.source.name
        cdArticle.datePub = article.publishedAt
        cdArticle.image = article.urlToImage
        cdArticle.url = article.url
        cdArticle.isBookmarked = true
        
        save(context: context)
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
    
    func deleteBookmark(with article: DMNewsInfo.Articles) {
           let fetchRequest: NSFetchRequest<CDNewsInfo> = CDNewsInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", article.title)
           
           do {
               let bookmarks = try context.fetch(fetchRequest)
               for bookmark in bookmarks {
                   context.delete(bookmark)
               }
               save(context: context)
           } catch {
               print("Failed to delete bookmark: \(error)")
           }
       }
        
    }
    


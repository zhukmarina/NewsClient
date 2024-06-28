//
//  bookmarkManager.swift
//  NewsClient
//
//  Created by Marina Zhukova on 20.06.2024.
//

import Foundation
import CoreData

class BookmarkManager {
    
    static let shared = BookmarkManager()
    
    private init() {}
    
    func addToBookmarks(article: CDNewsInfo) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let bookmark = Bookmark(context: context)
        bookmark.title = article.title
        bookmark.author = article.author
        bookmark.datePub = article.datePub
        bookmark.sourceName = article.sourceName
        bookmark.bodyInfo = article.bodyInfo
        bookmark.image = article.image
        
        CoreDataStack.shared.saveContext()
    }
    
    func fetchBookmarks() -> [CDNewsInfo] {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CDNewsInfo> = CDNewsInfo.fetchRequest()
        
        do {
            let bookmarks = try context.fetch(fetchRequest)
            return bookmarks
        } catch {
            print("Failed to fetch bookmarks: \(error)")
            return []
        }
    }
}


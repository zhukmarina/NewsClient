//
//  CDNewsInfo+CoreDataProperties.swift
//  NewsClient
//
//  Created by Marina Zhukova on 28.06.2024.
//
//

import Foundation
import CoreData


extension CDNewsInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDNewsInfo> {
        return NSFetchRequest<CDNewsInfo>(entityName: "CDNewsInfo")
    }

    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var datePub: String?
    @NSManaged public var image: String?
    @NSManaged public var bodyInfo: String?
    @NSManaged public var url: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var isBookmarked: Bool

}

extension CDNewsInfo : Identifiable {

}

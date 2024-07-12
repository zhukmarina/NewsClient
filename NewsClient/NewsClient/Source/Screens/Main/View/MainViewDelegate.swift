//
//  MainViewDelegate.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import Foundation

protocol MainViewDelegate:AnyObject {
    func categoryDidChange(to category: String)
    func dataDidLoad(with news: [DMNewsInfo.Articles])
    func didSelectArticle(_ article: DMNewsInfo.Articles)
    func searchNews(for searchIn: String) 

}

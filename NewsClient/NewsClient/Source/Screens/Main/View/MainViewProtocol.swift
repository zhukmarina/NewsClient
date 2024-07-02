//
//  MainViewProtocol.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func setupNews(with articles: [DMNewsInfo.Articles])
}

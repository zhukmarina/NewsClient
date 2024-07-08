//
//  MainModelProtocol.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import Foundation

protocol MainModelProtocol {
    func loadData(forCategory category: String)
    func searchNews(for searchIn: String)
}

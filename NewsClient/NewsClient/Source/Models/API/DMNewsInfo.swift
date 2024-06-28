//
//  DMNewsInfo.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import Foundation

struct DMNewsInfo: Decodable{
    let totalResults: Int
    let articles:[Articles]
    
    struct Articles: Decodable{
        
        let source: Source
        let author: String?
        let title: String
        let description: String?
        let url: String
        let urlToImage: String?
        let publishedAt: String

        struct Source: Decodable {
                    let id: String?
                    let name: String
                }
    }
}

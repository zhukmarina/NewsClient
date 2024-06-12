//
//  APIConstants.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import Foundation

struct APIConstants {
    static let baseUrl = "https://newsapi.org/"
    static let apiVersion = "v2/"
    static let endpoints = "top-headlines"
    static let appId = "36581591861647669cbbe0099a3d2606"
    
    static func newsUrl() -> String {
        return baseUrl + apiVersion + endpoints
    }
    
}

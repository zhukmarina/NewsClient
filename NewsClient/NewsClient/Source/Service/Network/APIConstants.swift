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
    static let endpointsForSearch = "everything"
    static let appId = "36581591861647669cbbe0099a3d2606"
//    static let appId = "a21ce553cc004d6bbb97a194d6425fa5"
    
    
    static func getNewsUrl() -> String {
        return baseUrl + apiVersion + endpoints
    }
    
    static func searchNewsUrl() -> String {
        return baseUrl + apiVersion + endpointsForSearch
    }

}


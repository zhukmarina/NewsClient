//
//  Network + News.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import Foundation

typealias NewsInfoCompletion = ((DMNewsInfo?, Error?)->())

protocol NetworkServiceNews {
    func loadNews(for category: String, completion:@escaping NewsInfoCompletion)

}
extension NetworkService: NetworkServiceNews {
    
    func loadNews(for category: String, completion: @escaping NewsInfoCompletion) {
        let urlString: String
        
        if category.lowercased() == "all" || category == "" {
            urlString = "\(APIConstants.newsUrl())?country=us&apiKey=\(APIConstants.appId)"
        } else  {
            urlString = "\(APIConstants.newsUrl())?category=\(category)&apiKey=\(APIConstants.appId)"
        }
        
        print("Requesting URL: \(urlString)")
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        request(urlRequest:  urlRequest) { (result: Result<DMNewsInfo,Error>) in
            switch result {
            case .success(let value):
                completion(value, nil)
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

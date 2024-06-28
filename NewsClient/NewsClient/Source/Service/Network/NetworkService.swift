//
//  NetworkService.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import Foundation

class NetworkService{
    
    var configuration: URLSessionConfiguration?
    
    func request <T: Decodable>(urlRequest: URLRequest, completion: @escaping(Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest){
            data, response, error in
            if let error = error{
                completion(.failure(error))
                return
            }
            
            guard let data = data else{
                let error = NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
//                print(data)
            }catch{
                completion(.failure(error))
            }
        }.resume()
    }
}

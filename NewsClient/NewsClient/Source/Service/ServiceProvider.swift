//
//  ServiceProvider.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import Foundation

class ServiceProvider {
    
    static func networkService() -> NetworkServiceProtocol {
        
        let service = NetworkService()
        return service
    }
    
    static func coreDataService() -> CoreDataServiceProtocol {
        let service = CoreDataService.shared
        
        return service
    }
}

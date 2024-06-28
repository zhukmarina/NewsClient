//
//  MainModelDelegate.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import Foundation

protocol MainModelDelegate:AnyObject{
    func dataDidLoad(with data: [CDNewsInfo])

}

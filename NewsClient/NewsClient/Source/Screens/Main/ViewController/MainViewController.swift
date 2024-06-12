//  MainViewController.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    var model: MainModelProtocol?
    var contentView: MainViewProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mainView = view as? MainView else {
            fatalError("MainView is not connected properly in the storyboard")
        }
        contentView = mainView
        mainView.delegate = self
        setupInitialState()
        model?.loadData(forCategory: "")
    }

    private func setupInitialState() {
        let mainModel = MainModel(delegate: self)
        model = mainModel
    }
}

extension MainViewController: MainViewDelegate {
    func categoryDidChange(to category: String) {
        model?.loadData(forCategory: category)
    }
}

extension MainViewController: MainModelDelegate {
    func dataDidLoad(with data: DMNewsInfo) {
        print("Data loaded with \(data.articles.count) articles") 
        contentView.setupNews(with: data.articles)
    }
}



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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let detailVC = segue.destination as? DetailsViewController else {
                print("Segue setup failed: destination is not DetailsViewController")
                return
            }
            
            if let article = sender as? CDNewsInfo {
                detailVC.articles = [article]
                detailVC.selectedIndex = 0
            } else if let articleTuple = sender as? (articles: [CDNewsInfo], selectedIndex: Int) {
                detailVC.articles = articleTuple.articles
                detailVC.selectedIndex = articleTuple.selectedIndex
            } else {
                print("Invalid sender type: expected CDNewsInfo or (articles: [CDNewsInfo], selectedIndex: Int)")
            }
        }
    }
}

extension MainViewController: MainViewDelegate {
 
    func categoryDidChange(to category: String) {
        model?.loadData(forCategory: category)
        print("Category did change to: \(category)")
        
    }
    
    func didSelectArticle(_ article: CDNewsInfo) {
            performSegue(withIdentifier: "showDetail", sender: article)
        }
}

extension MainViewController: MainModelDelegate {
    
    func dataDidLoad(with data: [CDNewsInfo]) {
            contentView.setupNews(with: data)
        }

}



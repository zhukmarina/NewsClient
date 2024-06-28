//  MainView.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import UIKit


class MainView: UIView, MainViewProtocol{
    weak var delegate: MainViewDelegate?
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
  
    
    private var categories: [String] = ["All","General", "Business", "Health","Science", "Sports", "Technology"]
    private var articles: [CDNewsInfo] = []

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        categoriesCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self

        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self

    }
    
    func setupNews(with data: [CDNewsInfo]) {
        self.articles = data
        newsCollectionView.reloadData()
    }
    
}

extension MainView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return categories.count
        } else {
            return articles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
               guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCollectionViewCell else {
                   assertionFailure("Failed to dequeue CategoryCollectionViewCell")
                   return UICollectionViewCell()
               }
          
               let category = categories[indexPath.item]
               cell.configure(with: category)
               return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as? NewsCollectionViewCell else {
                          assertionFailure("Failed to dequeue NewsCollectionViewCell")
                          return UICollectionViewCell()
                      }
                      let article = articles[indexPath.item]
                      cell.configure(with: article)
                      return cell
        }
    }
    
 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     if collectionView == newsCollectionView {
         let selectedArticle = articles[indexPath.item]
         delegate?.didSelectArticle(selectedArticle)
     
     }else{
         let selectedCategory = categories[indexPath.item]
         delegate?.categoryDidChange(to: selectedCategory)
     }
}

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollectionView {
            return CGSize(width: 100, height: 50)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 200)
        }
    }
}

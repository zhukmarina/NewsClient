//  MainView.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import UIKit

class MainView: UIView {
    
    weak var delegate: MainViewDelegate?
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    private var categories: [String] = ["All", "Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]
    private var articles: [DMNewsInfo.Articles] = []
       
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        categoriesCollectionView.setCollectionViewLayout(flowLayout, animated: false)
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        newsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "NewsCell")
    }
        }

        extension MainView: MainViewProtocol {
            func setupNews(with articles: [DMNewsInfo.Articles]) {
                self.articles = articles
                newsCollectionView.reloadData()
            }
        }

   extension MainView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return collectionView == categoriesCollectionView ? categories.count : articles.count
             
       }
       
      
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == categoriesCollectionView {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath)
           
           
           for subview in cell.contentView.subviews {
               subview.removeFromSuperview()
           }
           
           
           let categoryLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height))
           categoryLabel.text = categories[indexPath.item]
           categoryLabel.textAlignment = .center
           categoryLabel.font = UIFont.systemFont(ofSize: 14)
           cell.contentView.addSubview(categoryLabel)
           
           return cell
       } else {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath)
               
               for subview in cell.contentView.subviews {
                   subview.removeFromSuperview()
               }
               
               let article = articles[indexPath.item]
               
               let titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: cell.bounds.width - 20, height: 20))
               titleLabel.text = article.title
               titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
               cell.contentView.addSubview(titleLabel)
               
               let authorLabel = UILabel(frame: CGRect(x: 10, y: 35, width: cell.bounds.width - 20, height: 15))
               authorLabel.text = article.author
               authorLabel.font = UIFont.systemFont(ofSize: 14)
               cell.contentView.addSubview(authorLabel)
               
               let dateLabel = UILabel(frame: CGRect(x: 10, y: 55, width: cell.bounds.width - 20, height: 15))
               dateLabel.text = article.publishedAt
               dateLabel.font = UIFont.systemFont(ofSize: 12)
               cell.contentView.addSubview(dateLabel)
               
               if let urlToImage = article.urlToImage, let url = URL(string: urlToImage) {
                   let imageView = UIImageView(frame: CGRect(x: 10, y: 75, width: cell.bounds.width - 20, height: cell.bounds.height - 85))
                   imageView.contentMode = .scaleAspectFill
                   imageView.clipsToBounds = true
                   imageView.loadImage(from: url)
                   cell.contentView.addSubview(imageView)
               }
               
               return cell
           }
       }

       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           if collectionView == categoriesCollectionView {
               let selectedCategory = categories[indexPath.item].lowercased()
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

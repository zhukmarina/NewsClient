//
//  RoundedView.swift
//  NewsClient
//
//  Created by Marina Zhukova on 08.07.2024.
//



import UIKit

class RoundedView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor
    }
}

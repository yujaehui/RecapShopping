//
//  SearchResultViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    @IBOutlet var resultCountLabel: UILabel!
    @IBOutlet var accuracyButton: UIButton!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var expensiveButton: UIButton!
    @IBOutlet var cheapButton: UIButton!
    @IBOutlet var resultCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        resultCountLabel.text = "12345개의 검색 결과"
        resultCountLabel.textColor = .point
        resultCountLabel.font = .systemFont(ofSize: 14)
        
        designButton(accuracyButton, title: "정확도순")
        designButton(dateButton, title: "날짜순")
        designButton(expensiveButton, title: "가격높은순")
        designButton(cheapButton, title: "가격낮은순")
        
        resultCollectionView.backgroundColor = .background
        
        let xib = UINib(nibName: "SearchResultCollectionViewCell", bundle: nil)
        resultCollectionView.register(xib, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        
        resultCollectionView.dataSource = self
        resultCollectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let cellWidth = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        resultCollectionView.collectionViewLayout = layout
        
        
        
    }
    
    func designButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        if title == "정확도순" {
            button.tintColor = .background
            button.backgroundColor = .text
            button.layer.cornerRadius = 10
        } else {
            button.tintColor = .text
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            button.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        }
    }

}

extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as! SearchResultCollectionViewCell
        cell.productImageView.image = UIImage(systemName: "star")
        cell.brandLabel.text = "brand"
        cell.brandLabel.textColor = .lightGray
        cell.brandLabel.font = .systemFont(ofSize: 14)
        cell.productNameLabel.text = "여기에는 상품명이 들어갈 자리입니다. 상품명 상품명 상품명"
        cell.productNameLabel.textColor = .text
        cell.productNameLabel.font = .boldSystemFont(ofSize: 16)
        cell.productNameLabel.numberOfLines = 2
        cell.priceLabel.text = "12345"
        cell.priceLabel.textColor = .text
        cell.priceLabel.font = .boldSystemFont(ofSize: 18)
        cell.heartButton.setTitle("", for: .normal)
        cell.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        cell.heartButton.tintColor = .background
        cell.heartButton.backgroundColor = .text
        cell.heartButton.layer.cornerRadius = cell.heartButton.frame.width / 2
        cell.heartButton.clipsToBounds = true
        return cell
    }
    
    
}

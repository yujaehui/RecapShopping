//
//  SearchResultCollectionViewCell.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var heartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        productImageView.layer.cornerRadius = 10
        
        brandLabel.textColor = .lightGray
        brandLabel.font = FontStyle.tertiary
        
        productNameLabel.textColor = .text
        productNameLabel.font = FontStyle.secondary
        productNameLabel.numberOfLines = 2
        
        priceLabel.textColor = .text
        priceLabel.font = FontStyle.primary
        
        heartButton.setTitle("", for: .normal)
        heartButton.tintColor = .background
        heartButton.backgroundColor = .text
        heartButton.layer.cornerRadius = heartButton.frame.width / 2
        heartButton.clipsToBounds = true
    }
    
    func configureCell(row: Item) {
        let imageURL = URL(string: row.image)
        productImageView.kf.setImage(with: imageURL)
        brandLabel.text = row.brand
    }
}

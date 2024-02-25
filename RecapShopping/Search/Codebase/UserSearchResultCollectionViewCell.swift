//
//  UserSearchResultCollectionViewCell.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 2/23/24.
//

import UIKit
import SnapKit

class UserSearchResultCollectionViewCell: UICollectionViewCell {
    
    let productImageView = UIImageView()
    let brandLabel = UILabel()
    let productNameLabel = UILabel()
    let priceLabel = UILabel()
    let heartButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        configureHierarchy()
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(productImageView)
        contentView.addSubview(brandLabel)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(heartButton)
    }
    
    func configureView() {
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 10
        
        brandLabel.textColor = .lightGray
        brandLabel.font = FontStyle.tertiary
        
        productNameLabel.textColor = .text
        productNameLabel.font = FontStyle.secondary
        productNameLabel.numberOfLines = 2
        
        priceLabel.textColor = .text
        priceLabel.font = FontStyle.primary
        
        heartButton.tintColor = .background
        heartButton.backgroundColor = .text
        heartButton.clipsToBounds = true
        heartButton.layer.cornerRadius = 20
    }
    
    func configureConstraints() {
        productImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(productImageView.snp.width)
        }
        
        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(20)
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(40)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(20)
        }
        
        heartButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.trailing.equalTo(contentView).inset(8)
            make.bottom.equalTo(productImageView.snp.bottom).inset(8)
        }
        
    }
    
}

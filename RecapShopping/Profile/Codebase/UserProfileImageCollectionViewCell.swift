//
//  UserProfileImageCollectionViewCell.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/29/24.
//

import UIKit

class UserProfileImageCollectionViewCell: UICollectionViewCell {
    
    let profileImageView = ProfileImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureUI()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(profileImageView)
    }
    
    func configureUI() {
//        profileImageView.contentMode = .scaleToFill
//        profileImageView.clipsToBounds = true
    }
    
    func configureConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
}

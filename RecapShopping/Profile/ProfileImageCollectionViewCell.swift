//
//  ProfileImageCollectionViewCell.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

class ProfileImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.contentMode = .scaleToFill
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 4
        profileImageView.clipsToBounds = true
    }

}

//
//  ProfileTableViewCell.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var likeStateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .secondaryLabel
        
        profileImageView.configureProfileImageView()
        
        nicknameLabel.textColor = .text
        nicknameLabel.font = FontStyle.primary
    
        likeStateLabel.textColor = .text
        likeStateLabel.font = FontStyle.secondary
    }
}


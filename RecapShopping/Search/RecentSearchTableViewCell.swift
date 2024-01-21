//
//  RecentSearchTableViewCell.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

class RecentSearchTableViewCell: UITableViewCell {

    @IBOutlet var magnifyingglassImageView: UIImageView!
    @IBOutlet var recentSearchLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .background
        magnifyingglassImageView.image = UIImage(systemName: "magnifyingglass")
        magnifyingglassImageView.tintColor = .text
        recentSearchLabel.textColor = .text
        recentSearchLabel.font = FontStyle.tertiary
        deleteButton.setTitle("", for: .normal)
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .lightGray
    }
}

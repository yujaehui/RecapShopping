//
//  SearchingTableViewCell.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/28/24.
//

import UIKit
import SnapKit

class SearchingTableViewCell: UITableViewCell {
    
    let magnifyingglassImageView = UIImageView()
    let recentSearchLabel = UILabel()
    let deleteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .background
        selectionStyle = .none
        
        contentView.addSubview(magnifyingglassImageView)
        contentView.addSubview(recentSearchLabel)
        contentView.addSubview(deleteButton)
        
        magnifyingglassImageView.image = UIImage(systemName: "magnifyingglass")
        magnifyingglassImageView.tintColor = .text
        
        recentSearchLabel.textColor = .text
        recentSearchLabel.font = FontStyle.tertiary
        
        deleteButton.setTitle("", for: .normal)
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .lightGray
        
        magnifyingglassImageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(16)
            make.leading.equalTo(contentView).inset(16)
            make.width.height.equalTo(25)
        }
        
        recentSearchLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(16)
            make.leading.equalTo(magnifyingglassImageView.snp.trailing).inset(-16)
            make.height.equalTo(25)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(16)
            make.leading.equalTo(recentSearchLabel.snp.trailing).inset(16)
            make.trailing.equalTo(contentView).inset(16)
            make.width.height.equalTo(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

//
//  SettingTableViewCell.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet var settingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .secondaryLabel
        
        settingLabel.textColor = .text
        settingLabel.font = FontStyle.tertiary
    }
}

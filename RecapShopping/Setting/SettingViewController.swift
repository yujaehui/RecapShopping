//
//  SettingViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

enum SettingCellType: Int {
    case profile
    case setting
}

class SettingViewController: UIViewController {
    
    @IBOutlet var settingTableView: UITableView!
    
    var settingList = ["공지사항", "자주 묻는 질문", "1:1 문의", "알림 설정", "회원 탈퇴"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        settingTableView.backgroundColor = .background
        
        let profilexib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        settingTableView.register(profilexib, forCellReuseIdentifier: "ProfileTableViewCell")
        
        let settingxib = UINib(nibName: "SettingTableViewCell", bundle: nil)
        settingTableView.register(settingxib, forCellReuseIdentifier: "SettingTableViewCell")
        
        settingTableView.dataSource = self
        settingTableView.delegate = self
        
        settingTableView.rowHeight = UITableView.automaticDimension
        
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SettingCellType.profile.rawValue {
            return 1
        } else {
            return settingList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SettingCellType.profile.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            cell.backgroundColor = .secondaryLabel
            cell.profileImageView.image = UIImage(named: "profile1")
            cell.profileImageView.configureProfileImageView()
            cell.nicknameLabel.text = "유잭구"
            cell.nicknameLabel.textColor = .text
            cell.nicknameLabel.font = .boldSystemFont(ofSize: 18)
            cell.likeStateLabel.text = "5게의 상품을 좋아하고 있어요!"
            cell.likeStateLabel.textColor = .text
            cell.likeStateLabel.font = .boldSystemFont(ofSize: 16)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
            cell.backgroundColor = .secondaryLabel
            cell.settingLabel.text = settingList[indexPath.row]
            cell.settingLabel.textColor = .text
            cell.settingLabel.font = .systemFont(ofSize: 14)
            return cell
        }
        
    }
    
    
}

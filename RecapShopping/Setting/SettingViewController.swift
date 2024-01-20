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

class SettingViewController: UIViewController, ProfileViewControllerDelegate {
    func willDissmiss() {
        settingTableView.reloadData()
    }
    
    
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
        
        setNavigation()
        
    }
    
    func setNavigation() {
        navigationItem.title = "설정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
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
            cell.selectionStyle = .none
            cell.backgroundColor = .secondaryLabel
            let profileImage = UserDefaultsManager.shared.profileImage
            cell.profileImageView.image = UIImage(named: "profile\(profileImage+1)")
            cell.profileImageView.configureProfileImageView()
            let nickname = UserDefaultsManager.shared.nickname
            cell.nicknameLabel.text = nickname
            cell.nicknameLabel.textColor = .text
            cell.nicknameLabel.font = .boldSystemFont(ofSize: 18)
            cell.likeStateLabel.text = "5게의 상품을 좋아하고 있어요!"
            cell.likeStateLabel.textColor = .text
            cell.likeStateLabel.font = .boldSystemFont(ofSize: 16)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .secondaryLabel
            cell.settingLabel.text = settingList[indexPath.row]
            cell.settingLabel.textColor = .text
            cell.settingLabel.font = .systemFont(ofSize: 14)
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SettingCellType.profile.rawValue {
            let sb = UIStoryboard(name: "Profile", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            vc.accessType = .edit
            vc.tableView = tableView
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == SettingCellType.setting.rawValue && indexPath.row == 4 {
        
            let alert = UIAlertController(title: "회원 탈퇴", message: "이 작업은 되돌릴 수 없습니다.", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            let secessionButton = UIAlertAction(title: "탈퇴", style: .destructive) { alert in
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let sb = UIStoryboard(name: "Onboarding", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
                let nav = UINavigationController(rootViewController: vc)
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            
            
            alert.addAction(cancelButton)
            alert.addAction(secessionButton)
            
            present(alert, animated: true)
        }
    }
    
     
    
    
}

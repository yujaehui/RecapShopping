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
    
    var settingList = ["공지사항", "자주 묻는 질문", "1:1 문의", "알림 설정", "처음부터 시작하기"]
    var count = 0 {
        didSet {
            settingTableView.reloadData()
        }
    }
    var profileImage = 0
    var nickname = ""
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
        configureUI()
        configureTableView()
    }
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        count = UserDefaultsManager.shared.productID?.count ?? 0
        profileImage = UserDefaultsManager.shared.profileImage
        nickname = UserDefaultsManager.shared.nickname
    }
}

// MARK: setNavigation
extension SettingViewController {
    func setNavigation() {
        navigationItem.title = "설정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
    }
}

// MARK: configureUI
extension SettingViewController {
    func configureUI() {
        setViewBackgroundColor()
        settingTableView.setTableViewBackgroundColor()
    }
}

// MARK: configureTableView
extension SettingViewController {
    func configureTableView() {
        let profilexib = UINib(nibName: ProfileTableViewCell.identifier, bundle: nil)
        settingTableView.register(profilexib, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        
        let settingxib = UINib(nibName: SettingTableViewCell.identifier, bundle: nil)
        settingTableView.register(settingxib, forCellReuseIdentifier: SettingTableViewCell.identifier)
        
        settingTableView.dataSource = self
        settingTableView.delegate = self

        settingTableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: tableview
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
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
            cell.profileImageView.image = UIImage(named: "profile\(profileImage)")  
            cell.nicknameLabel.text = nickname
            cell.likeStateLabel.attributedText = textColorChange("\(count)개의 상품을 좋아하고 있어요!")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
            cell.settingLabel.text = settingList[indexPath.row]
            return cell
        }
    }
    
    // 특정 텍스트의 컬러만 변경
    func textColorChange(_ labelText: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: labelText)
        let countRange = (labelText as NSString).range(of: "\(count)개의 상품")
        let countAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.point]
        attributedText.addAttributes(countAttributes, range: countRange)
        return attributedText
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SettingCellType.profile.rawValue {
            let sb = UIStoryboard(name: "Profile", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: ProfileViewController.identifier) as! ProfileViewController
            vc.accessType = .edit
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == SettingCellType.setting.rawValue && indexPath.row == 4 {
            let alert = UIAlertController(title: "처음부터 시작하기", message: "데이터를 모두 초기화하시겠습니까?", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            let secessionButton = UIAlertAction(title: "확인", style: .destructive) { alert in
                // 모든 userDefaults 항목 제거
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
                // 지금까지의 화면은 제거하고 다시 온보딩 화면으로...
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let sb = UIStoryboard(name: "Onboarding", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: OnboardingViewController.identifier) as! OnboardingViewController
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






//
//  UserProfileImageViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/29/24.
//

import UIKit
import SnapKit

class UserProfileImageViewController: UIViewController {
    let profileImageView = ProfileImageView(frame: .zero)
    let profileImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())

    var type: AccessType = .setting
    var userSelect = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        configureHierarchy()
        configureView()
        configureConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaultsManager.shared.profileImage = userSelect
    }
    
    func setNavigation() {
        navigationItem.title = type == .setting ? "프로필 설정" : "프로필 수정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
    }
    
    func configureHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(profileImageCollectionView)
    }
    
    func configureView() {
        setViewBackgroundColor()
        profileImageCollectionView.setCollectionViewBackgroundColor()
        let profileImage = UserDefaultsManager.shared.profileImage
        profileImageView.image = UIImage(named: "profile\(profileImage)")

        profileImageCollectionView.dataSource = self
        profileImageCollectionView.delegate = self
        profileImageCollectionView.register(UserProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: UserProfileImageCollectionViewCell.identifier)
    }
    
    func configureConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(160)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        profileImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension UserProfileImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let cellWidth = UIScreen.main.bounds.width - (spacing * 5)
        layout.itemSize = CGSize(width: cellWidth / 4, height: cellWidth / 4)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileImageCollectionViewCell.identifier, for: indexPath) as! UserProfileImageCollectionViewCell
        cell.profileImageView.image = UIImage(named: "profile\(indexPath.row+1)")
        if userSelect != indexPath.row+1 {
            cell.profileImageView.layer.borderWidth = 0
        } else {
            cell.profileImageView.layer.borderWidth = 4
            cell.profileImageView.layer.borderColor = CGColor(srgbRed: 73/255, green: 220/255, blue: 146/255, alpha: 1)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userSelect = indexPath.row + 1 // userSelect에 해당 이미지 번호를 넣어줌
        profileImageView.image = UIImage(named: "profile\(userSelect)")
        collectionView.reloadData()
    }
}

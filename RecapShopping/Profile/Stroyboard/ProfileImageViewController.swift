//
//  ProfileImageViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

enum AccessType {
    case setting
    case edit
}

class ProfileImageViewController: UIViewController {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileImageCollectionView: UICollectionView!
    
    var type: AccessType = .setting
    var userSelect = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        configureView()
        configureCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaultsManager.shared.profileImage = userSelect
    }
}

// MARK: setNavigation
extension ProfileImageViewController {
    func setNavigation() {
        navigationItem.title = type == .setting ? "프로필 설정" : "프로필 수정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
    }
}

// MARK: configureView
extension ProfileImageViewController {
    func configureView() {
        setViewBackgroundColor()
        profileImageCollectionView.setCollectionViewBackgroundColor()
        let profileImage = UserDefaultsManager.shared.profileImage
        profileImageView.image = UIImage(named: "profile\(profileImage)")
        profileImageView.configureProfileImageView()
    }
}

// MARK: configureCollectionView
extension ProfileImageViewController {
    func configureCollectionView() {
        let xib = UINib(nibName: ProfileImageCollectionViewCell.identifier, bundle: nil)
        profileImageCollectionView.register(xib, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
        
        profileImageCollectionView.dataSource = self
        profileImageCollectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let cellWidth = UIScreen.main.bounds.width - (spacing * 5)
        layout.itemSize = CGSize(width: cellWidth / 4, height: cellWidth / 4)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        profileImageCollectionView.collectionViewLayout = layout
    }
}

// MARK: collectionView
extension ProfileImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as! ProfileImageCollectionViewCell
        cell.profileImageView.image = UIImage(named: "profile\(indexPath.row+1)")
        DispatchQueue.main.async {
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height / 2
        }
        // 내가 고른 이미지와 indexPath.row가 같으면 해당 이미지만 border 효과
        if userSelect == indexPath.row+1 {
            cell.profileImageView.layer.borderWidth = 4
            cell.profileImageView.layer.borderColor = CGColor(srgbRed: 73/255, green: 220/255, blue: 146/255, alpha: 1)
        } else {
            cell.profileImageView.layer.borderWidth = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userSelect = indexPath.row + 1 // userSelect에 해당 이미지 번호를 넣어줌
        profileImageView.image = UIImage(named: "profile\(userSelect)")
        collectionView.reloadData()
    }
}

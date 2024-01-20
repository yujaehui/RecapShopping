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
        
        view.backgroundColor = .background
        
        let profileImage = UserDefaultsManager.shared.profileImage
        profileImageView.image = UIImage(named: "profile\(profileImage+1)")
        profileImageView.configureProfileImageView()
        
        profileImageCollectionView.backgroundColor = .background
        
        let xib = UINib(nibName: "ProfileImageCollectionViewCell", bundle: nil)
        profileImageCollectionView.register(xib, forCellWithReuseIdentifier: "ProfileImageCollectionViewCell")
        
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
        
        setNavigation()
        
        
    }
    
    func setNavigation() {
        navigationItem.title = type == .setting ? "프로필 설정" : "프로필 수정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
        navigationItem.backBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelButtonClicked))
    }
    
    @objc func cancelButtonClicked() {
        UserDefaultsManager.shared.profileImage = userSelect
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCollectionViewCell", for: indexPath) as! ProfileImageCollectionViewCell
        cell.profileImageView.image = UIImage(named: "profile\(indexPath.row+1)")
        cell.profileImageView.contentMode = .scaleToFill
        cell.profileImageView.layer.cornerRadius = profileImageView.bounds.width / 4
        cell.profileImageView.clipsToBounds = true
        
        if userSelect == indexPath.row {
            cell.profileImageView.layer.borderWidth = 4
            cell.profileImageView.layer.borderColor = CGColor(srgbRed: 73/255, green: 220/255, blue: 146/255, alpha: 1)
        } else {
            cell.profileImageView.layer.borderWidth = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        userSelect = indexPath.row
        profileImageView.image = UIImage(named: "profile\(userSelect+1)")
        collectionView.reloadData()
    }
    
    
}


extension UIImageView {
    func configureProfileImageView() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 4
        self.layer.borderColor = CGColor(srgbRed: 73/255, green: 220/255, blue: 146/255, alpha: 1)
    }
}

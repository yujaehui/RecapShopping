//
//  ProfileImageViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

class ProfileImageViewController: UIViewController {
    
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileImageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        profileImageView.image = UIImage(named: "profile1")
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
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

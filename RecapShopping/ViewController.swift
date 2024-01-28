//
//  ViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .point
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.backgroundColor = .background
        self.tabBar.barTintColor = .background
        addVC()
    }

    private func addVC() {
        let searchVC = UINavigationController(rootViewController: SearchingViewController())
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        let settingVC = sb.instantiateViewController(withIdentifier: SettingViewController.identifier) as! SettingViewController
        let settingNAV = UINavigationController(rootViewController: settingVC)
        settingNAV.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape"))
        
        self.viewControllers = [searchVC, settingNAV]
    }


}


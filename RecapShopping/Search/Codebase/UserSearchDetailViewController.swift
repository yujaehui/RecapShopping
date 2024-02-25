//
//  UserSearchDetailViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 2/23/24.
//

import UIKit
import WebKit
import SnapKit

class UserSearchDetailViewController: UIViewController {
    
    var webView = WKWebView()
    
    var id = ""
    var name = ""
    var image = ""
    var IDList = UserDefaultsManager.shared.productID ?? []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigation()
        setTabBar()
        configureHierarchy()
        configureView()
        configureConstraints()
        setViewBackgroundColor()
        
        let link = "https://msearch.shopping.naver.com/product/\(id)"
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func configureHierarchy() {
        view.addSubview(webView)
    }
    
    func configureView() {
    }
    
    func configureConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    @objc func heartButtonClicked(_ sender: UIButton) {
        if IDList.contains(id) {
            IDList.removeAll { $0 == id }
            image = "heart"
        } else {
            IDList.append(id)
            image = "heart.fill"
        }
        UserDefaultsManager.shared.productID = IDList
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: image)
    }
}

// MARK: setNavigaiton
extension UserSearchDetailViewController {
    func setNavigation() {
        navigationItem.title = name
        navigationController?.navigationBar.tintColor = .text
        if IDList.contains(id) {
            image = "heart.fill"
        } else {
            image = "heart"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: image), style: .plain, target: self, action: #selector(heartButtonClicked))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.text]
        appearance.backgroundColor = .background
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
}

// MARK: setTabBar
extension UserSearchDetailViewController {
    func setTabBar() {
        let tapApperance = UITabBarAppearance()
        tapApperance.configureWithOpaqueBackground()
        tapApperance.backgroundColor = .background
        tabBarController?.tabBar.standardAppearance = tapApperance
        tabBarController?.tabBar.scrollEdgeAppearance = tabBarController?.tabBar.standardAppearance
    }
}

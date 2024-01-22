//
//  SearchDetailViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit
import WebKit

class SearchDetailViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var id = ""
    var name = ""
    var image = ""
    var IDList = UserDefaultsManager.shared.productID ?? []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setViewBackgroundColor()
        
        let link = "https://msearch.shopping.naver.com/product/\(id)"
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc func cancelButtonClicked() {
        navigationController?.popViewController(animated: true)
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
extension SearchDetailViewController {
    func setNavigation() {
        navigationItem.title = name
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
        navigationItem.backBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(cancelButtonClicked))
        if IDList.contains(id) {
            image = "heart.fill"
        } else {
            image = "heart"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: image), style: .plain, target: self, action: #selector(heartButtonClicked))
    }
}

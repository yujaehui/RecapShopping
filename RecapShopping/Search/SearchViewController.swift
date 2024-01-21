//
//  SearchViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var recentSearchLabel: UILabel!
    @IBOutlet var deleteAllButton: UIButton!
    @IBOutlet var emptyImageView: UIImageView!
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var recentSearchTableView: UITableView!
    
    var recentSearchList = UserDefaultsManager.shared.searchList ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        view.backgroundColor = .background
        
        
        
        
        searchBar.searchTextField.textColor = .text
        
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = .secondaryLabel
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드, 상품, 프로필, 태그 등", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        
        recentSearchLabel.text = "최근 검색"
        recentSearchLabel.textColor = .text
        recentSearchLabel.font = .systemFont(ofSize: 14)
        
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.titleLabel?.font = .systemFont(ofSize: 14)
        deleteAllButton.tintColor = .point
        
        emptyImageView.image = UIImage(named: "empty")
        
        emptyLabel.text = "최근 검색어가 없습니다"
        emptyLabel.textColor = .text
        emptyLabel.font = .boldSystemFont(ofSize: 18)
        emptyLabel.textAlignment = .center
        
        recentSearchTableView.backgroundColor = .background
        
        let xib = UINib(nibName: "RecentSearchTableViewCell", bundle: nil)
        recentSearchTableView.register(xib, forCellReuseIdentifier: "RecentSearchTableViewCell")
        
        recentSearchTableView.dataSource = self
        recentSearchTableView.delegate = self
        
        setNavigation()
        
        print(recentSearchList)
        if recentSearchList.isEmpty {
            recentSearchLabel.text = ""
            deleteAllButton.isHidden = true
            recentSearchTableView.isHidden = true
        }
        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonClicked), for: .touchUpInside)
        
    }
    
    @objc func deleteAllButtonClicked() {
        recentSearchList.removeAll()
        UserDefaultsManager.shared.searchList = recentSearchList
        recentSearchLabel.text = ""
        deleteAllButton.isHidden = true
        recentSearchTableView.isHidden = true
        recentSearchTableView.reloadData()
    }
    
    func setNavigation() {
        navigationItem.title = "\(UserDefaultsManager.shared.nickname)의 쇼핑"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchTableViewCell", for: indexPath) as! RecentSearchTableViewCell
        cell.backgroundColor = .background
        cell.magnifyingglassImageView.image = UIImage(systemName: "magnifyingglass")
        cell.magnifyingglassImageView.tintColor = .text
        cell.recentSearchLabel.text = recentSearchList[indexPath.row]
        cell.recentSearchLabel.textColor = .text
        cell.recentSearchLabel.font = .systemFont(ofSize: 14)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = recentSearchList[indexPath.row]
        guard let text = searchBar.text else { return }
        recentSearchList.removeAll { $0 == text }
        recentSearchList.insert(text, at: 0)
        UserDefaultsManager.shared.searchList = recentSearchList
        recentSearchTableView.reloadData()
        
        let sb = UIStoryboard(name: "Search", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        vc.searchText = text
        navigationController?.pushViewController(vc, animated: true)
        
        searchBar.text = ""
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        recentSearchList.insert(text, at: 0)
        UserDefaultsManager.shared.searchList = recentSearchList
        recentSearchTableView.reloadData()
        
        let sb = UIStoryboard(name: "Search", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        vc.searchText = text
        navigationController?.pushViewController(vc, animated: true)
        
        searchBar.text = ""
        recentSearchLabel.text = "최근 검색"
        deleteAllButton.isHidden = false
        recentSearchTableView.isHidden = false

    }
}

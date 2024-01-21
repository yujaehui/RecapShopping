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
    
        setNavigation()
        configureUI()
        configureTableView()
        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonClicked), for: .touchUpInside)
        
    }
    
    @objc func deleteButtonClicked(_ sender: UIButton) {
        recentSearchList.remove(at: sender.tag)
        UserDefaultsManager.shared.searchList = recentSearchList
        if recentSearchList.isEmpty {
            recentSearchLabel.text = ""
            deleteAllButton.isHidden = true
            recentSearchTableView.isHidden = true
        }
        recentSearchTableView.reloadData()
    }
    
    @objc func deleteAllButtonClicked() {
        recentSearchList.removeAll()
        UserDefaultsManager.shared.searchList = recentSearchList
        recentSearchLabel.text = ""
        deleteAllButton.isHidden = true
        recentSearchTableView.isHidden = true
        recentSearchTableView.reloadData()
    }
}

extension SearchViewController {
    func setNavigation() {
        navigationItem.title = "\(UserDefaultsManager.shared.nickname)의 쇼핑"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
    }
}

extension SearchViewController {
    func configureUI() {
        view.backgroundColor = .background
        recentSearchTableView.backgroundColor = .background
        
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .text
        searchBar.searchTextField.backgroundColor = .secondaryLabel
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드, 상품, 프로필, 태그 등", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        
        recentSearchLabel.text = "최근 검색"
        recentSearchLabel.textColor = .text
        recentSearchLabel.font = FontStyle.tertiary
        
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.tintColor = .point
        deleteAllButton.titleLabel?.font = FontStyle.tertiary
        
        emptyImageView.image = UIImage(named: "empty")
        
        emptyLabel.text = "최근 검색어가 없습니다"
        emptyLabel.textColor = .text
        emptyLabel.font = FontStyle.primary
        emptyLabel.textAlignment = .center
        
        if recentSearchList.isEmpty {
            recentSearchLabel.text = ""
            deleteAllButton.isHidden = true
            recentSearchTableView.isHidden = true
        }
    }
}

extension SearchViewController {
    func configureTableView() {
        let xib = UINib(nibName: RecentSearchTableViewCell.identifier, bundle: nil)
        recentSearchTableView.register(xib, forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
        
        recentSearchTableView.dataSource = self
        recentSearchTableView.delegate = self
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier, for: indexPath) as! RecentSearchTableViewCell
        cell.recentSearchLabel.text = recentSearchList[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
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
        let vc = sb.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as! SearchResultViewController
        vc.searchText = text
        navigationController?.pushViewController(vc, animated: true)
        
        searchBar.text = ""
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        recentSearchList.removeAll { $0 == text }
        recentSearchList.insert(text, at: 0)
        UserDefaultsManager.shared.searchList = recentSearchList
        recentSearchTableView.reloadData()
        
        let sb = UIStoryboard(name: "Search", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as! SearchResultViewController
        vc.searchText = text
        navigationController?.pushViewController(vc, animated: true)
        
        searchBar.text = ""
        recentSearchLabel.text = "최근 검색"
        deleteAllButton.isHidden = false
        recentSearchTableView.isHidden = false

    }
}





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
    @IBOutlet var recentSearchTableView: UITableView!
    
    var recentSearchList: [String] = ["맥북", "지갑", "향수"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        searchBar.searchTextField.textColor = .text
        searchBar.barTintColor = .background
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        
        recentSearchLabel.text = "최근 검색"
        recentSearchLabel.textColor = .text
        recentSearchLabel.font = .systemFont(ofSize: 14)
        
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.titleLabel?.font = .systemFont(ofSize: 14)
        deleteAllButton.tintColor = .point
        
        emptyImageView.image = UIImage(named: "empty")
        
        recentSearchTableView.backgroundColor = .background
        
        let xib = UINib(nibName: "RecentSearchTableViewCell", bundle: nil)
        recentSearchTableView.register(xib, forCellReuseIdentifier: "RecentSearchTableViewCell")
        
        recentSearchTableView.dataSource = self
        recentSearchTableView.delegate = self
        
        
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
    
    
}

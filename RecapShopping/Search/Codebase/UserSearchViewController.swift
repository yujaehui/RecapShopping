//
//  UserSearchViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/28/24.
//

import UIKit
import SnapKit

class UserSearchViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let recentSearchLabel = UILabel()
    let deleteAllButton = UIButton()
    let emptyImageView = UIImageView()
    let emptyLabel = UILabel()
    let recentSearchTableView = UITableView()
    
    var recentSearchList = UserDefaultsManager.shared.searchList ?? []
    var nickname: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureView()
        configureConstraints()
                
        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nickname = UserDefaultsManager.shared.nickname
        setNavigation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setNavigation() {
        navigationItem.title = "\(nickname)의 새싹쇼핑"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
        navigationItem.backButtonTitle = ""
    }
    
    func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(recentSearchLabel)
        view.addSubview(deleteAllButton)
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        view.addSubview(recentSearchTableView)
    }
    
    func configureView() {
        setViewBackgroundColor()
        recentSearchTableView.setTableViewBackgroundColor()
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .text
        searchBar.searchTextField.backgroundColor = .secondaryLabel
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드, 상품, 프로필, 태그 등", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        
        recentSearchLabel.textColor = .text
        recentSearchLabel.font = FontStyle.tertiary
        
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.setTitleColor(.point, for: .normal)
        deleteAllButton.titleLabel?.font = FontStyle.tertiary
        
        emptyImageView.image = UIImage(named: "empty")
        emptyImageView.contentMode = .scaleAspectFit
        
        emptyLabel.text = "최근 검색어가 없어요"
        emptyLabel.textColor = .text
        emptyLabel.font = FontStyle.primary
        emptyLabel.textAlignment = .center
        
        recentSearchTableView.dataSource = self
        recentSearchTableView.delegate = self
        recentSearchTableView.register(UserRecentSearchTableViewCell.self, forCellReuseIdentifier: UserRecentSearchTableViewCell.identifier)
        
       recentSearchListIsEmpty()
    }
    
    func configureConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        recentSearchLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).inset(-16)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        deleteAllButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).inset(-16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(emptyImageView.snp.width)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).inset(8)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        recentSearchTableView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchLabel.snp.bottom).inset(-16)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func deleteButtonClicked(_ sender: UIButton) {
        recentSearchList.remove(at: sender.tag)
        UserDefaultsManager.shared.searchList = recentSearchList
        recentSearchListIsEmpty()
        recentSearchTableView.reloadData()
    }
    
    @objc func deleteAllButtonClicked() {
        recentSearchList.removeAll()
        UserDefaultsManager.shared.searchList = recentSearchList
        recentSearchListIsEmpty()
        recentSearchTableView.reloadData()
    }
}

extension UserSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        search(text: text)
    }
    
    func recentSearchListIsEmpty() {
        if recentSearchList.isEmpty {
            recentSearchLabel.text = ""
            deleteAllButton.isHidden = true
            recentSearchTableView.isHidden = true
        } else {
            recentSearchLabel.text = "최근 검색"
            deleteAllButton.isHidden = false
            recentSearchTableView.isHidden = false
        }
    }
    
    func search(text: String) {
        recentSearchList.removeAll { $0 == text }
        recentSearchList.insert(text, at: 0)
        if recentSearchList.count > 7 {
            recentSearchList.removeLast()
        }
        UserDefaultsManager.shared.searchList = recentSearchList
        recentSearchTableView.reloadData()

        let vc = UserSearchResultViewController()
        vc.searchText = text
        navigationController?.pushViewController(vc, animated: true)
        
        searchBar.text = ""
        recentSearchListIsEmpty()
    }
}

extension UserSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserRecentSearchTableViewCell.identifier, for: indexPath) as! UserRecentSearchTableViewCell
        cell.recentSearchLabel.text = recentSearchList[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = recentSearchList[indexPath.row]
        guard let text = searchBar.text, !text.isEmpty else { return }
        search(text: text)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}



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
    
    var viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        
        configureHierarchy()
        configureView()
        configureConstraints()
        
        recentSearchListIsEmpty()
                
        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.nickname.value = UserDefaultsManager.shared.nickname
        // 이 방법 말고 없으려나... 있겠지...
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setNavigation() {
        navigationItem.title = "\(viewModel.nickname.value)의 새싹쇼핑"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
        navigationItem.backButtonTitle = ""
    }
    
    func bindData() {
        viewModel.recentSearchList.bind { _ in
            self.recentSearchTableView.reloadData()
        }
        
        viewModel.nickname.bind { _ in
            self.setNavigation()
        }
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
        viewModel.inputDeleteIndex.value = sender.tag
        recentSearchListIsEmpty()
    }
    
    @objc func deleteAllButtonClicked() {
        viewModel.inputDeletAllButtonClicked.value = ()
        recentSearchListIsEmpty()
    }
    
    // 이 함수는 뷰컨에 있는게 맞으려나...
    func recentSearchListIsEmpty() {
        if viewModel.recentSearchList.value.isEmpty {
            recentSearchLabel.text = ""
            deleteAllButton.isHidden = true
            recentSearchTableView.isHidden = true
        } else {
            recentSearchLabel.text = "최근 검색"
            deleteAllButton.isHidden = false
            recentSearchTableView.isHidden = false
        }
    }
}

extension UserSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearchText.value = searchBar.text

        // 이 아래 코드는 어케하는 게 좋으려나...
        guard let text = searchBar.text, !text.isEmpty else { return }
        let vc = UserSearchResultViewController()
        vc.searchText = text
        navigationController?.pushViewController(vc, animated: true)
        
        searchBar.text = ""
        recentSearchListIsEmpty()
    }
}

extension UserSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recentSearchList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserRecentSearchTableViewCell.identifier, for: indexPath) as! UserRecentSearchTableViewCell
        cell.recentSearchLabel.text = viewModel.recentSearchList.value[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = viewModel.recentSearchList.value[indexPath.row]
        viewModel.inputSearchText.value = searchBar.text

        // 이 아래 코드는 어케하는 게 좋으려나...
        guard let text = searchBar.text, !text.isEmpty else { return }
        let vc = UserSearchResultViewController()
        vc.searchText = text
        navigationController?.pushViewController(vc, animated: true)
        
        searchBar.text = ""
        recentSearchListIsEmpty()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

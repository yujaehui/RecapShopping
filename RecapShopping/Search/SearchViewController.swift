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
    var nickname: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
        configureTableView()
        notification()
        
        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nickname = UserDefaultsManager.shared.nickname
        setNavigation() // navigaiton의 title이 바뀌어야 해서 viewWillAppear에...
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }

    
    @objc func deleteButtonClicked(_ sender: UIButton) {
        recentSearchList.remove(at: sender.tag) // 해당 항목 삭제
        UserDefaultsManager.shared.searchList = recentSearchList
        recentSearchListIsEmpty()
        recentSearchTableView.reloadData()
    }
    
    @objc func deleteAllButtonClicked() {
        recentSearchList.removeAll() // 전체 항목 삭제
        UserDefaultsManager.shared.searchList = recentSearchList
        recentSearchListIsEmpty()
        recentSearchTableView.reloadData()
    }
}

// MARK: setNavigation
extension SearchViewController {
    func setNavigation() {
        navigationItem.title = "\(nickname)의 새싹쇼핑"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
    }
}

// MARK: configureUI
extension SearchViewController {
    func configureUI() {
        setViewBackgroundColor()
        recentSearchTableView.setTableViewBackgroundColor()
        
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .text
        searchBar.searchTextField.backgroundColor = .secondaryLabel
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드, 상품, 프로필, 태그 등", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        
        recentSearchLabel.textColor = .text
        recentSearchLabel.font = FontStyle.tertiary
        
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.tintColor = .point
        deleteAllButton.titleLabel?.font = FontStyle.tertiary
        
        emptyImageView.image = UIImage(named: "empty")
        
        emptyLabel.text = "최근 검색어가 없어요"
        emptyLabel.textColor = .text
        emptyLabel.font = FontStyle.primary
        emptyLabel.textAlignment = .center
        
       recentSearchListIsEmpty()
    }
}

// MARK: configureTableView
extension SearchViewController {
    func configureTableView() {
        let xib = UINib(nibName: RecentSearchTableViewCell.identifier, bundle: nil)
        recentSearchTableView.register(xib, forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
        
        recentSearchTableView.dataSource = self
        recentSearchTableView.delegate = self
    }
}

// MARK: tableView
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
        guard let text = searchBar.text, !text.isEmpty else { return }
        search(text: text)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        }
}

// MARK: SearchBar
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        search(text: text)
    }
}

extension SearchViewController {
    // 최근 검색어 목록이 비었을 때 처리
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
    
    // 1. 최근 검색어 목록에 추가
    // 2. 해당 검색어 화면을 보여주는 화면으로 이동
    func search(text: String) {
        recentSearchList.removeAll { $0 == text } // 최근 검색어 목록에 해당 검색어와 같은 게 있는지 확인, 있다면 제거
        recentSearchList.insert(text, at: 0) // 이후 해당 검색어를 최근 검색어 목록 첫번째 항목에 추가
        if recentSearchList.count > 7 { // 최근 검색어 목록의 총 항목 수가 7개를 넘으면 가장 오래된 항목 제거
            recentSearchList.removeLast()
        }
        UserDefaultsManager.shared.searchList = recentSearchList // 이후 최근 검색어 목록을 저장소에 저장
        recentSearchTableView.reloadData() // 테이블뷰 다시 그리기
        
        let sb = UIStoryboard(name: "Search", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as! SearchResultViewController
        vc.searchText = text
        navigationController?.pushViewController(vc, animated: true)
        
        searchBar.text = "" // 상품들을 보고 돌아왔을 때 검색창에도 검색어가 남아있는 것이 별로임
        recentSearchListIsEmpty()
        // 만약 검색 이전에 최근 검색어가 하나도 없었다면 최근 검색어 목록 테이블뷰가 보이지 않을 것임
        // 그래서 다시 검색을 했을 때 최근 검색어 목록 테이블뷰를 보여줘야 함
    }
    
    // 알림 설정 관련
    func notification() {
        let content = UNMutableNotificationContent()
        content.title = "지금 쇼핑 어때요?"
        content.body = "당신이 원하는 그 상품이 할인 중일지도 몰라요🤫"
        // let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // 시간에 따라
        var component = DateComponents()
        component.hour = 3 // 3시간에 1번씩 ㅎㅎ
        let calenderTrigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false) // 날짜에 따라
        let request = UNNotificationRequest(identifier: "\(Date())", content: content, trigger: calenderTrigger)
        UNUserNotificationCenter.current().add(request)
    }
}



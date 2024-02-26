//
//  SearchViewModel.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 2/26/24.
//

import Foundation

struct SearchViewModel {
    var inputDeleteIndex = Observable(0)
    var inputDeletAllButtonClicked: Observable<Void?> = Observable(nil)
    var inputSearchText: Observable<String?> = Observable(nil)
    
    var recentSearchList = Observable(UserDefaultsManager.shared.searchList ?? [])
    var nickname = Observable(UserDefaultsManager.shared.nickname)
    
    init() {
        inputDeleteIndex.bind { [self] value in
            deleteRecentSearch(inputIndex: value)
        }
        
        inputDeletAllButtonClicked.bind { [self] _ in
            deleteAllRecentSearch()
        }
        
        inputSearchText.bind { [self] value in
            searchBarSearchButtonClicked(inputText: value)
        }
    }
    
    func deleteRecentSearch(inputIndex: Int) {
        if recentSearchList.value.count > 0 {
            recentSearchList.value.remove(at: inputIndex)
            UserDefaultsManager.shared.searchList = recentSearchList.value
        }
    }
    
    func deleteAllRecentSearch() {
        recentSearchList.value.removeAll()
        UserDefaultsManager.shared.searchList = recentSearchList.value
    }
    
    func searchBarSearchButtonClicked(inputText: String?) {
        guard let text = inputText, !text.isEmpty else { return }
        recentSearchList.value.removeAll { $0 == text }
        recentSearchList.value.insert(text, at: 0)
        if recentSearchList.value.count > 7 {
            recentSearchList.value.removeLast()
        }
        UserDefaultsManager.shared.searchList = recentSearchList.value
        
//        let vc = UserSearchResultViewController()
//        vc.searchText = text
//        navigationController?.pushViewController(vc, animated: true)
//        
//        searchBar.text = ""
    }
}

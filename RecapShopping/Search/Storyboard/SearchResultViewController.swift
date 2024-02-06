//
//  SearchResultViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit
import Alamofire
import Kingfisher

enum Sort: String {
    case sim
    case date
    case dsc
    case asc
}

class SearchResultViewController: UIViewController {
    
    @IBOutlet var resultCountLabel: UILabel!
    @IBOutlet var accuracyButton: UIButton!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var expensiveButton: UIButton!
    @IBOutlet var cheapButton: UIButton!
    @IBOutlet var resultCollectionView: UICollectionView!
    @IBOutlet var emptyLabel: UILabel!
    
    var searchText = "" // 값 전달 받을 공간
    var shoppingList = Shopping()
    var total = 0
    var start = 1
    
    var sort: Sort = .sim {
        didSet {
            resultCollectionView.reloadData()
        }
    }
    var IDList = UserDefaultsManager.shared.productID ?? [] {
        didSet {
            resultCollectionView.reloadData()
        }
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        configureUI()
        configureCollectionView()
        callRequest()
        
        accuracyButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        expensiveButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        cheapButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        
    }
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IDList = UserDefaultsManager.shared.productID ?? []
    }
    
    @objc func sortButtonClicked(_ sender: UIButton) {
        designButton(accuracyButton, title: "정확도순")
        designButton(dateButton, title: "날짜순")
        designButton(expensiveButton, title: "가격높은순")
        designButton(cheapButton, title: "가격낮은순")
        designSelectButton(sender)
        
        switch sender {
        case accuracyButton:
            sort = .sim
        case dateButton:
            sort = .date
        case expensiveButton:
            sort = .dsc
        case cheapButton:
            sort = .asc
        default:
            break
        }
        
        start = 1
        callRequest()
    }
    
    @objc func heartButtonClicked(_ sender: UIButton) {
        if IDList.contains(shoppingList.items[sender.tag].productID) { // IDList가 sender의 productID를 가지고 있다면
            IDList.removeAll { $0 == shoppingList.items[sender.tag].productID } // 해당 productID를 IDList에서 제거
        } else {
            IDList.append(shoppingList.items[sender.tag].productID) // 그게 아니라면 productID를 IDList에 추가
        }
        UserDefaultsManager.shared.productID = IDList //이후 IDList를 저장소에 저장
        resultCollectionView.reloadData()
    }
}

// MARK: setNavigation
extension SearchResultViewController {
    func setNavigation() {
        navigationItem.title = searchText // 전달받은 값을 네비게이션 타이틀로 설정
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
        navigationItem.backButtonTitle = ""
    }
}

// MARK: configureUI
extension SearchResultViewController {
    func configureUI() {
        setViewBackgroundColor()
        resultCollectionView.setCollectionViewBackgroundColor()
        
        resultCountLabel.textColor = .point
        resultCountLabel.font = FontStyle.tertiary
        
        designButton(accuracyButton, title: "정확도순")
        designButton(dateButton, title: "날짜순")
        designButton(expensiveButton, title: "가격높은순")
        designButton(cheapButton, title: "가격낮은순")
        designSelectButton(accuracyButton)
        
        emptyLabel.text = "상품을 찾을 수 없어요"
        emptyLabel.textColor = .text
        emptyLabel.textAlignment = .center
        emptyLabel.font = FontStyle.primary
    }
    
    func designButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.tintColor = .text
        button.backgroundColor = .background
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
    }
    
    func designSelectButton(_ button: UIButton) { // 버튼이 눌렸을 경우 디자인 변경
        button.tintColor = .background
        button.backgroundColor = .text
        button.layer.cornerRadius = 10
    }
}

// MARK: configureCollectionView
extension SearchResultViewController {
    func configureCollectionView() {
        let xib = UINib(nibName: SearchResultCollectionViewCell.identifier, bundle: nil)
        resultCollectionView.register(xib, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        
        resultCollectionView.dataSource = self
        resultCollectionView.delegate = self
        resultCollectionView.prefetchDataSource = self
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let cellWidth = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 2 + 120)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        resultCollectionView.collectionViewLayout = layout
    }
}

// MARK: collectionView - DataSource, Delegate
extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingList.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        let row = shoppingList.items[indexPath.row]
        let imageURL = URL(string: row.image)
        cell.productImageView.kf.setImage(with: imageURL)
        cell.brandLabel.text = row.brand
        cell.productNameLabel.text = removeHTMLTags(from: row.title)
        cell.priceLabel.text = formatCurrency(row.lprice)
        if IDList.contains(row.productID) { // productID가 IDList 안에 있다면
            cell.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) // 채워진 하트로 표시
        } else { // 아니라면
            cell.heartButton.setImage(UIImage(systemName: "heart"), for: .normal) // 비워진 하트로 표시
        }
        cell.heartButton.tag = indexPath.row
        cell.heartButton.addTarget(self, action: #selector(heartButtonClicked), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Search", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchDetailViewController.identifier) as! SearchDetailViewController
        vc.id = shoppingList.items[indexPath.row].productID
        vc.name = removeHTMLTags(from: shoppingList.items[indexPath.row].title)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // HTML 제거
    func removeHTMLTags(from string: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: "<[^>]+>", options: [])
            let range = NSRange(location: 0, length: string.utf16.count)
            let withoutHTML = regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "")
            return withoutHTML
        } catch {
            print("Error removing HTML tags: \(error.localizedDescription)")
            return string
        }
    }
    
    // String -> Number
    func formatCurrency(_ amountString: String) -> String? {
        guard let amount = Int(amountString) else {
            return nil
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        if let formattedAmount = formatter.string(from: NSNumber(value: amount)) {
            return formattedAmount
        } else {
            return "\(amount)"
        }
    }
}


// MARK: collectionView - DataSourcePrefetching
extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if shoppingList.items.count - 3 == item.row && total != item.row {
                start += 20
                if start < total {
                    callRequest()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("cancel prefetch \(indexPaths)")
    }
}

// MARK: callRequest
extension SearchResultViewController {
    func callRequest() {
        
        SearchSessionManager.request(request: ShoppingAPI.search(query: searchText, start: start, sort: sort.rawValue).endpoint) { (shopping: Shopping?, error: ErrorType?) in
            if error == nil {
                guard let shopping = shopping else { return }
                self.total = shopping.total
                
                if self.total == 0 {
                    self.showEmptyState()
                } else if self.start == 1 {
                    self.shoppingList = shopping
                } else {
                    self.shoppingList.items.append(contentsOf: shopping.items)
                }
                
                self.resultCountLabel.text = "\(self.formatQuantity(self.total))개의 검색 결과"
                
                self.resultCollectionView.reloadData()
                
                if self.start == 1 && self.total > 0 {
                    self.resultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
            }
        }
        
        //        SearchSessionManager.searchRequest(query: searchText, start: start, sort: sort.rawValue) { shopping, error in
        //            if error == nil {
        //                guard let shopping = shopping else { return }
        //                self.total = shopping.total
        //
        //                if self.total == 0 {
        //                    self.showEmptyState()
        //                } else if self.start == 1 {
        //                    self.shoppingList = shopping
        //                } else {
        //                    self.shoppingList.items.append(contentsOf: shopping.items)
        //                }
        //
        //                self.resultCountLabel.text = "\(self.formatQuantity(self.total))개의 검색 결과"
        //
        //                self.resultCollectionView.reloadData()
        //
        //                if self.start == 1 && self.total > 0 {
        //                    self.resultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        //                }
        //            }
        //        }
    }
    
    // 검색 결과가 없을 때의 UI 처리
    func showEmptyState() {
        resultCountLabel.isHidden = true
        resultCollectionView.isHidden = true
        accuracyButton.isHidden = true
        dateButton.isHidden = true
        expensiveButton.isHidden = true
        cheapButton.isHidden = true
        emptyLabel.isHidden = false
    }
    
    // Int -> Number
    func formatQuantity(_ count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        
        if let formattedCount = formatter.string(from: NSNumber(value: count)) {
            return formattedCount
        } else {
            return "\(count)"
        }
    }
}




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
    case sim = "정확도순"
    case date = "날짜순"
    case asc = "가격높은순"
    case dsc = "가격낮은순"
}

class SearchResultViewController: UIViewController {
    
    @IBOutlet var resultCountLabel: UILabel!
    @IBOutlet var accuracyButton: UIButton!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var expensiveButton: UIButton!
    @IBOutlet var cheapButton: UIButton!
    
    @IBOutlet var resultCollectionView: UICollectionView!
    
    var searchText = ""
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        resultCollectionView.backgroundColor = .background

        resultCountLabel.textColor = .point
        resultCountLabel.font = FontStyle.tertiary
        
        designButton(accuracyButton, title: "정확도순")
        designButton(dateButton, title: "날짜순")
        designButton(expensiveButton, title: "가격높은순")
        designButton(cheapButton, title: "가격낮은순")
        selectButton(accuracyButton)

        callRequest()
        configureCollectionView()
        setNavigation()
        
        accuracyButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        expensiveButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        cheapButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IDList = UserDefaultsManager.shared.productID ?? []
    }
    
    @objc func cancelButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func sortButtonClicked(_ sender: UIButton) {
        designButton(accuracyButton, title: Sort.sim.rawValue)
        designButton(dateButton, title: Sort.date.rawValue)
        designButton(expensiveButton, title: Sort.asc.rawValue)
        designButton(cheapButton, title: Sort.dsc.rawValue)
        selectButton(sender)
        
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
        if IDList.contains(shoppingList.items[sender.tag].productID) {
            IDList.removeAll { id in
                id == shoppingList.items[sender.tag].productID
            }
        } else {
            IDList.append(shoppingList.items[sender.tag].productID)
        }
        UserDefaultsManager.shared.productID = IDList
        resultCollectionView.reloadData()
    }
    
    func formatCurrency(_ amountString: String) -> String? {
        guard let amount = Int(amountString) else {
            return nil // 유효한 정수로 변환할 수 없는 경우 nil 반환
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current // 현재 지역에 따른 통화 포맷을 사용합니다.

        // 정수를 NSNumber로 변환한 후 통화 포맷으로 문자열을 생성합니다.
        if let formattedAmount = formatter.string(from: NSNumber(value: amount)) {
            return formattedAmount
        } else {
            return "\(amount)"
        }
    }
    
    func formatQuantity(_ count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current // 현재 지역에 따른 포맷을 사용합니다.

        // 정수를 NSNumber로 변환한 후 천 단위로 구분된 문자열로 생성합니다.
        if let formattedCount = formatter.string(from: NSNumber(value: count)) {
            return formattedCount
        } else {
            return "\(count)"
        }
    }
}

extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingList.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        let row = shoppingList.items[indexPath.row]
        cell.configureCell(row: row)
        cell.productNameLabel.text = removeHTMLTags(from: row.title)
        cell.priceLabel.text = formatCurrency(row.lprice)
        if IDList.contains(shoppingList.items[indexPath.row].productID) {
            cell.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
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
}

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

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if shoppingList.items.count - 3 == item.row && total != item.row {
                start += 20
                callRequest()
            }
        }
    }
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("cancel prefetch \(indexPaths)")
    }
}

extension SearchResultViewController {
    func setNavigation() {
        navigationItem.title = searchText
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
        navigationItem.backBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(cancelButtonClicked))
    }
}

extension SearchResultViewController {
    func designButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.tintColor = .text
        button.backgroundColor = .background
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
    }
    
    func selectButton(_ button: UIButton) {
        button.tintColor = .background
        button.backgroundColor = .text
        button.layer.cornerRadius = 10
    }
}

extension SearchResultViewController {
    func callRequest() {
        let query = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=20&start=\(start)&sort=\(sort)"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            switch response.result {
            case .success(let success):
                if self.start == 1 {
                    self.shoppingList = success
                } else {
                    self.shoppingList.items.append(contentsOf: success.items)
                }
                
                self.total = success.total
                //self.resultCountLabel.text = "\(self.total)개의 검색 결과"
                self.resultCountLabel.text = "\(self.formatQuantity(self.total))개의 검색 결과"
                
                self.resultCollectionView.reloadData()
                
                if self.start == 1 {
                    self.resultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
                
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

extension SearchResultViewController {
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
}




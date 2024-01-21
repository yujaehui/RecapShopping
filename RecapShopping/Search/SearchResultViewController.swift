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
    case asc
    case dsc
}

class SearchResultViewController: UIViewController {
    
    @IBOutlet var resultCountLabel: UILabel!
    @IBOutlet var accuracyButton: UIButton!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var expensiveButton: UIButton!
    @IBOutlet var cheapButton: UIButton!
    @IBOutlet var resultCollectionView: UICollectionView!
    
    var searchText = ""
    var start = 1
    var shoppingList = Shopping(lastBuildDate: "", total: 0, start: 0, display: 0, items: [])
    var totalCount = 0
    var sort: String = "sim" {
        didSet {
            resultCollectionView.reloadData()
        }
    }
    var IDList = UserDefaultsManager.shared.productID ?? [] {
        didSet {
            resultCollectionView.reloadData()
        }
    }
    var id = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        resultCountLabel.text = "12345개의 검색 결과"
        resultCountLabel.textColor = .point
        resultCountLabel.font = .systemFont(ofSize: 14)
        
        designButton(accuracyButton, title: "정확도순")
        designButton(dateButton, title: "날짜순")
        designButton(expensiveButton, title: "가격높은순")
        designButton(cheapButton, title: "가격낮은순")
        
        resultCollectionView.backgroundColor = .background
        
        let xib = UINib(nibName: "SearchResultCollectionViewCell", bundle: nil)
        resultCollectionView.register(xib, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        
        resultCollectionView.dataSource = self
        resultCollectionView.delegate = self
        resultCollectionView.prefetchDataSource = self
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let cellWidth = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        resultCollectionView.collectionViewLayout = layout
        
        callRequest()
        setNavigation()
        
        accuracyButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        expensiveButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        cheapButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        selectButton(accuracyButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IDList = UserDefaultsManager.shared.productID ?? []
    }
    
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
    
    @objc func heartButtonClicked(_ sender: UIButton) {
        print(shoppingList.items[sender.tag].productID)
        
        if IDList.contains(shoppingList.items[sender.tag].productID) {
            IDList.removeAll { id in
                id == shoppingList.items[sender.tag].productID
            }
        } else {
            IDList.append(shoppingList.items[sender.tag].productID)
        }
        print(IDList)
        UserDefaultsManager.shared.productID = IDList
        resultCollectionView.reloadData()
        
        //delegate?.willDissmiss()
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        
        
        designButton(accuracyButton, title: "정확도순")
        designButton(dateButton, title: "날짜순")
        designButton(expensiveButton, title: "가격높은순")
        designButton(cheapButton, title: "가격낮은순")
        selectButton(sender)
        
        switch sender {
        case accuracyButton:
            sort = Sort.sim.rawValue
        case dateButton:
            sort = Sort.date.rawValue
        case expensiveButton:
            sort = Sort.dsc.rawValue
        case cheapButton:
            sort = Sort.asc.rawValue
        default:
            break
        }
        callRequest()
    }
    
    func selectButton(_ button: UIButton) {
        button.tintColor = .background
        button.backgroundColor = .text
        button.layer.cornerRadius = 10
        
    }
    
    func setNavigation() {
        navigationItem.title = searchText
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
        navigationItem.backBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelButtonClicked))
    }
    
    @objc func cancelButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func callRequest() {
        
        //만약 한글 검색이 안된다면 인코딩 처리
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
                
                self.totalCount = success.total
                self.resultCountLabel.text = "\(self.totalCount)개의 검색 결과"
                
                self.resultCollectionView.reloadData()
                
            case .failure(let failure):
                print(failure)
            }
            
        }
    }
    
    
    func designButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.tintColor = .text
        button.backgroundColor = .background
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
    }
    
}

extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingList.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as! SearchResultCollectionViewCell
        let imageURL = URL(string: shoppingList.items[indexPath.row].image)
        cell.productImageView.kf.setImage(with: imageURL)
        cell.productImageView.layer.cornerRadius = 10
        cell.brandLabel.text = shoppingList.items[indexPath.row].brand
        cell.brandLabel.textColor = .lightGray
        cell.brandLabel.font = .systemFont(ofSize: 14)
        cell.productNameLabel.text = removeHTMLTags(from: shoppingList.items[indexPath.row].title)
        cell.productNameLabel.textColor = .text
        cell.productNameLabel.font = .boldSystemFont(ofSize: 16)
        cell.productNameLabel.numberOfLines = 2
        cell.priceLabel.text = shoppingList.items[indexPath.row].lprice
        cell.priceLabel.textColor = .text
        cell.priceLabel.font = .boldSystemFont(ofSize: 18)
        
        if IDList.contains(shoppingList.items[indexPath.row].productID) {
            cell.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        
        cell.heartButton.setTitle("", for: .normal)
        cell.heartButton.tintColor = .background
        cell.heartButton.backgroundColor = .text
        cell.heartButton.layer.cornerRadius = cell.heartButton.frame.width / 2
        cell.heartButton.clipsToBounds = true
        cell.heartButton.tag = indexPath.row
        cell.heartButton.addTarget(self, action: #selector(heartButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Search", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchDetailViewController") as! SearchDetailViewController
        vc.id = shoppingList.items[indexPath.row].productID
        vc.name = removeHTMLTags(from: shoppingList.items[indexPath.row].title)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(totalCount, indexPaths)
        
        for item in indexPaths {
            if shoppingList.items.count - 3 == item.row && totalCount != item.row {
                start += 20
                callRequest()
            }
        }
    }
    // 취소 기능. 직접 취소하는 기능을 구현해주어야 동작함
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("cancel prefetch \(indexPaths)")
    }
    
    
}





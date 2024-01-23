//
//  SearchAPIManager.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/23/24.
//

import Foundation
import Alamofire

class SearchAPIManager {
    
    static let shared = SearchAPIManager()
    private init() {}
    
    let headers: HTTPHeaders = [
        "X-Naver-Client-Id": APIKey.clientID,
        "X-Naver-Client-Secret": APIKey.clientSecret
    ]
    
    func callRequest(text: String, start: Int, sort: Sort, completionHandler: @escaping (Result<Shopping, AFError>) -> Void) {
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=20&start=\(start)&sort=\(sort)"
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            completionHandler(response.result)
        }
    }
}

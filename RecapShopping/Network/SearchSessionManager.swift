//
//  SearchSessionManager.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 2/6/24.
//

import Foundation
import Alamofire

enum ErrorType: Error {
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
}

extension URLSession {
    typealias completionHandler = (Data?, URLResponse?, Error?) -> Void
    
    @discardableResult
    func customDataTask(_ request: URLRequest, completionHandler: @escaping completionHandler) -> URLSessionDataTask {
        let task = dataTask(with: request, completionHandler: completionHandler)
        task.resume()
        return task
    }
}

class SearchSessionManager {
    static func request<T: Codable>(_ session: URLSession = .shared, request: URLRequest, completion: @escaping (T?, ErrorType?) -> Void ) {
        var request = request
        request.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        session.customDataTask(request) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("네트워크 통신 실패")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("데이터 불러오기 실패")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("응답 불러오기 실패")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("정확한 응답 실패")
                    completion(nil, .invalidResponse)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    dump(result)
                    completion(result, nil)
                } catch {
                    print(error)
                    completion(nil, .invalidData)
                }
            }
        }
    }
    
    
//    static func searchRequest(query: String, start: Int, sort: String, completionHandler: @escaping (Shopping?, ErrorType?) -> Void) {
//        let scheme = "https"
//        let host = "openapi.naver.com"
//        let path = "/v1/search/shop"
//        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        
//        var component = URLComponents()
//        component.scheme = scheme
//        component.host = host
//        component.path = path
//        component.queryItems = [
//            URLQueryItem(name: "query", value: query),
//            URLQueryItem(name: "display", value: "20"),
//            URLQueryItem(name: "start", value: String(start)),
//            URLQueryItem(name: "sort", value: sort)
//        ]
//    
//        var request = URLRequest(url: component.url!)
//        request.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
//        request.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
//
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                guard error == nil else {
//                    print("네트워크 통신 실패")
//                    completionHandler(nil, .failedRequest)
//                    return
//                }
//                
//                guard let data = data else {
//                    print("데이터 불러오기 실패")
//                    completionHandler(nil, .noData)
//                    return
//                }
//                
//                guard let response = response as? HTTPURLResponse else {
//                    print("응답 불러오기 실패")
//                    completionHandler(nil, .invalidResponse)
//                    return
//                }
//                
//                guard response.statusCode == 200 else {
//                    print("정확한 응답 실패")
//                    completionHandler(nil, .invalidResponse)
//                    return
//                }
//                
//                do {
//                    let result = try JSONDecoder().decode(Shopping.self, from: data)
//                    dump(result)
//                    completionHandler(result, nil)
//                } catch {
//                    print(error)
//                    completionHandler(nil, .invalidData)
//                }
//            }
//        }.resume()
//    }
}

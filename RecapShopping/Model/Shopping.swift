//
//  Shopping.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/21/24.
//

import Foundation

// MARK: - Shopping
struct Shopping: Codable {
    var lastBuildDate: String
    var total: Int
    var start,  display: Int
    var items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let lprice, hprice: String
    let mallName: String
    let productID, productType: String
    let brand, maker: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, image, lprice, hprice, mallName
        case productID = "productId"
        case productType, brand, maker, category1, category2, category3, category4
    }
}

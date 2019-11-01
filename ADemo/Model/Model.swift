//
//  Model.swift
//  ADemo
//
//  Created by Dalibor Kozak on 28/10/2019.
//  Copyright © 2019 Dalibor Kozak. All rights reserved.
//

import Foundation

protocol Descriptive {
    var name: String { get }
    var img: URL? { get }
}

enum RequestType {
    case category
    case product(Int)
    case detail(Int)
}

struct CategoryWrapper: Codable {
    var data: [Category]
}

struct Category: Codable, Descriptive {
    var id: Int
    var name: String
    var img: URL?
    var type: String
    var cat_type: String
    var show_as_tiles: Bool
    var child_cnt: Int
    var order: Int
    var producer: Int
    var children: [Category?]?
    var cat_type_id: Int
    var ltp: Bool
    var url: URL?
    var description:  Description?
}

struct Description: Codable {
    var annotation: String?
    var oreInfoLinkText: String?
    var moreInfoUrl: String?
}

struct ProductWrapper: Codable {
    var data: [Product]
}

struct Product: Codable, Descriptive {
    var id: Int?
    var code: String
    var img: URL?
    var name: String
    var spec: String
    var price: String
    var priceWithoutVat: String
    var url: URL?
}

struct DetailWrapper: Codable {
    var data: ProductDetail
}

struct ProductDetail: Codable {
    var id: Int
    var code: String
    var img: URL?
    var name: String
    var spec: String
    var price: String
    var priceWithoutVat: String
    var url: URL?
    var categoryId: Int
    var categoryName: String
    var currency: String
    var delayedPaymentPriceWithVat: String
    var delayedPaymentRemainingPriceWithVat: String
    var gaCategory: String
    var imgs: [ProductImage]
    var warranty: String
}

struct ProductImage: Codable {
    var id: String?
    var url: URL?
    var big_url: URL?
    var origUrl: URL?
}

struct Constants {
    static let categoriesUrl = "https://www.alza.cz/Services/RestService.svc/v1/floors"
    static let productsUrl = "https://www.alza.cz/Services/RestService.svc/v2/products"
    static let detailUrl = "https://www.alza.cz/Services/RestService.svc/v9/product/"
    
    static let cellId = "cell"
    static let mainVcId = "mainViewController"
    static let detailVcId = "detailViewController"
}


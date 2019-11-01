//
//  Network.swift
//  ADemo
//
//  Created by Dalibor Kozak on 28/10/2019.
//  Copyright © 2019 Dalibor Kozak. All rights reserved.
//

import Foundation
import RxSwift

class DataProvider {
    
    static let shared = DataProvider()
    
    func requestBuilder(for requestType: RequestType) -> URLRequest {
        switch requestType {
        case .category:
            let url = URL(string: Constants.categoriesUrl)!
            return URLRequest(url: url)
            
        case .product(let id):
            let url = URL(string: Constants.productsUrl)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let bodyObject: [String : Any] = ["filterParameters": ["id": String(id)]]
            request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            return request
            
        case .detail(let id):
            let url = URL(string: Constants.detailUrl + "\(String(id))")!
            return URLRequest(url: url)
        }
    }
    
    func requestData<T: Codable>(for requestType: RequestType) -> Observable<T> {
        return URLSession.shared.rx.data(request:  requestBuilder(for: requestType))
            .map({ data  in
                return try JSONDecoder().decode(T.self, from: data)
            }).share()
    }
    
}


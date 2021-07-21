//
//  URL+QueryParams.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 19/07/21.
//

import Foundation

extension URLComponents {
    mutating func setQueryItems(_ parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

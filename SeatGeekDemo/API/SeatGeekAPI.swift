//
//  SeatGeekAPI.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 16/07/21.
//
//  Reference Article - https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908

import Foundation

enum SeatGeekAPI {
    case fetchEvents(searchTerm: String, page: Int, maxResultCount: Int)
}

extension SeatGeekAPI: EndPoint {
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var host: String {
        return "api.seatgeek.com"
    }
    
    private var clientId: String {
        return "MjE1MjAzODB8MTYxMTg4NDExNy4wODYxNDM"
    }
    
    var path: String {
        switch self {
        case .fetchEvents:
            return "/2/events"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchEvents:
            return .get
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .fetchEvents(let searchText, let page, let maxResultCount):
            return ["client_id": clientId,
                    "q": searchText,
                    "page": String(page),
                    "per_page": String(maxResultCount)]
        }
    }
    
}

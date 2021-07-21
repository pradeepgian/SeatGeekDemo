//
//  EndPointType.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 21/07/21.
//
//  Reference Article - https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908

import Foundation

protocol EndPoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var parameters: [String: String] { get }
}

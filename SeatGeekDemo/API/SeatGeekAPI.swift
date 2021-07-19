//
//  SeatGeekAPI.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 16/07/21.
//

import Foundation

class SeatGeekAPI {
    
    static let shared = SeatGeekAPI()
    
    func fetchEvents(searchTerm: String?, completion: @escaping (SearchResult?, Error?) -> ()) {
        guard var url = URL(string: API.eventsUrl) else { return }
        url.appendQueryItem(name: API.clientIdKey, value: API.clientIdValue)
        url.appendQueryItem(name: API.clientSecretKey, value: API.clientSecretValue)
        if let searchText = searchTerm {
            url.appendQueryItem(name: "q", value: searchText)
        }
        fetchGenericJSONData(url: url, completion: completion)
    }
    
    func fetchGenericJSONData<T: Decodable>(url: URL, completion: @escaping (T?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            do {
                let objects = try JSONDecoder().decode(T.self, from: data!)
                // success
                completion(objects, nil)
            } catch {
                completion(nil, error)
            }
            }.resume()
    }
}

fileprivate struct API {
    static let eventsUrl = "https://api.seatgeek.com/2/events"
    static let clientIdKey = "client_id"
    static let clientIdValue = "MjE1MjAzODB8MTYxMTg4NDExNy4wODYxNDM"
    static let clientSecretKey = "client_secret"
    static let clientSecretValue = "97eeb2b4f8ad2d01876e0e4609cef92c8000623e4e9efaa74ca0726b4b0c3dd6"
}

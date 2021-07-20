//
//  SeatGeekAPI.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 16/07/21.
//

import Foundation

struct SeatGeekAPI {
    
    private init() {}
    
    private static let eventsUrl = "https://api.seatgeek.com/2/events"
    private static let clientIdKey = "client_id"
    private static let clientIdValue = "MjE1MjAzODB8MTYxMTg4NDExNy4wODYxNDM"
    private static let clientSecretKey = "client_secret"
    private static let clientSecretValue = "97eeb2b4f8ad2d01876e0e4609cef92c8000623e4e9efaa74ca0726b4b0c3dd6"
    private static let pageNumberKey = "page"
    private static let eventsPerPageKey = "per_page"
    private static let queryKey = "q"
    static let eventsPerPage = 20
    
    static func fetchEvents(searchTerm: String?, pageNumber:Int, completion: @escaping (SearchResult?, Error?) -> ()) {
        guard var url = URL(string: eventsUrl) else { return }
        url.appendQueryItem(name: clientIdKey, value: clientIdValue)
        url.appendQueryItem(name: clientSecretKey, value: clientSecretValue)
        url.appendQueryItem(name: pageNumberKey, value: String(pageNumber))
        url.appendQueryItem(name: eventsPerPageKey, value: String(eventsPerPage))
        if let searchText = searchTerm {
            url.appendQueryItem(name: queryKey, value: searchText)
        }
        fetchGenericJSONData(url: url, completion: completion)
    }
    
    private static func fetchGenericJSONData<T: Decodable>(url: URL, completion: @escaping (T?, Error?) -> ()) {
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

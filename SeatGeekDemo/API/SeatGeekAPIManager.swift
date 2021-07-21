//
//  SeatGeekAPIManager.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 21/07/21.
//

import Foundation

class SeatGeekAPIManager {
    static func urlRequest<T: Decodable>(endPoint: EndPoint, completion: @escaping (T?, Error?) -> ()) {
        var components = URLComponents()
        components.scheme = endPoint.scheme
        components.host = endPoint.host
        components.path = endPoint.path
        components.setQueryItems(endPoint.parameters)
        guard let url = components.url else { return }
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

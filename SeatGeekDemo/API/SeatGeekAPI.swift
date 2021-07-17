//
//  SeatGeekAPI.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 16/07/21.
//

import Foundation

class SeatGeekAPI {
    static let shared = SeatGeekAPI()
    
    func fetchEvents(searchTerm: String, completion: @escaping (SearchResult?, Error?) -> ()) {
        let urlString = "https://api.seatgeek.com/2/events?client_id=MjI1NDg5OTN8MTYyNjQ1MDgyMi4yMzI1NDQ&client_secret=746477eaa01142f0d58ea92741e631f67c94738afa84e89328c09d823dbbd47e&q=\(searchTerm)"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
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

//
//  SearchResult.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import Foundation

struct SearchResult: Decodable {
    let events: [Event]
}

struct Event: Decodable, UserDefaultsManagerProtocol {
    let id: Int
    let datetime_utc: String
    let venue: Venue
    let performers: [Performer]
    let title: String
    var isFavorite: Bool {
        return getFavoritedEvents().contains(id)
    }
}

struct Performer: Decodable {
    let image: String?
}

struct Venue: Decodable {
    let city: String?
    let state: String?
}

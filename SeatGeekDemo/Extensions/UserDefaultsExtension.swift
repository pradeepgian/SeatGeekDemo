//
//  UserDefaultsExtension.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import Foundation

protocol UserDefaultsManagerProtocol {
    func getFavoritedEvents() -> [Int]
    func favoriteEvent(_ eventId: Int)
    func unfavoriteEvent(_ eventId: Int)
}

extension UserDefaultsManagerProtocol {
    
    private var favoritedEventsKey: String {
        return "favoritedEventsKey"
    }
    
    private var standardDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    func getFavoritedEvents() -> [Int] {
        guard let events = standardDefaults.array(forKey: favoritedEventsKey) else { return [] }
        return events as! [Int]
    }
    
    func favoriteEvent(_ eventId: Int) {
        var events = getFavoritedEvents()
        events.append(eventId)
        UserDefaults.standard.set(events, forKey: favoritedEventsKey)
    }

    func unfavoriteEvent(_ eventId: Int) {
        let events = getFavoritedEvents()
        let filteredEvents = events.filter {
            return $0 != eventId
        }
        UserDefaults.standard.set(filteredEvents, forKey: favoritedEventsKey)
    }
}

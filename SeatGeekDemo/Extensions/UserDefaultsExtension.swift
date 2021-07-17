//
//  UserDefaultsExtension.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import Foundation

extension UserDefaults {
    
    static let favoritedEventsKey = "favoritedEventsKey"
    
    func getFavoritedEvents() -> [Int] {
        guard let events = UserDefaults.standard.array(forKey: UserDefaults.favoritedEventsKey) else { return [] }
        return events as! [Int]
    }
    
    func favoriteEvent(_ eventId: Int) {
        var events = getFavoritedEvents()
        events.append(eventId)
        UserDefaults.standard.set(events, forKey: UserDefaults.favoritedEventsKey)
    }

    func unfavoriteEvent(_ eventId: Int) {
        let events = getFavoritedEvents()
        let filteredEvents = events.filter {
            return $0 != eventId
        }
        UserDefaults.standard.set(filteredEvents, forKey: UserDefaults.favoritedEventsKey)
    }
    
}

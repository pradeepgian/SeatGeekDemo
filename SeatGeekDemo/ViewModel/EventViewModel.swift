//
//  EventViewModel.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 20/07/21.
//

import Foundation

struct EventViewModel: CellViewModelProtocol, UserDefaultsManagerProtocol {
    
    private let event: Event
    
    init(event: Event) {
        self.event = event
    }
    
    var eventId: Int {
        return event.id
    }
    
    var eventImageUrl: URL? {
        guard let imageStr = event.performers[0].image else { return nil }
        return URL(string: imageStr)
    }
    
    var eventTitle: String {
        return event.title
    }
    
    var timestamp: String {
        let utc_time = event.datetime_utc.getDate(timezone: TimeZone.utc)
        let timeStampStr = utc_time?.toString(timezone: TimeZone.current)
        return timeStampStr ?? ""
    }
    
    var eventVenue: String {
        guard let city = event.venue.city,
              let state = event.venue.state else { return "" }
        return "\(city), \(state)"
    }
    
    var isFavorite: Bool {
        return getFavoritedEvents().contains(event.id)
    }
    
}

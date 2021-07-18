//
//  Date+Helper.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import Foundation

extension Date {
    func toString(format: String = "EEEE, MMM d yyyy h:mm a", timezone: TimeZone) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = timezone
            return formatter.string(from: self)
        }
}

extension String {
    func getDate(format: String = "yyyy-MM-dd'T'HH:mm:ss", timezone: TimeZone) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timezone
        return dateFormatter.date(from: self)
    }
}

extension TimeZone {
    static var utc: TimeZone {
        TimeZone(abbreviation: "UTC")!
    }
}

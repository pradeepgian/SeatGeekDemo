//
//  Bindable.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 02/05/22.
//

import Foundation

class Bindable<T> {
    private var _value: T!
    var value: T {
        get {
            return _value
        }
        set {
            _value = newValue
            valueChanged?(newValue)
        }
    }

    init(value: T) {
        _value = value
    }

    var valueChanged: ((T) -> Void)?
}

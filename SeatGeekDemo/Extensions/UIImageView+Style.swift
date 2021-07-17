//
//  UIImageView+Style.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import UIKit

extension UIImageView {
    convenience init(cornerRadius: CGFloat) {
        self.init(image: nil)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

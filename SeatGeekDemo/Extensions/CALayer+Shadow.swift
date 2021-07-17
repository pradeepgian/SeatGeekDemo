//
//  CALayer+Shadow.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import UIKit

extension CALayer {
    func applyShadow(color: UIColor = .black,
                     alpha: Float = 0.5,
                     xPosition: CGFloat = 0,
                     yPosition: CGFloat = 2,
                     blur: CGFloat = 4,
                     spread: CGFloat = 0) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: xPosition, height: yPosition)
        shadowRadius = blur / 2.0
        shadowPath = spread != 0 ? UIBezierPath(rect: bounds.insetBy(dx: -spread, dy: -spread)).cgPath : nil
    }
}

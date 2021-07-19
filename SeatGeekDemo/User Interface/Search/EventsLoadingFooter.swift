//
//  EventsLoadingFooter.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 19/07/21.
//

import UIKit

class EventsLoadingFooter: UICollectionReusableView {
    
    static let cellIdentifier = "EventsLoading_Identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        
        let label = UILabel(text: "Loading...", font: .systemFont(ofSize: 16), textColor: .black)
        label.textAlignment = .center
        
        let stackView = StackView(axis: .vertical,
                                  arrangedSubviews: [activityIndicatorView, label],
                                  spacing: 8,
                                  alignment: .center)
        
        addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: 200, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}

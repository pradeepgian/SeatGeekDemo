//
//  SearchResultCell.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import UIKit
import SDWebImage

class EventCell: UICollectionViewCell {
    
    static let cellIdentifier = "EventCell_Identifier"
    
    var event: Event! {
        didSet {
            eventImageView.sd_setImage(with: URL(string: event.performers[0].image ?? ""))
            eventNameLabel.text = event.title
            let datetime_utc = event.datetime_utc.getDate(timezone: TimeZone.utc)
            let timeStampStr = datetime_utc?.toString(timezone: TimeZone.current)
            timestampLabel.text = timeStampStr
            favoriteBadgeImageView.isHidden =  event.isFavorite ? false : true
            guard let city = event.venue.city,
                  let state = event.venue.state else { return }
            locationLabel.text = "\(city), \(state)"
        }
    }
    
    private let eventImageView = UIImageView(cornerRadius: 8)
    private let eventNameLabel = UILabel(text: "Event Name", font: .boldSystemFont(ofSize: 16), textColor: .black, numberOfLines: 2, alignment: .left)
    private let locationLabel = UILabel(text: "Location", font: .systemFont(ofSize: 13), textColor: .black, numberOfLines: 1, alignment: .left)
    private let timestampLabel = UILabel(text: "Time Stamp", font: .systemFont(ofSize: 13), textColor: .black, numberOfLines: 1, alignment: .left)
    private let favoriteBadgeImageView = UIImageView(image: #imageLiteral(resourceName: "like_selected"))
    
    lazy private var imageWithFavoriteBadgeView: UIView = {
        let view = UIView()
        view.addSubview(eventImageView)
        view.addSubview(favoriteBadgeImageView)
        favoriteBadgeImageView.constrainWidth(constant: 30)
        favoriteBadgeImageView.constrainHeight(constant: 30)
        eventImageView.fillSuperview()
        eventImageView.contentMode = .scaleAspectFill
        favoriteBadgeImageView.anchor(top: eventImageView.topAnchor, leading: eventImageView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: -15, left: -15, bottom: 0, right: 0))
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stylizeCell()
        eventImageView.constrainWidth(constant: 80)
        eventImageView.constrainHeight(constant: 80)
        
        let stackView = StackView(arrangedSubviews: [imageWithFavoriteBadgeView, StackView(axis: .vertical, arrangedSubviews: [eventNameLabel, locationLabel, timestampLabel], spacing: 3, alignment: .leading)], spacing: 10, alignment: .center)
        stackView.spacing = 16
        contentView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 8, left: 20, bottom: 8, right: 8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func stylizeCell() {
        self.backgroundView = UIView()
        addSubview(self.backgroundView!)
        self.backgroundView?.fillSuperview()
        self.backgroundView?.layer.cornerRadius = 8.0
        self.backgroundView?.backgroundColor = .white
        self.backgroundView?.layer.shadowColor = UIColor.black.cgColor
        self.backgroundView?.layer.shadowOpacity = 0.5
        self.backgroundView?.layer.shadowRadius = 10
        self.backgroundView?.layer.shadowOffset = .init(width: 0, height: 3)
        self.backgroundView?.layer.shouldRasterize = true
    }
}

//
//  EventDetailsViewController.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    private var eventViewModel: EventCellViewModel! {
        didSet {
            eventImageView.sd_setImage(with: eventViewModel.eventImageUrl)
            eventNameLabel.text = eventViewModel.eventTitle
            timestampLabel.text = eventViewModel.timestamp
            let image =  eventViewModel.isFavorite ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "like_unselected")
            likeButton.setImage(image, for: .normal)
            locationLabel.text = eventViewModel.eventVenue
        }
    }
    
    private let eventNameLabel = UILabel(font: .boldSystemFont(ofSize: 20), textColor: .black, numberOfLines: 0, alignment: .left)
    private let timestampLabel = UILabel(font: .boldSystemFont(ofSize: 20), textColor: .black, numberOfLines: 1, alignment: .left)
    private let locationLabel = UILabel(font: .systemFont(ofSize: 13), textColor: .black, numberOfLines: 1, alignment: .left)
    
    lazy private var likeButton: UIButton = { [unowned self] in
        let button = UIButton(type: .custom)
        button.constrainWidth(constant: 25)
        button.constrainHeight(constant: 25)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy private var eventNameStackView = StackView(arrangedSubviews: [eventNameLabel, likeButton], spacing: 15, alignment: .top)
    
    lazy private var eventDetailStackView = StackView(axis: .vertical, arrangedSubviews: [
        eventNameStackView,
        StackView(arrangedSubviews: [eventImageView], alignment: .center),
        timestampLabel,
        locationLabel
    ], spacing: 10, alignment: .leading)
    
    init(event: Event) {
        super.init(nibName: nil, bundle: nil)
        setEventViewModel(event)
    }
    
    private func setEventViewModel(_ event: Event) {
        self.eventViewModel = EventCellViewModel(event: event)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleLike() {
        if self.eventViewModel.isFavorite {
            UserDefaults.standard.unfavoriteEvent(eventViewModel.eventId)
            likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        } else {
            UserDefaults.standard.favoriteEvent(eventViewModel.eventId)
            likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Details"
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(eventDetailStackView)
        eventNameStackView.anchor(top: eventDetailStackView.topAnchor, leading: eventDetailStackView.leadingAnchor, bottom: nil, trailing: eventDetailStackView.trailingAnchor)
        eventImageView.constrainWidth(constant: self.view.frame.width - 2 * 10)
        eventDetailStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 12, bottom: 0, right: 12))
    }
    
}


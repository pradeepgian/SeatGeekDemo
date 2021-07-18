//
//  EventDetailsViewController.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    private var event: Event! {
        didSet {
            eventImageView.sd_setImage(with: URL(string: event.performers[0].image ?? ""))
            eventNameLabel.text = event.title
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let date = dateFormatter.date(from: event.datetime_utc ?? "")
            dateFormatter.dateFormat = "EEEE, MMM d yyyy h:mm a"
            dateFormatter.timeZone = TimeZone.current
            let timeStamp = dateFormatter.string(from: date!)
            timestampLabel.text = timeStamp
            
            let image = self.event.isFavorite ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "like_unselected")
            likeButton.setImage(image, for: .normal)
            
            guard let city = event.venue.city,
                  let state = event.venue.state else { return }
            locationLabel.text = "\(city), \(state)"
        }
    }
    private let eventNameLabel = UILabel(text: "Event Name", font: .boldSystemFont(ofSize: 20), textColor: .black, numberOfLines: 0, alignment: .left)
    private let timestampLabel = UILabel(text: "Time Stamp", font: .boldSystemFont(ofSize: 20), textColor: .black, numberOfLines: 1, alignment: .left)
    private let locationLabel = UILabel(text: "Location", font: .systemFont(ofSize: 13), textColor: .black, numberOfLines: 1, alignment: .left)
    
    lazy private var likeButton: UIButton = {
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
        setEvent(event)
    }
    
    private func setEvent(_ event: Event) {
        self.event = event
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleLike() {
        if self.event.isFavorite {
            UserDefaults.standard.unfavoriteEvent(event.id)
            likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        } else {
            UserDefaults.standard.favoriteEvent(event.id)
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

//#if DEBUG
//
//import SwiftUI
//struct EventDetailsView: UIViewControllerRepresentable {
//    func makeUIViewController(context: UIViewControllerRepresentableContext<EventDetailsView>) -> UIViewController {
//        let controller = EventDetailViewController()
//        return UINavigationController(rootViewController: controller)
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<EventDetailsView>) {
//        
//    }
//    
//    typealias UIViewControllerType = UIViewController
//}
//
//struct EventDetailsCompositionalView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailsView()
//            .edgesIgnoringSafeArea(.all)
//            .colorScheme(.dark)
//    }
//}
//
//#endif

//
//  EventDetailsViewController.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    private var eventViewModel: EventViewModel?
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
    
    @objc func handleLike() {
        eventViewModel?.handleLikeButtonTap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Details"
        setupUI()
        addEventViewModelObserver()
    }
    
    private func setupUI() {
        view.addSubview(eventDetailStackView)
        eventNameStackView.anchor(top: eventDetailStackView.topAnchor, leading: eventDetailStackView.leadingAnchor, bottom: nil, trailing: eventDetailStackView.trailingAnchor)
        eventImageView.constrainWidth(constant: self.view.frame.width - 2 * 10)
        eventDetailStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 12, bottom: 0, right: 12))
    }
    
    private func addEventViewModelObserver() {
        eventViewModel?.screenState.valueChanged = { [weak self] screenState in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch screenState {
                case .likeEvent:
                    self.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
                    break;
                case .unlikeEvent:
                    self.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                    break;
                default:
                    break;
                }
            }
        }
    }
}

extension EventDetailViewController: ConfigureDataInViewProtocol {
    
    func updateDataInView(from viewModel: ViewModelProtocol) {
        eventViewModel = viewModel as? EventViewModel
        if let eventViewModel = eventViewModel {
            eventImageView.sd_setImage(with: eventViewModel.eventImageUrl)
            eventNameLabel.text = eventViewModel.eventTitle
            timestampLabel.text = eventViewModel.timestamp
            let image =  eventViewModel.isFavorite ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "like_unselected")
            likeButton.setImage(image, for: .normal)
            locationLabel.text = eventViewModel.eventVenue
        }
    }
    
}


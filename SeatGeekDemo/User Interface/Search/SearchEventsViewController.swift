//
//  SearchEventsViewController.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import UIKit
import Combine

class SearchEventsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let eventsViewModel = EventsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.cellIdentifier)
        collectionView.register(EventsLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: EventsLoadingFooter.cellIdentifier)
        collectionView?.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        setupSearchBar()
        eventsViewModelObserver()
        eventsViewModel.fetchEventsFromService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    private func eventsViewModelObserver() {
        eventsViewModel.screenState.valueChanged = { [weak self] screenState in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch screenState {
                    case .fetchEventsDataLoadingComplete:
                        self.collectionView.reloadData()
                        break
                    case let .fetchMembersDataloadingError(error):
                        print("Something went wrong \(String(describing: error))")
                        let errorMessage = error?.localizedDescription
                        print(errorMessage ?? "")
                        break
                    case .searchEventDataLoadingComplete:
                        self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                          at: .top,
                                                          animated: false)
                        break
                    default:
                        break
                }
            }
        }
    }
    
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        setupSearchBarListener()
    }
    
    private var listener: AnyCancellable!
    
    private func setupSearchBarListener() {
        listener = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField).map {
            ($0.object as! UISearchTextField).text
        }.debounce(for: .milliseconds(300), scheduler: RunLoop.main).sink { [weak self] (eventSearchText) in
            self?.eventsViewModel.searchLabelText = eventSearchText
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2 * 16)
        return .init(width: width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = eventsViewModel.isDonePaginating ? 0 : 100
        return .init(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EventsLoadingFooter.cellIdentifier, for: indexPath)
        return footer
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsViewModel.events.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.cellIdentifier, for: indexPath) as! EventCell
        if let eventViewModel = eventsViewModel.getCellViewModel(for: indexPath) {
            cell.updateDataInView(from: eventViewModel)
        }
        if indexPath.item == eventsViewModel.events.count - 1 && !eventsViewModel.isPaginating {
            print("fetch more events")
            eventsViewModel.initiatePagination()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let eventDetailController = EventDetailViewController()
        if let eventViewModel = eventsViewModel.getCellViewModel(for: indexPath) {
            eventDetailController.updateDataInView(from: eventViewModel)
        }
        navigationController?.pushViewController(eventDetailController, animated: true)
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

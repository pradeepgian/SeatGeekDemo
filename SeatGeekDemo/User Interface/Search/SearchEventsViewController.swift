//
//  SearchEventsViewController.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import UIKit

class SearchEventsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.cellIdentifier)
        collectionView.register(EventsLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: EventsLoadingFooter.cellIdentifier)
        collectionView?.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        setupSearchBar()
        fetchEvents() { result in
            self.events = result
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private var timer: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // introduce some delay before performing the search
        // throttling the search
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.fetchEvents(searchText, page: 1) { (result) in
                self.events = result
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                      at: .top,
                                                      animated: false)
                }
            }
        })
    }
    
    private var events = [Event]()
    
    var pageNumber: Int {
        let fractionNumOfPages = Double(self.events.count) / Double(API.eventsPerPage)
        return Int(ceil(fractionNumOfPages)) + 1
    }
    
    private func fetchEvents(_ searchText: String? = nil, page: Int? = nil, completion: @escaping ([Event]) -> ()) {
        SeatGeekAPI.shared.fetchEvents(searchTerm: searchText, pageNumber: page ?? pageNumber) { (res, err) in
            if let err = err {
                print("Failed to fetch events:", err)
                return
            }
            let events = res?.events ?? []
            completion(events)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2 * 16)
        return .init(width: width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = isDonePaginating ? 0 : 100
        return .init(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EventsLoadingFooter.cellIdentifier, for: indexPath)
        return footer
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    var isPaginating = false
    var isDonePaginating = false
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.cellIdentifier, for: indexPath) as! EventCell
        cell.event = events[indexPath.item]
        
        // initiate pagination
        if indexPath.item == events.count - 1 && !isPaginating {
            print("fetch more events")
            isPaginating = true
            self.fetchEvents() { (events) in
                if events.count == 0 {
                    self.isDonePaginating = true
                }
                usleep(useconds_t(200))
                self.events += events
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.isPaginating = false
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let eventDetailController = EventDetailViewController(event: events[indexPath.row])
        navigationController?.pushViewController(eventDetailController, animated: true)
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

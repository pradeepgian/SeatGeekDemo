//
//  SearchEventsViewController.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import UIKit

class SearchEventsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.cellIdentifier)
        collectionView?.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        setupSearchBar()
        fetchEvents()
    }
    
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    var timer: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        // introduce some delay before performing the search
        // throttling the search
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            
            // this will actually fire my search
            SeatGeekAPI.shared.fetchEvents(searchTerm: searchText) { (res, err) in
                if let err = err {
                    print("Failed to fetch events:", err)
                    return
                }
                
                self.events = res?.events ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        })
    }
    
    fileprivate var events = [Event]()
    
    fileprivate func fetchEvents() {
        SeatGeekAPI.shared.fetchEvents(searchTerm: "") { (res, err) in
            if let err = err {
                print("Failed to fetch events:", err)
                return
            }
            self.events = res?.events ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2 * 16)
        return .init(width: width, height: 90)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        enterSearchTermLabel.isHidden = events.count != 0
        return events.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.cellIdentifier, for: indexPath) as! EventCell
        cell.event = events[indexPath.item]
        return cell
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

import SwiftUI
struct EventsView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<EventsView>) -> UIViewController {
        let controller = SearchEventsViewController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<EventsView>) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}

struct EventsCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
            .edgesIgnoringSafeArea(.all)
            .colorScheme(.dark)
    }
}

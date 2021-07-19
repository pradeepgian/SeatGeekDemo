//
//  SearchEventsViewController.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 17/07/21.
//

import UIKit

class SearchEventsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.cellIdentifier)
        collectionView?.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        setupSearchBar()
        fetchEvents()
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
            self.fetchEvents(searchText)
        })
    }
    
    private var events = [Event]()
    
    private func fetchEvents(_ searchText: String? = nil) {
        SeatGeekAPI.shared.fetchEvents(searchTerm: searchText) { (res, err) in
            if let err = err {
                print("Failed to fetch events:", err)
                return
            }
            self.events = res?.events ?? []
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2 * 16)
        return .init(width: width, height: 110)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.cellIdentifier, for: indexPath) as! EventCell
        cell.event = events[indexPath.item]
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

//#if DEBUG
//
//import SwiftUI
//struct EventsView: UIViewControllerRepresentable {
//    func makeUIViewController(context: UIViewControllerRepresentableContext<EventsView>) -> UIViewController {
//        let controller = SearchEventsViewController()
//        return UINavigationController(rootViewController: controller)
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<EventsView>) {
//        
//    }
//    
//    typealias UIViewControllerType = UIViewController
//}
//
//struct EventsCompositionalView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventsView()
//            .edgesIgnoringSafeArea(.all)
//            .colorScheme(.dark)
//    }
//}
//
//#endif

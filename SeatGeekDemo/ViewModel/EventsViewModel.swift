//
//  EventsViewModel.swift
//  SeatGeekDemo
//
//  Created by Pradeep Gianchandani on 02/05/22.
//

import Foundation

enum ScreenState {
    case idle
    case fetchEventsDataLoading
    case fetchEventsDataLoadingComplete
    case fetchMembersDataloadingError(error: Error?)
    case searchEventDataLoadingComplete
}

class EventsViewModel {
    
    var screenState: Bindable<ScreenState> = Bindable(value: .idle)
    private var maxEventsPerFetch = 20
    var events = [Event]()
    var searchLabelText: String? {
        didSet {
            fetchEventsFromService(searchLabelText ?? "", page: 1) {
                self.screenState.value = .searchEventDataLoadingComplete
            }
        }
    }
    var pageNumber: Int {
        let fractionNumOfPages = Double(self.events.count) / Double(maxEventsPerFetch)
        return Int(ceil(fractionNumOfPages)) + 1
    }
    
    var isPaginating = false
    var isDonePaginating = false
    
    func fetchEventsFromService(_ searchText: String = "", page: Int? = nil, completion: (() -> Void)? = nil) {
        let endpoint = SeatGeekAPI.fetchEvents(searchTerm: searchText, page: page ?? pageNumber, maxResultCount: maxEventsPerFetch)
        SeatGeekAPIManager.urlRequest(endPoint: endpoint) { (res: SearchResult?, err) in
            if let err = err {
                print("Failed to fetch events:", err)
                self.screenState.value = .fetchMembersDataloadingError(error: err)
                return
            }
            if (self.isPaginating) {
                self.events += res?.events ?? []
                self.isPaginating = false
                self.isDonePaginating = (res?.events.count ?? 0 == 0) ? true : false
            } else {
                self.events = res?.events ?? []
            }
            self.screenState.value = .fetchEventsDataLoadingComplete
            completion?()
        }
    }
    
    func initiatePagination() {
        isPaginating = true
        fetchEventsFromService()
    }
    
}

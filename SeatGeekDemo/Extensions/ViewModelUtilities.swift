//
//  ViewModelUtilities.swift
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
    case likeEvent
    case unlikeEvent
}

protocol CollectionViewCellViewModelProvider {
    func getCellViewModel(for indexPath: IndexPath) -> ViewModelProtocol?
}

protocol ViewModelProtocol { }

protocol ConfigureDataInViewProtocol {
    func updateDataInView(from viewModel: ViewModelProtocol)
}

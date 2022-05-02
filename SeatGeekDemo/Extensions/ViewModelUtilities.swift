//
//  ViewModelUtilities.swift
//  SeatGeekDemo
//
//  Created by Pradeep3 G on 02/05/22.
//

import Foundation

enum ScreenState {
    case idle
    case fetchEventsDataLoading
    case fetchEventsDataLoadingComplete
    case fetchMembersDataloadingError(error: Error?)
    case searchEventDataLoadingComplete
}

protocol CollectionViewCellViewModelProvider {
    func getCellViewModel(for indexPath: IndexPath) -> CellViewModelProtocol?
}

protocol CellViewModelProtocol { }

protocol ConfigureDataInCollectionViewCell {
    func updateDataFromCellViewModel(_ viewModel: CellViewModelProtocol)
}

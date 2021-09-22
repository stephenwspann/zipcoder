//
//  SearchViewModel.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/20/21.
//

import Foundation

enum SearchState {
    case initialState
    case zipCodeError
    case distanceError
    case searching
    case completed
}

class SearchViewModel {
    
    var zipCodeApi = ZipCodeApi()

    @Published var searchState: SearchState = SearchState.initialState
    
    @Published var filteredZipCodes: [ZipCode] = [ZipCode]()
    
    private var _searchedZipCode = ""
    
    private var _zipCodes = [ZipCode]() {
        didSet {
            filteredZipCodes = _zipCodes.filter {
                $0.zipCode != _searchedZipCode
            }.sorted {
                $0.distanceSortable < $1.distanceSortable
            }
        }
    }

    public init() {

    }
    
    public func getZipCodes(zipCode: String?, distance: String?) {
        
        guard let zipCodeVal = Int(zipCode!) else {
            searchState = SearchState.zipCodeError
            return
        }
        
        guard let distanceVal = Int(distance!) else {
            searchState = SearchState.distanceError
            return
        }
        
        _zipCodes = [ZipCode]()
        searchState = SearchState.searching
        
        _searchedZipCode = String(zipCodeVal)
        
        zipCodeApi.getZipCodes(zipCode: zipCodeVal, distance: distanceVal, completionHandler: {(zipCodeResults) in
            DispatchQueue.main.async {
                self._zipCodes = zipCodeResults
                self.searchState = SearchState.completed
            }
        })
        
    }
}

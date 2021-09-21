//
//  SearchViewModel.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/20/21.
//

import Foundation

enum SearchState {
    case initialState
    case searching
    case completed
}

class SearchViewModel: ObservableObject {
    
    var zipCodeApi: ZipCodeApi?

    @Published var searchState: SearchState = SearchState.initialState
    
    @Published var filteredZipCodes: [ZipCode] = [ZipCode]()
    
    private var _searchedZipCode: Int = 0
    private var _searchedRadius: Int = 0
    
    private var _zipCodes = [ZipCode]() {
        didSet {
            filteredZipCodes = _zipCodes.filter {
                $0.zipCode != String(_searchedZipCode)
            }
        }
    }

    public init() {
        
        do {
            try zipCodeApi = ZipCodeApi()
        } catch {
            
        }
        
    }
    
    public func getZipCodes(zipCode: Int, radius: Int) {
        
        searchState = SearchState.searching
        
        _searchedZipCode = zipCode
        _searchedRadius = radius
        
        zipCodeApi?.getZipCodes(zipCode: zipCode, distance: radius, completionHandler: {(zipCodeResults) in
            DispatchQueue.main.async {
                self._zipCodes = zipCodeResults
                self.searchState = SearchState.completed
            }
        })
        
    }
}

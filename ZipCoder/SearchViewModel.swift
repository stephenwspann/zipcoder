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

    @Published var searchState: SearchState = SearchState.initialState
    
    @Published var zipCodes: [ZipCodeJson] = [ZipCodeJson]()
    
    public init() {
        
    }
}

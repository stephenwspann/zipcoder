//
//  SearchState.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/22/21.
//

import Foundation

enum SearchState {
    case initialState
    case zipCodeError
    case distanceError
    case searching
    case completed
}

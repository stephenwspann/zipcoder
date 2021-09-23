//
//  SearchViewModel.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/20/21.
//

import Foundation

class SearchViewModel {

    @Published var searchState: SearchState = SearchState.initialState
    @Published var filteredZipCodes: [ZipCode] = [ZipCode]()

    private var zipCodeApi = ZipCodeApi()
    private var searchedZipCode = ""
    private var zipCodes = [ZipCode]() {
        didSet {
            filteredZipCodes = zipCodes.filter {
                $0.zipCode != searchedZipCode
            }.sorted {
                $0.distanceSortable < $1.distanceSortable
            }
        }
    }

    private func zipCodeIsValid(_ zipCode: String) -> Bool {
        return zipCode.range(of: #"^[0-9]{5}$"#, options: .regularExpression) != nil
    }

    private func distanceIsValid(_ distance: String) -> Bool {
        
        guard let distanceValue = Int(distance) else {
            return false
        }
        // The API is capped at 500 miles (~805 km)
        return distanceValue > 0 && distanceValue <= 805
    }

    func getZipCodes(zipCode: String?, distance: String?) {
        
        // clear previous results on both errors and searches
        zipCodes = [ZipCode]()

        guard let zipCode = zipCode, zipCodeIsValid(zipCode) else {
            searchState = SearchState.zipCodeError
            return
        }

        guard let distance = distance, distanceIsValid(distance) else {
            searchState = SearchState.distanceError
            return
        }

        searchState = SearchState.searching
        searchedZipCode = zipCode

        zipCodeApi.getZipCodes(zipCode: zipCode, distance: distance, completion: { result in
            do {
                if let zipCodes = try result.get() {
                    DispatchQueue.main.async {
                        self.searchState = SearchState.completed
                        self.zipCodes = zipCodes
                    }
                }
            } catch ZipCodeApiError.invalidURL(let url) {
                let formatString = NSLocalizedString("ERROR_INVALID_URL_X", comment: "")
                print(String.localizedStringWithFormat(formatString, url))
                DispatchQueue.main.async {
                    self.searchState = SearchState.apiError
                }
            } catch ZipCodeApiError.unexpectedStatusCode(let statusCode) {
                let formatString = NSLocalizedString("ERROR_UNEXPECTED_STATUS_CODE_X", comment: "")
                print(String.localizedStringWithFormat(formatString, statusCode))
                DispatchQueue.main.async {
                    self.searchState = SearchState.apiError
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.searchState = SearchState.apiError
                }
            }
        })
    }
}

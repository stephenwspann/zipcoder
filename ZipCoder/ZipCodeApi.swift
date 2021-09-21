//
//  ZipCodeApi.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/20/21.
//

import Foundation

enum ZipCodeApiError: Error {
    case settingsFileNotFound
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

class ZipCodeApi {
    
    init() throws {
        if let path = Bundle.main.path(forResource: "app_settings", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let key = jsonResult["ZIP_CODE_API_KEY"] as? String {
                    print("key: " + key)
                } else {
                    print("something else happened?")
                }
            } catch {
                print("Unexpected error: \(error).")
            }
        } else {
            throw ZipCodeApiError.settingsFileNotFound
        }
    }
    
    /*
    
    // NOTE: API Keys should not be in Git repositories or source code,
    // including here to avoid errors publishing.
    var apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - Properties

    private static var shared: ZipCodeApi = {
        let networkManager = NetworkManager(baseURL: API.baseURL)
        return networkManager
    }()

    // MARK: -

    let baseURL: URL

    // Initialization

    private init(baseURL: URL) {
        self.baseURL = baseURL
    }

    // MARK: - Accessors

    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
 */
    
}

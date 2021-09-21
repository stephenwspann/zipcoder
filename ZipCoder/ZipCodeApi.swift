//
//  ZipCodeApi.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/20/21.
//

import Foundation

enum ZipCodeApiError: Error {
    case settingsFileNotFound
    case jsonMissingApiKey
    case jsonError
}

class ZipCodeApi {
    
    var apiKey: String
    
    init() throws {
        if let path = Bundle.main.path(forResource: "app_settings", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let key = jsonResult["ZIP_CODE_API_KEY"] as? String {
                    print("key: " + key)
                    apiKey = key
                } else {
                    throw ZipCodeApiError.jsonMissingApiKey
                }
            } catch {
                throw error
            }
        } else {
            throw ZipCodeApiError.settingsFileNotFound
        }
    }
    
    // format: https://www.zipcodeapi.com/rest/<api_key>/radius.<format>/<zip_code>/<distance>/<units>
    func getApiUrl(zipCode: Int, distance: Int) -> URL {
        let urlString = "https://www.zipcodeapi.com/rest/" + apiKey + "/radius.json/" + String(zipCode) + "/" + String(distance) + "/km"
        let url = URL(string: urlString)!
        return url
    }
    
    func getZipCodes(zipCode: Int, distance: Int, completionHandler: @escaping([ZipCodeJson]) -> Void) {
        let url = getApiUrl(zipCode: zipCode, distance: distance)
        
        print("get zip codes!")
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }

            if let zipData = data {

                do {
                    if let decodedResponse = try? JSONDecoder().decode(ZipCodeApiResponse.self, from: zipData) {
                        completionHandler(decodedResponse.zip_codes)
                    } else {
                        print("decode error 2")
                    }

                } catch let jsonError as NSError {
                    print("JSON decode failed: \(jsonError.localizedDescription)")
                }
            } else {
                print("decode error")
                
            }
        })
        
        task.resume()
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

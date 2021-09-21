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
    
    // Keep snake_case json key values contained in this class
    struct ZipCodeJson: Codable {
        let zip_code: String
        let distance: Float
        let city: String
        let state: String
    }

    struct ApiResponseJson: Codable {
        let zip_codes: [ZipCodeJson]
    }
    
    init() throws {
        if let path = Bundle.main.path(forResource: "app_settings", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let key = jsonResult["ZIP_CODE_API_KEY"] as? String {
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
    
    func getZipCodes(zipCode: Int, distance: Int, completionHandler: @escaping([ZipCode]) -> Void) {
        let url = getApiUrl(zipCode: zipCode, distance: distance)
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching api: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }

            if let zipData = data {

                if let decodedResponse = try? JSONDecoder().decode(ApiResponseJson.self, from: zipData) {
                    
                    // transform into a more iOS-friendly struct (camelCase)
                    let zipCodes = decodedResponse.zip_codes.map { zip in
                        ZipCode(zipCode: zip.zip_code, distance: zip.distance, city: zip.city, state: zip.state)
                    }
                    
                    completionHandler(zipCodes)
                    
                } else {
                    print("decode error 2")
                }

            } else {
                print("decode error")
                
            }
        })
        
        task.resume()
    }

}

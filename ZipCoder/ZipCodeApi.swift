//
//  ZipCodeApi.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/20/21.
//

import Foundation

class ZipCodeApi {
    
    // NOTE: It's not great to have API keys in the Git repository.
    // In production, this could be loaded from an external JSON file.
    let apiKey: String = "CGk1ezxPVm53prDhs1LExkQu6xOnYMkMfUtgkVZhXoTeLfQku9zaqdXTvANfY4YH"
    
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

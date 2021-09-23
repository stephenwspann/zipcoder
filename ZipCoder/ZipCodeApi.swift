//
//  ZipCodeApi.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/20/21.
//

import Foundation

// Keep snake_case json key values contained in this class
fileprivate struct ZipCodeJson: Codable {
    let zip_code: String
    let distance: Float
    let city: String
    let state: String
}

fileprivate struct ApiResponseJson: Codable {
    let zip_codes: [ZipCodeJson]
}

class ZipCodeApi {

    // NOTE: It's not great to have API keys in a Git repository.
    // In production, this could be loaded from an external JSON file.
    private let apiKey: String = "CGk1ezxPVm53prDhs1LExkQu6xOnYMkMfUtgkVZhXoTeLfQku9zaqdXTvANfY4YH"

    // format: https://www.zipcodeapi.com/rest/<api_key>/radius.<format>/<zip_code>/<distance>/<units>
    private func getApiUrlString(zipCode: String, distance: String) -> String {
        return "https://www.zipcodeapi.com/rest/" + apiKey + "/radius.json/" + zipCode + "/" + distance + "/km"
    }

    func getNearbyZipCodes(startingZipCode: String, distance: String, completion: @escaping(Result<[ZipCode]?,Error>) -> Void) {
        
        let urlString = getApiUrlString(zipCode: startingZipCode, distance: distance)

        guard let url = URL(string: urlString) else {
            completion(Result {
                throw ZipCodeApiError.invalidURL(url: urlString)
            })
            return
        }

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            completion(Result {
                
                if let error = error {
                    throw error
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ZipCodeApiError.invalidHttpResponse
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw ZipCodeApiError.unexpectedStatusCode(statusCode: httpResponse.statusCode)
                }
                
                guard let data = data else {
                    throw ZipCodeApiError.invalidData
                }
                
                guard let decodedResponse = try? JSONDecoder().decode(ApiResponseJson.self, from: data) else {
                    throw ZipCodeApiError.invalidJson
                }
                
                let zipCodes = decodedResponse.zip_codes.map { zip in
                    ZipCode(zipCode: zip.zip_code, distance: zip.distance, city: zip.city, state: zip.state)
                }
                
                return zipCodes
            
            })
        })

        task.resume()
    }

}

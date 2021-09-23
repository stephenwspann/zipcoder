//
//  ZipCodeApiError.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/22/21.
//

import Foundation

enum ZipCodeApiError: Error {
    case invalidURL(url: String)
    case unexpectedStatusCode(statusCode: Int)
    case invalidHttpResponse
    case invalidData
    case invalidJson
}

extension ZipCodeApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("ERROR_INVALID_URL_X", comment: "")
        case .unexpectedStatusCode:
            return NSLocalizedString("ERROR_UNEXPECTED_STATUS_CODE_X", comment: "")
        case .invalidHttpResponse:
            return NSLocalizedString("ERROR_INVALID_HTTP_RESPONSE", comment: "")
        case .invalidData:
            return NSLocalizedString("ERROR_INVALID_DATA", comment: "")
        case .invalidJson:
            return NSLocalizedString("ERROR_INVALID_JSON", comment: "")
        }
    }
}

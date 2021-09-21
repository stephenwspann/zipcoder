//
//  ZipCodeResult.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/20/21.
//

import Foundation

struct ZipCode: Codable {
    let zip_code: String
    let distance: Float
    let city: String
    let state: String
}

struct ZipCodeApiResponse: Codable {
    var zip_codes: [ZipCode]
}

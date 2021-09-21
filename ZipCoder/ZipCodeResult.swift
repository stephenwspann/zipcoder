//
//  ZipCodeResult.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/20/21.
//

import Foundation

// example result
// {"zip_code":"30312","distance":1.828,"city":"Atlanta","state":"GA"}

struct ZipCodeResult {
    let zipCode: UInt32
    let distance: Float
    let city: String
    let state: String
}

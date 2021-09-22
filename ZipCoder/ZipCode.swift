//
//  ZipCodeResult.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/20/21.
//

import Foundation

struct ZipCode {
    let zipCode: String
    let cityState: String
    let distance: String
    let distanceSortable: Float
    
    init(zipCode: String, distance: Float, city: String, state: String) {
        self.zipCode = zipCode
        self.cityState = city + ", " + state
        self.distance = String(distance) + " km"
        self.distanceSortable = distance
    }
}

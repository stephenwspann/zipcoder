//
//  UITextField+ErrorState.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/21/21.
//

import UIKit

public extension UITextField {
    
    func setErrorState(hasError: Bool) {
        if (hasError) {
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 1.0
        } else {
            layer.borderWidth = 1
            layer.borderColor = UIColor.clear.cgColor
        }
    }
    
}

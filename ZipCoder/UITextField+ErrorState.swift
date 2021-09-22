//
//  UITextField+ErrorState.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/21/21.
//

import UIKit

extension UITextField {
    
    public func setErrorState(hasError: Bool){
        
        if hasError {
            layer.borderWidth = 1
            layer.borderColor = UIColor.red.cgColor
            becomeFirstResponder()
        } else {
            layer.borderColor = UIColor.clear.cgColor
        }
    }
    
}

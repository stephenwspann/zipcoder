//
//  ZipCodeCell.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/21/21.
//

import SwiftUI

class ZipCodeCell: UITableViewCell {

    @IBOutlet var zipCode: UILabel!
    @IBOutlet var cityState: UILabel!
    @IBOutlet var distance: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

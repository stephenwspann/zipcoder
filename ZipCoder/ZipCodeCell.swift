//
//  ZipCodeCell.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/21/21.
//

import UIKit

class ZipCodeCell: UITableViewCell {

    @IBOutlet var zipCodeLabel: UILabel!
    @IBOutlet var cityStateLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!

    var zipCode: ZipCode? {
        didSet {
            if let zip = zipCode {
                zipCodeLabel.text = zip.zipCode
                cityStateLabel.text = zip.cityState
                distanceLabel.text = zip.distance
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

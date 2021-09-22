//
//  ViewController.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/20/21.
//

import UIKit
import Combine

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var instructionsLabel: UILabel!
    @IBOutlet var zipCodeField: UITextField!
    @IBOutlet var distanceField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var zipCodeTable: UITableView!
    
    private var viewModel: SearchViewModel! = SearchViewModel()
    
    private var _zipCodes = [ZipCode]()
    
    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // set up table
        zipCodeTable.delegate = self
        zipCodeTable.dataSource = self
        
        // localized strings
        instructionsLabel.text = NSLocalizedString("SEARCH_INSTRUCTIONS", comment: "")
        searchButton.setTitle(NSLocalizedString("SEARCH_BUTTON_LABEL", comment: ""), for: .normal)
        zipCodeField.placeholder = NSLocalizedString("ZIP_CODE_FIELD_PLACEHOLDER", comment: "")
        distanceField.placeholder = NSLocalizedString("DISTANCE_FIELD_PLACEHOLDER", comment: "")
        
        // observe model
        viewModel.$searchState.sink { searchState in
            switch(searchState) {
            case .initialState:
                self.resetFormErrors()
                self.setFormEnabled(enabled: true)
                self.messageLabel.text = ""
            case .zipCodeError:
                self.resetFormErrors()
                self.zipCodeField.setErrorState(hasError: true)
                self.messageLabel.text = NSLocalizedString("PLEASE_ENTER_VALID_ZIP", comment: "")
            case .distanceError:
                self.resetFormErrors()
                self.distanceField.setErrorState(hasError: true)
                self.messageLabel.text = NSLocalizedString("PLEASE_ENTER_VALID_DISTANCE", comment: "")
            case .searching:
                self.resetFormErrors()
                self.setFormEnabled(enabled: false)
                self.messageLabel.text = NSLocalizedString("FETCHING_RESULTS", comment: "")
            case .completed:
                self.resetFormErrors()
                self.setFormEnabled(enabled: true)
            }
        }.store(in: &cancellable)
 
        viewModel.$filteredZipCodes.sink { zipCodes in
            
            if (self.viewModel.searchState != .initialState) {
                self._zipCodes = zipCodes
                self.zipCodeTable.reloadData()
                if (zipCodes.count > 0) {
                    let formatString = NSLocalizedString("FOUND_X_RESULTS", comment: "")
                    self.messageLabel.text = String.localizedStringWithFormat(formatString, zipCodes.count)
                } else {
                    self.messageLabel.text = NSLocalizedString("NO_RESULTS_FOUND", comment: "")
                }
            }
        }.store(in: &cancellable)

        // add events
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        
    }
    
    func setFormEnabled(enabled: Bool) {
        zipCodeField.isEnabled = enabled
        distanceField.isEnabled = enabled
        searchButton.isEnabled = enabled
    }
    
    func resetFormErrors() {
        zipCodeField.setErrorState(hasError: false)
        distanceField.setErrorState(hasError: false)
    }
    
    @objc func searchTapped() {
        self.viewModel.getZipCodes(zipCode: zipCodeField.text, distance: distanceField.text)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _zipCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "zipCodeCell") as? ZipCodeCell {
            let zipCode = _zipCodes[indexPath.row]
            cell.zipCode.text = zipCode.zipCode
            cell.cityState.text = zipCode.city + ", " + zipCode.state
            cell.distance.text = String(zipCode.distance) + " km"
            return cell
        } else {
            // return empty cell, log error
            return UITableViewCell()
        }

    }


}


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
    @IBOutlet var zipCodeLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var zipCodeField: UITextField!
    @IBOutlet var distanceField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var zipCodeTable: UITableView!

    private var viewModel: SearchViewModel! = SearchViewModel()
    private var zipCodes = [ZipCode]()
    private var cancellable = Set<AnyCancellable>()

    // MARK: - UIViewController lifecycle methods

    override func viewDidLoad() {

        super.viewDidLoad()

        // set up table
        zipCodeTable.delegate = self
        zipCodeTable.dataSource = self

        // localized strings
        instructionsLabel.text = NSLocalizedString("SEARCH_INSTRUCTIONS", comment: "")
        zipCodeLabel.text = NSLocalizedString("ZIP_CODE_FIELD_LABEL", comment: "")
        distanceLabel.text = NSLocalizedString("DISTANCE_FIELD_LABEL", comment: "")
        searchButton.setTitle(NSLocalizedString("SEARCH_BUTTON_LABEL", comment: ""), for: .normal)
        
        // accessibility labels
        zipCodeField.accessibilityLabel = NSLocalizedString("ZIP_CODE_FIELD_LABEL", comment: "")
        distanceField.accessibilityLabel = NSLocalizedString("DISTANCE_FIELD_LABEL_ACCESSIBLE", comment: "")

        // observe model
        viewModel.$searchState.sink { searchState in

            // default state
            self.resetFormErrors()
            self.setFormEnabled(true)

            switch(searchState) {
            case .initialState:
                self.messageLabel.text = ""
            case .zipCodeError:
                self.zipCodeField.hasError(true)
                self.messageLabel.text = NSLocalizedString("PLEASE_ENTER_VALID_ZIP", comment: "")
            case .distanceError:
                self.distanceField.hasError(true)
                self.messageLabel.text = NSLocalizedString("PLEASE_ENTER_VALID_DISTANCE", comment: "")
            case .apiError:
                self.messageLabel.text = NSLocalizedString("API_ERROR_MESSAGE", comment: "")
            case .searching:
                self.setFormEnabled(false)
                self.messageLabel.text = NSLocalizedString("FETCHING_RESULTS", comment: "")
            case .completed:
                break
            }
        }.store(in: &cancellable)

        viewModel.$filteredZipCodes.sink { zipCodes in

            if self.viewModel.searchState == .completed {
                self.zipCodes = zipCodes
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

    private func setFormEnabled(_ enabled: Bool) {
        zipCodeField.isEnabled = enabled
        distanceField.isEnabled = enabled
        searchButton.isEnabled = enabled
    }

    private func resetFormErrors() {
        zipCodeField.hasError(false)
        distanceField.hasError(false)
    }

    @objc func searchTapped() {
        self.viewModel.getZipCodes(zipCode: zipCodeField.text, distance: distanceField.text)
    }

    // MARK: - UITableViewDataSource methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zipCodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "zipCodeCell") as? ZipCodeCell {
            cell.zipCode = zipCodes[indexPath.row]
            cell.selectionStyle = .none
            return cell
        } else {
            // return an empty cell
            return UITableViewCell()
        }

    }


}


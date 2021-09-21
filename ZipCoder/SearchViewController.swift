//
//  ViewController.swift
//  ZipCoder
//
//  Created by Stephen Spann on 9/20/21.
//

import UIKit
import Combine

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var zipCodeApi: ZipCodeApi?
    
    var viewModel: SearchViewModel! = SearchViewModel()
    
    @IBOutlet var zipCodeField: UITextField!
    @IBOutlet var distanceField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var zipCodeTable: UITableView!
    
    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        zipCodeTable.delegate = self
        zipCodeTable.dataSource = self
        
        do {
            try zipCodeApi = ZipCodeApi()
        } catch {
            
        }
        
        
        viewModel.$searchState.sink { searchState in
            switch(searchState) {
            case .initialState:
                self.zipCodeField.isEnabled = true
                self.distanceField.isEnabled = true
                self.searchButton.isEnabled = true
            case .searching:
                self.zipCodeField.isEnabled = false
                self.distanceField.isEnabled = false
                self.searchButton.isEnabled = false
            case .completed:
                self.zipCodeField.isEnabled = true
                self.distanceField.isEnabled = true
                self.searchButton.isEnabled = true
            }
        }.store(in: &cancellable)
 

        
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        
        viewModel.$zipCodes.sink { zipCodes in
            DispatchQueue.main.async {
                self.zipCodeTable.reloadData()
            }
        }.store(in: &cancellable)
        
    }
    
    @objc func searchTapped() {
        zipCodeApi?.getZipCodes(zipCode: 30308, distance: 5, completionHandler: {(zipCodeResults) in
            self.viewModel.zipCodes = zipCodeResults
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.zipCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "zipCodeCell") as? ZipCodeCell {
            let zipCode = viewModel.zipCodes[indexPath.row]
            cell.zipCode.text = zipCode.zipCode
            cell.cityState.text = zipCode.city + ", " + zipCode.state
            cell.distance.text = String(zipCode.distance) + " km"
            return cell
        }
        
        // return empty cell on error
        return UITableViewCell()
    }


}


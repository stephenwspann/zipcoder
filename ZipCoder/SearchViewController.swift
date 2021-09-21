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
    
    var zipCodes: [ZipCodeJson] = [ZipCodeJson]()
    
    var viewModel: SearchViewModel! = SearchViewModel()
    
    @IBOutlet var zipCodeField: UITextField!
    @IBOutlet var distanceField: UITextField!
    @IBOutlet var searchButton: UIButton!
    

    private var cancellable = Set<AnyCancellable>()
    
    @IBOutlet var zipCodeTable: UITableView!

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
        
        /*
        garminDriver.$devices.sink { newDevices in
            // need an order for the table
            self.garminDevices = Array(newDevices.values)
        }.store(in: &cancellable)
 */
    }
    
    @objc func searchTapped() {
        zipCodeApi?.getZipCodes(zipCode: 30308, distance: 5, completionHandler: {(zipCodeResults) in
            
            self.zipCodes = zipCodeResults
            
            DispatchQueue.main.async {
                self.zipCodeTable.reloadData()
            }
            
            //for zip in zipCodeResults {
            //    print(zip.zip_code)
            //}
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zipCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "zipCodeCell") as? ZipCodeCell {
            let zipCode = zipCodes[indexPath.row]
            cell.zipCode.text = zipCode.zip_code
            cell.cityState.text = zipCode.city + ", " + zipCode.state
            cell.distance.text = String(zipCode.distance) + " km"
            return cell
        }

        return UITableViewCell()
    }


}


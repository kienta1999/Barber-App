//
//  EditProfileBarberViewController.swift
//  BarberApp
//
//  Created by admin on 4/11/22.
//

import UIKit
import FirebaseStorage
import MapKit

// https://www.jeffedmondson.dev/blog/swift_location_search/
class EditProfileBarberViewController: EditProfileViewController, MKLocalSearchCompleterDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressSearchBar: UISearchBar!
    @IBOutlet weak var searchResultsTable: UITableView!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var address: Address?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        addressSearchBar.delegate = self
        searchResultsTable?.delegate = self
        searchResultsTable?.dataSource = self

        if let phone = user?.phoneNumber{
            phoneTextField.text = String(phone)
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }

    private func completer(completer: MKLocalSearchCompleter, didFailWithError error: NSError) {
        errorMessage.text = error.localizedDescription
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
        searchResultsTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]

        //Create  a new UITableViewCell object
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

        //Set the content of the cell to our searchResult data
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)

            let result = searchResults[indexPath.row]
            let searchRequest = MKLocalSearch.Request(completion: result)

            let search = MKLocalSearch(request: searchRequest)
        
        self.saveProfileBtn.isHidden = true
        self.errorMessage.text = "Searching for location...."
            search.start { (response, error) in
                if let err = error {
                    self.errorMessage.text = err.localizedDescription
                    self.saveProfileBtn.isHidden = false
                    self.addressSearchBar.text = ""
                    return
                    
                }
                guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                    return
                }

                guard let name = response?.mapItems[0].name else {
                    return
                }

                let lat = coordinate.latitude
                let lon = coordinate.longitude

                self.errorMessage.text = ""
                self.saveProfileBtn.isHidden = false
                
                self.address = Address.init(self.user!.id!, result.title)
                self.address?.lat = lat
                self.address?.lon = lon
                self.address?.subtitile = result.subtitle
            }
        }
    
    func saveAddress(){
        if let address = address {
            print("------------------------------------")
            print(address)
            address.saveToDatabase { (err) in
                print("------------------------------------")
                print(err?.localizedDescription)
                self.errorMessage.text = err?.localizedDescription
            }
        }
    }

}

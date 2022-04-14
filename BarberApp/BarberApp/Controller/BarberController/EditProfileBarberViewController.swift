//
//  EditProfileBarberViewController.swift
//  BarberApp
//
//  Created by admin on 4/11/22.
//

import UIKit
import FirebaseStorage
import MapKit

class EditProfileBarberViewController: EditProfileViewController, MKLocalSearchCompleterDelegate, UISearchBarDelegate {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressSearchBar: UISearchBar!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        addressSearchBar.delegate = self

        if let phone = user?.phoneNumber{
            phoneTextField.text = String(phone)
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            searchResults = completer.results
            print(searchResults)
        }

    private func completer(completer: MKLocalSearchCompleter, didFailWithError error: NSError) {
            // handle error
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    @IBAction func seeAddress(_ sender: UIButton) {
        print(searchResults)
    }
    
    
    

}

//
//  LocationViewController.swift
//  BarberApp
//
//  Created by admin on 2/18/22.
// used iOS Academy as reference
import CoreLocation
import MapKit
import Firebase
import UIKit

class LocationViewController: HomepageViewController, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

   
    }
      
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            render(location)
        }
        Address.getAllAddress { (data, error) in
            if let data = data {
                print(data)
            }
            for address in data!{
                let addressTitle = String(describing: address["title"]!)
                let addressLat = address["lat"] as! Double
                let addressLon = address["lon"] as! Double
                let addressCoord = CLLocation(latitude: addressLat, longitude: addressLon)
                let addressSubtitle = String(describing: address["subtitile"]!)
    
                let currentCoordinate = CLLocation(latitude: locations.first?.coordinate.latitude ?? 0.0, longitude: locations.first?.coordinate.longitude ?? 0.0)
                
                let addressPin = MKPointAnnotation()
                addressPin.coordinate = CLLocationCoordinate2D(latitude: addressLat, longitude: addressLon)
                addressPin.title = addressTitle
                addressPin.subtitle = addressSubtitle
                //addressPin.userId = addressUserId
                let distanceInMeter = currentCoordinate.distance(from: addressCoord)
                print(distanceInMeter)
                //within 10 miles
                if(distanceInMeter < 16090){
                self.mapView.addAnnotation(addressPin)
                }
                else{
                    continue
                }
            }
        
    }
    }
    func render(_ location: CLLocation){
        let currentCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        //let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        
        let region = MKCoordinateRegion(center: currentCoordinate, latitudinalMeters: 600, longitudinalMeters: 600)
        mapView.setRegion(region, animated: true)
        
        let currentLocation = MKPointAnnotation()

        currentLocation.coordinate = currentCoordinate
        currentLocation.title = "My Location"
        
        
        mapView.addAnnotation(currentLocation)
        }
    
        

    }
    //stack overflow callout
    class CustomAnnotationView: MKPinAnnotationView {

        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

            canShowCallout = true
            rightCalloutAccessoryView = UIButton(type: .infoLight)

            let rightCalloutButton = rightCalloutAccessoryView as? UIButton
            rightCalloutButton?.addTarget(self, action: #selector(goToBarberProfile), for: .touchUpInside)
            

        }
//        var barberProfile: [String : Any] = [:]{
//
//        }
        @objc func goToBarberProfile(_ sender: UIButton! ){
            //print("go to profile \((annotation?.title))")
            Firestore.firestore().collection("addresses")
                .whereField(Collection.Address.title, isEqualTo: annotation?.title)
                .whereField(Collection.Address.subtitile, isEqualTo: annotation?.subtitle)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        return
                    }
                    if querySnapshot!.documents.count >= 1 {
                        var barberProfileId = querySnapshot!.documents[0].data()["userid"]
                  
//                        let profileUser = User.init(
//                                    id: barberProfile["id"] as? String,
//                                    firstname: barberProfile["firstname"] as? String,
//                                    lastname: barberProfile["lastname"] as? String,
//                                    email: barberProfile["email"] as! String,
//                                    password: barberProfile["password"] as! String,
//                                    role: barberProfile["role"] as? String,
//                                    age: barberProfile["age"] as? Int,
//                                    gender: barberProfile["gender"] as? String,
//                                    bio: barberProfile["bio"] as? String,
//                                    profilePicPath: barberProfile["profilePicPath"] as? String,
//                                    phoneNumber: barberProfile["phoneNumber"] as? Int
//                                )
//                                if(profileUser.role == "Barber"){
//                                    let profileVc = storyboard?.instantiateViewController(identifier: StoryBoard.Barber.profileVC) as! ProfileBarberViewController
//                                    profileVc.user = currentUser
//                                    profileVc.profileUser = profileUser
//                                    profileVc.editAllow = false
//                                    navigationController?.pushViewController(profileVc, animated: true)
//                                }
//                                else if (profileUser.role == "Client"){
//                                    let profileVc = storyboard?.instantiateViewController(identifier: StoryBoard.Client.profileVC) as! ProfileClientViewController
//                                    profileVc.user = currentUser
//                                    profileVc.profileUser = profileUser
//                                    profileVc.editAllow = false
//                                    navigationController?.pushViewController(profileVc, animated: true)
//                                }
                        print(querySnapshot!.documents[0].data()["userid"])
                        //print(barberProfile)
                        
                    }
            }
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? ProfileBarberViewController,
//            let annotationView = sender as? MKPinAnnotationView {
//            destination.annotation = annotationView.annotation as? MKPointAnnotation
//        }
//    }



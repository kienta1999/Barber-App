//
//  LocationViewController.swift
//  BarberApp
//
//  Created by admin on 2/18/22.
// used iOS Academy as reference
import CoreLocation
import MapKit
import UIKit

class LocationViewController: HomepageViewController, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
    }
    func render(_ location: CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        //let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 600, longitudinalMeters: 600)
        mapView.setRegion(region, animated: true)
        
        let currentLocation = MKPointAnnotation()

        currentLocation.coordinate = coordinate
        
        
        
        let barber2 = MKPointAnnotation()
        barber2.coordinate = CLLocationCoordinate2D(latitude: 38.625141, longitude: -90.188766)
        mapView.addAnnotation(currentLocation)
        
        mapView.addAnnotation(barber2)
        addCustomPin()
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        func mapViewTransition(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            performSegue(withIdentifier: "AnnotationToBarber", sender: view)
        }

    }
    //stack overflow callout
    class CustomAnnotationView: MKPinAnnotationView {  // or nowadays, you might use MKMarkerAnnotationView
        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

            canShowCallout = true
            rightCalloutAccessoryView = UIButton(type: .infoLight)
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
    private func addCustomPin() {
        let barber1 = MKPointAnnotation()
        barber1.coordinate = CLLocationCoordinate2D(latitude: 38.625610, longitude: -90.187347)
        barber1.title = "Kevin's Barbershop"
        barber1.subtitle = "Rating: 4.5/5 Price:$ Distance: 6.1 miles"
        mapView.addAnnotation(barber1)
        
    }
}

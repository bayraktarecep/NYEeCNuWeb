//
//  PopUpViewController.swift
//  NYEeCNuWeb
//
//  Created by Recep Bayraktar on 11.04.2021.
//

import UIKit
import MapKit
import CoreLocation
import Kingfisher

let client_id = "XI4MQIPHQM1TV5JWMZ2XP0DP2G01T3H1M5EVHVI0LCWYJ0VM"
let client_secret = "ASMRSHIQHAIU304YW2N4XASXEQALOD0SWDL50PZFGUOLZM4C"

class PopUpViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Outlets
    var id: String = ""
    var name: String = ""
    var latitude: Double?
    var longitude: Double?
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    
    var manager = CLLocationManager()
    var requestCLLocation = CLLocation()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Place id = \(id as Any) name = \(name as Any) and coordinates= \(latitude as Any),\(longitude as Any)")
        
        mapView.delegate = self
        
        nameLabel.text = self.name
        
        setMapViewAnnotation()
        loadData()
        
        //MARK: - POPUP View settings
        popUpView.layer.cornerRadius = 25
        popUpView.layer.shadowColor = UIColor.black.cgColor
        popUpView.layer.shadowRadius = 8.0
        popUpView.layer.shadowOpacity = 0.7
    }
    //MARK: - Load Data with Venue ID
    func loadData() {
        guard let tipsURL = URL(string: "https://api.foursquare.com/v2/venues/" + self.id + "/tips?client_id=\(client_id)&client_secret=\(client_secret)&v=20200411") else {
            print("Invalid URL")
            return
        }
        print(tipsURL)
        
        let request = URLRequest(url: tipsURL)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let tipsResponse = try? JSONDecoder().decode(TipsVenues.self, from: data) {
                    DispatchQueue.main.async {
                        //TODO: After kingfisher uploaded, tips not shown properly, check 
                        self.tipsLabel.text = tipsResponse.response?.tips?.items?.first.map{$0.text ?? ""}
                        self.imageView.kf.indicatorType = .activity
                        //self.imageView.kf.setImage(with: URL(string: tipsResponse.response?.tips?.items?.first.map{($0.photourl ?? "")} ?? ""))
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown Error")")
        }.resume()
    }
    
    //MARK: - Map View Settings
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .systemRed
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.latitude != 0 && self.longitude != 0 {
            self.requestCLLocation = CLLocation(latitude: self.latitude!, longitude: self.longitude!)
        }
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placesmark = placemarks {
                if placesmark.count > 0 {
                    let newPlacesmark = MKPlacemark(placemark: placesmark[0])
                    let item = MKMapItem(placemark: newPlacesmark)
                    item.name = self.nameLabel.text
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
        }
    }
    
    func setMapViewAnnotation() {
        let location = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.mapView.addAnnotation(annotation)
        annotation.title = self.nameLabel.text
    }
    
    
    //MARK: - Close PopUp from Superview
    @IBAction func closePopUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

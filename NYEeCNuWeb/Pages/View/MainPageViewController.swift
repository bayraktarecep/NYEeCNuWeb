//
//  MainPageViewController.swift
//  NYEeCNuWeb
//
//  Created by Recep Bayraktar on 9.04.2021.
//

import UIKit
import CoreLocation

class MainPageViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    var locationManager = CLLocationManager()
    var currentLocation: String?
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Place text field letter set
        self.placeTextField.delegate = self
        
        //MARK: - Get long and latitude information from the user.
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        if placeTextField.text != "" && locationTextField.text != "" {
            if placeTextField.text!.count >= 3 {
                let placesVC = storyboard?.instantiateViewController(identifier: "Places") as? PlacesViewController
                placesVC?.place = placeTextField.text
                placesVC?.city = locationTextField.text
                self.navigationController?.pushViewController(placesVC!, animated: true)
            } else if placeTextField.text != "" && locationTextField.text == "" {
                let placesVC = storyboard?.instantiateViewController(identifier: "Places") as? PlacesViewController
                placesVC?.currentLocation = self.currentLocation
                self.navigationController?.pushViewController(placesVC!, animated: true)
            } else {
            
                let alert = UIAlertController(title: "Error", message: "Place description shlould contain min. 3 letters. ", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter a city. ", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Location Autorization Check
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValues: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.currentLocation = "\(locationValues.latitude),\(locationValues.longitude)"
        print(self.currentLocation as Any)
    }
    
    //MARK: - Place textfield only accept letters
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.letters
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}


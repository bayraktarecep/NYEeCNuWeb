//
//  PlacesViewController.swift
//  NYEeCNuWeb
//
//  Created by Recep Bayraktar on 10.04.2021.
//

import UIKit
import MapKit
import CoreLocation

class PlacesViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //MARK: - Outlets
    var city: String?
    var place: String?
    var id: String?
    var currentLocation: String?
    var viewModel = VenuesViewModel()
    var choosedPlaces: VenueElements!
    @IBOutlet weak var tableView: UITableView!
 
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(String(describing: self.city)) and \(String(describing: place))")
        
        //MARK: - Auto Resizing TableViewCell
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        
        loadData()
    }
    
    func loadData() {
        viewModel.onErrorResponse = { error in
            self.showAlert(message: error)
        }
        viewModel.onSuccessResponse = {
            self.tableView.reloadData()
        }
        viewModel.fetchData(city: self.city!, place: self.place!)
    }
        
    //MARK: - Error Alert Response
    func showAlert(title: String = "Something went Wrong", message: String = "Can't access the source"){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - TableView Delegate and DataSource

extension PlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.venue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlacesTableViewCell
        cell.loadWith(data: viewModel.venue[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popUpViewController = storyboard?.instantiateViewController(identifier: "PopUpMenu") as? PopUpViewController
        self.choosedPlaces = viewModel.venue[indexPath.row]
        //print(self.choosedPlaces as Any)
        print(self.choosedPlaces.id as Any)
        popUpViewController?.id = self.choosedPlaces.id
        popUpViewController?.name = self.choosedPlaces.name
        popUpViewController?.latitude = self.choosedPlaces.location.lat
        popUpViewController?.longitude = self.choosedPlaces.location.lng
        
        self.present(popUpViewController!, animated: true, completion: nil)
    }
}

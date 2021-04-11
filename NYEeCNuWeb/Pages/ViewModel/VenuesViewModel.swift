//
//  VenuesViewModel.swift
//  NYEeCNuWeb
//
//  Created by Recep Bayraktar on 9.04.2021.
//

import Foundation

class VenuesViewModel {
    
    var onSuccessResponse: (()->())?
    var onErrorResponse: ((String)->())?
    
    private var client_id = "XI4MQIPHQM1TV5JWMZ2XP0DP2G01T3H1M5EVHVI0LCWYJ0VM"
    private var client_secret = "ASMRSHIQHAIU304YW2N4XASXEQALOD0SWDL50PZFGUOLZM4C"
    private var components = URLComponents(string: "https://api.foursquare.com/v2/venues/search")
    private var versioning = "20210410"
    
    var venue: [VenueElements] = []
    
    func fetchData(city: String, place: String) {
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: String(client_id)),
            URLQueryItem(name: "client_secret", value: String(client_secret)),
            URLQueryItem(name: "near", value: String(city)),
            URLQueryItem(name: "query", value: String(place)),
            URLQueryItem(name: "v", value: String(versioning))
        ]
        print(components?.url! as Any)
        
        let request = URLRequest(url: (components?.url!)!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            DispatchQueue.main.async {
                if response.statusCode == 200 {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let response = try decoder.decode(VenueModel.self, from: data)
                            self.venue = response.response.venues
                            self.onSuccessResponse?()
                        } catch let error {
                            self.onErrorResponse?("Not a valid JSON Response with Error: \(error)")
                            print(error)
                        }
                    } else {
                        self.onErrorResponse?("HTTP Status: \(response.statusCode)")
                    }
                }
            }
        }
        task.resume()
    }
}

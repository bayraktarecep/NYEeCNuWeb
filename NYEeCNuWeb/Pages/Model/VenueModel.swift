//
//  VenueModel.swift
//  NYEeCNuWeb
//
//  Created by Recep Bayraktar on 9.04.2021.
//

import Foundation

// MARK: - VenueModel
struct VenueModel: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let venues: [VenueElements]
}

// MARK: - Venue
struct VenueElements: Codable {
    let id: String
    let name: String
    let location: Location
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
    }
    
}

// MARK: - Location
struct Location: Codable {
    let address: String?
    let lat: Double
    let lng: Double
    let city: String?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case address
        case lat
        case lng
        case city
        case country
    }
}

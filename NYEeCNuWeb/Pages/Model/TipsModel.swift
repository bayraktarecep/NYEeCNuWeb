//
//  TipsModel.swift
//  NYEeCNuWeb
//
//  Created by Recep Bayraktar on 11.04.2021.
//

import Foundation

// MARK: - TipsVenues
struct TipsVenues: Codable {
    let response: TipsResponse?
    
    enum CodingKeys: String, CodingKey {
        case response = "response"
    }
    
    init(from decoder: Decoder) throws {
        response = try! TipsResponse(from: decoder)
    }
}

// MARK: - Tips Response
struct TipsResponse: Codable {
    let tips: Tip?
    
    enum CodingKeys: String, CodingKey {
        case tips = "tips"
    }
    
    init(from decoder: Decoder) throws {
        tips = try! Tip(from: decoder)
    }
}

// MARK: - Tips
struct Tip: Codable {
    let count: Int?
    let items: [Item]?
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        items = try values.decodeIfPresent([Item].self, forKey: .items)
    }
}

// MARK: - Item
struct Item: Codable {
    let text: String?
    let photourl : String?
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case photourl = "photourl"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        photourl = try values.decodeIfPresent(String.self, forKey: .photourl)
        text = try values.decodeIfPresent(String.self, forKey: .text)
    }
}

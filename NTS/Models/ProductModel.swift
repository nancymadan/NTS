//
//  ProductModel.swift
//  NTS
//
//  Created by Abhishek Rana on 02/10/18.
//  Copyright © 2018 NancyM. All rights reserved.
//

import UIKit

struct Response: Codable {
    let products: [Product]
}

struct Product: Codable {
    let name, price: String
    let imageURL: String
    let rating: Int
    
    enum CodingKeys: String, CodingKey {
        case name, price
        case imageURL = "image_url"
        case rating
    }
}

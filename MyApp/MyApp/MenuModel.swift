//
//  MenuModel.swift
//  MyApp
//
//  Created by Rawand Rzgar on 2023-09-22.
//

import Foundation

struct JSONMenu: Codable {
    let menu: [MenuItem]
}

struct MenuItem: Codable, Identifiable {
    var id = UUID()
    let title: String
    let desc: String
    let price: String
    let image: String
    let category: String
    var imageData: Data?
    
    private enum CodingKeys: String, CodingKey {
        case  title, price, image, category,imageData
        case desc = "description"
    }
}

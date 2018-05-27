//
//  Item.swift
//  iBeaconRanger
//

import UIKit

class Items: Codable {
    let items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
}

class Item: Codable {
    let name, price, stock, image:  String
    
    init(name: String, price: String, stock: String, image: String) {
        self.name = name
        self.price = price
        self.stock = stock
        self.image = image
    }
}


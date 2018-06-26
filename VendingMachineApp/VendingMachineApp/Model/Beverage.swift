//
//  Beverage.swift
//  VendingMachineApp
//
//  Created by moon on 2018. 6. 23..
//  Copyright © 2018년 moon. All rights reserved.
//

import Foundation

class Beverage: NSObject {
    private let name: String
    private let price: Int
    
    init(name: String, price: Int) {
        self.name = name
        self.price = price
    }
    
    override required init() {
        self.name = DefaultData.beverage.name
        self.price = DefaultData.beverage.price
    }
    
    override var description: String {
        return "\(self.name)"
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Beverage {
            return ObjectIdentifier(type(of: self)) == ObjectIdentifier(type(of: object))
        } else {
            return false
        }
    }
}
//
//  Cantata.swift
//  VendingMachineApp
//
//  Created by kimdo2297 on 2020/03/04.
//  Copyright © 2020 Jason. All rights reserved.
//

import Foundation

class Cantata: Coffee {
    
    override init?(brand: String, volume: Int, price: Int,
                  name: String, dateInfo: String) {
        super.init(brand: brand, volume: volume, price: price,
                   name: name, dateInfo: dateInfo)
    }
    
    convenience init?(volume: Int, price:Int, name: String, dateInfo: String) {
        self.init(brand: "칸타타", volume: volume, price: price,
                  name: name,dateInfo: dateInfo)
    }
    
}
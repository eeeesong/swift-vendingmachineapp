//
//  ViewController.swift
//  VendingMachineApp
//
//  Created by Chaewan Park on 2020/02/27.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let vendingMachine = VendingMachine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [StrawberryMilk(), Fanta(), Top()]
            .forEach { vendingMachine.fill(beverage: $0) }
        
        print(vendingMachine.stockList)
    }
}


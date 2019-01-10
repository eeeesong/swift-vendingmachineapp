//
//  File.swift
//  VendingMachineApp
//
//  Created by 윤지영 on 08/01/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import Foundation

struct VendingMachineArchiver {

    enum ArchivingError: Error {
        case noData
        case notLoaded
    }

    private enum Keys: String {
        case vendingMachine = "vendingMachine"
    }

    static func archive() {
        let vendingMachine = VendingMachine.shared
        let vendingMachineEncoded = try? NSKeyedArchiver.archivedData(
            withRootObject: vendingMachine,
            requiringSecureCoding: false)
        UserDefaults.standard.set(vendingMachineEncoded, forKey:Keys.vendingMachine.rawValue)
    }

    static func load() throws -> VendingMachine {
        guard let data = UserDefaults.standard.data(forKey: Keys.vendingMachine.rawValue) else { throw ArchivingError.noData }
        guard let vendingMachine = try NSKeyedUnarchiver
            .unarchiveTopLevelObjectWithData(data) as? VendingMachine else { throw ArchivingError.notLoaded }
        return vendingMachine
    }

}
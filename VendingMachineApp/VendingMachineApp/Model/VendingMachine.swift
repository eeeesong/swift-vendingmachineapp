//
//  VendingMachine.swift
//  VendingMachineApp
//
//  Created by Song on 2021/02/24.
//

import Foundation

class VendingMachine: NSObject, NSCoding {
    
    private var storage: Storage
    private var dispensedList: OrderableList
    private var moneyBox: MoneyManagable
    private var beverageManager: FoodManagable
    private let beverageFactory: BeverageFactory
    
    static let itemTypes: [Shopable.Type] = [Americano.self,
                                             CafeLatte.self,
                                             Chocolate.self,
                                             Coke.self,
                                             Milkis.self,
                                             Plain.self]
    
    init(storage: Storage, dispensedList: OrderableList, moneyBox: MoneyManagable, beverageManager: FoodManagable, beverageFactory: BeverageFactory) {
        self.storage = storage
        self.dispensedList = dispensedList
        self.moneyBox = moneyBox
        self.beverageManager = beverageManager
        self.beverageFactory = beverageFactory
    }
    
    enum ArchiveKeys {
        static let storage = "storage"
        static let dispensedList = "dispensedList"
        static let moneyBox = "moneyBox"
    }
    
    required init?(coder: NSCoder) {
        self.storage = coder.decodeObject(forKey: ArchiveKeys.storage) as? Storage ?? BeverageStorage()
        self.dispensedList = coder.decodeObject(forKey: ArchiveKeys.dispensedList) as? OrderableList ?? DispensedList()
        self.moneyBox = coder.decodeObject(forKey: ArchiveKeys.moneyBox) as? MoneyManagable ?? MoneyBox()
        beverageManager = BeverageManager(temperatureStandard: BeverageManager.Standards.temperature,
                                          sugarStandard: BeverageManager.Standards.sugar,
                                          lactoStandard: BeverageManager.Standards.lactose)
        beverageFactory = BeverageToday()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(storage, forKey: ArchiveKeys.storage)
        coder.encode(dispensedList, forKey: ArchiveKeys.dispensedList)
        coder.encode(moneyBox, forKey: ArchiveKeys.moneyBox)
    }
    
    enum NotiKeys {
        static let stockListUpdate = Notification.Name("stockListUpdate")
        static let balanceUpdate = Notification.Name("balanceUpdate")
        static let dispensdListUpdate = Notification.Name("dispensedListUpdate")
    }
}

extension VendingMachine: CommonInterface {
    
    func allStocks() -> [ObjectIdentifier: Int] {
        return storage.listTypeCount()
    }
}

extension VendingMachine: UserInterface {
    
    func insert(money: Int) {
        moneyBox.update(amount: money)
        NotificationCenter.default.post(name: NotiKeys.balanceUpdate, object: self)
    }

    func moneyLeft() -> Int {
        return moneyBox.balance()
    }
    
    func buy(itemType: Shopable.Type) {
        guard let itemToSell = storage.pullOut(itemType) else { return }
        
        guard itemToSell.isPurchashable(with: moneyLeft()) else {
            addStock(of: itemType)
            return
        }
        
        NotificationCenter.default.post(name: NotiKeys.stockListUpdate, object: self)
        
        dispensedList.push(item: itemToSell)
        NotificationCenter.default.post(name: NotiKeys.dispensdListUpdate, object: self)
        
        let moneyAfterPurchase = itemToSell.subtractPrice(from: moneyLeft())
        moneyBox.update(to: moneyAfterPurchase)
        NotificationCenter.default.post(name: NotiKeys.balanceUpdate, object: self)
    }
    
    func purchased() -> [Shopable] {
        return dispensedList.listByOrder()
    }
}

extension VendingMachine: WorkerInterface {
    
    func addStock(of itemType: Shopable.Type) {
        let beverageType = itemType as? Beverage.Type ?? Beverage.self
        storage.add(beverageFactory.create(type: beverageType))
        NotificationCenter.default.post(name: NotiKeys.stockListUpdate, object: self)
    }
}

extension VendingMachine: Curatable {
    
    func affordables() -> [ObjectIdentifier] {
        return moneyBox.affordables(fromItemsIn: storage)
    }
    
    func expiredItems() -> [ObjectIdentifier: [Shopable]] {
        return beverageManager.expiredItems(fromItemsIn: storage)
    }
    
    func hotItems() -> [ObjectIdentifier] {
        return beverageManager.hotItems(fromItemsIn: storage)
    }
    
    func transportables() -> [ObjectIdentifier] {
        return beverageManager.transportables(fromItemsIn: storage)
    }
    
    func healthyItems() -> [ObjectIdentifier] {
        return beverageManager.healthyItems(fromItemsIn: storage)
    }
}

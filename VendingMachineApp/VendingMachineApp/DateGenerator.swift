//
//  DateGenerator.swift
//  VendingMachineApp
//
//  Created by Song on 2021/02/23.
//

import Foundation

struct DateGenerator {
    
    static let now = Date()
    
    static func randomDate() -> Date {
        let randomDate = Calendar.current.date(byAdding: .day,
                                               value: Int.random(in: -10...0),
                                               to: now)
        return randomDate ?? now
    }
}

extension Date {
    var description: String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        formatter.dateFormat = "yyMMdd"
        
        return formatter.string(from: self)
    }
}
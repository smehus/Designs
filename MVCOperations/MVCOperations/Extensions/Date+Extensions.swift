//
//  Date+Extensions.swift
//  MVCOperations
//
//  Created by scott mehus on 12/22/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation


extension Date {
    var dayBefore: Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    
    var dayAfter: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    
    func day(fromInterval interval: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: interval, to: self)
    }
}

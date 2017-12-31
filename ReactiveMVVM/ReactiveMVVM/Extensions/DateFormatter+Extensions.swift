//
//  DateFormatter+Extensions.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/27/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var apodFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(abbreviation: "PST")
        return formatter
    }
}

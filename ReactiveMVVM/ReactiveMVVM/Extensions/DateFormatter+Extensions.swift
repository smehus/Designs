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
        return formatter
    }
}

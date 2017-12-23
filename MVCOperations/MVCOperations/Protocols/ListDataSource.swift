//
//  ListDataSource.swift
//  MVCOperations
//
//  Created by scott mehus on 12/22/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

protocol ListDataSource {
    associatedtype DataType
    var numberOfSections: Int { get }
    func numberOfRows(for section: Int) -> Int
    func item(at indexPath: IndexPath) -> DataType?
}

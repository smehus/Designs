//
//  ListDataSource.swift
//  MVCOperations
//
//  Created by scott mehus on 12/22/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

protocol ListDataSource {
    associatedtype DataType
    var numberOfSections: Int { get }
    func numberOfRows(for section: Int) -> Int
    func item(at indexPath: IndexPath) -> DataType?
}

struct AnyListDataSource<T>: ListDataSource {
    
    typealias DataType = T
    
    private let _numberOfSections: Int
    private let _numberOfRows: (Int) -> Int
    private let _itemAt: (IndexPath) -> DataType?
    
    init<Concrete: ListDataSource>(concrete: Concrete) where Concrete.DataType == T {
        _numberOfRows = concrete.numberOfRows
        _numberOfSections = concrete.numberOfSections
        _itemAt = concrete.item
    }
    
    var numberOfSections: Int {
        return _numberOfSections
    }
    
    func numberOfRows(for section: Int) -> Int {
        return _numberOfRows(section)
    }
    
    func item(at indexPath: IndexPath) -> T? {
        return _itemAt(indexPath)
    }
}

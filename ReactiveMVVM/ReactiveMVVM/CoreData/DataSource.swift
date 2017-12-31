//
//  DataSource.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/30/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation
import CoreData

protocol ListDataSource {
    
    associatedtype DataType
    
    var numberOfSections: Int { get }
    
    func numberOfRows(for section: Int) -> Int
    
    func viewModel(for indexPath: IndexPath) -> DataType?
    
}

class AnyDataSource<T> {
    
    init<Concrete: ListDataSource>(concrete: Concrete) where Concrete.DataType == T {
        
    }
}

class APODFetchedResultsController: ListDataSource {
    
    typealias DataType = APOD
    
    init() {

    }
    
    var numberOfSections: Int {
        return 0
    }
    
    func numberOfRows(for section: Int) -> Int {
        return 0
    }
    
    func viewModel(for indexPath: IndexPath) -> APOD? {
        return nil
    }
}

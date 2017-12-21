//
//  SMOperation.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

enum OperationResult<T> {
    case failed(errors: [Error])
    case success(result: T?)
}

class ObservedOperation<T>: Operation {
    
    private let operationObserver: (OperationResult<T>) -> ()
    
    required init(observer: @escaping (OperationResult<T>) -> ()) {
        self.operationObserver = observer
    }
    
    override func main() {
        guard !isCancelled else { return }
        execute()
    }
    
    func execute() {
        fatalError("Subclasses should always override this")
    }

    func finish(data: T?, errors: [Error] = []) {
        if errors.isEmpty {
            operationObserver(.success(result: data))
        } else {
            operationObserver(.failed(errors: errors))
        }
    }
}

/// Example
class NasaOperation: ObservedOperation<String> {
    
    convenience init(data: String, observer: @escaping (OperationResult<String>) -> ()) {
        self.init(observer: observer)
    }
    
    override func execute() {
        // Do stuff
        finish(data: nil)
    }
}

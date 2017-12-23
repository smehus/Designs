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
    case canceled
}

class ObservedOperation<T>: Operation {
    
    var operationName = ""
    
    private let operationHandler: ((OperationResult<T>) -> ())?

//    @objc class func keyPathsForValuesAffectingIsFinished() -> Set<NSObject> {
//        return ["hasFinished" as NSObject]
//    }
    
    private var _finished: Bool = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    required init(handler: ((OperationResult<T>) -> ())?) {
        self.operationHandler = handler
    }
    

    
    override func main() {
        guard !isCancelled else {
            operationHandler?(.canceled)
            return
        }
        
        execute()
    }

    override var isFinished: Bool {
        return _finished
    }
    
    func execute() {
        fatalError("Subclasses should always override this")
    }

    func finish(data: T?, errors: [Error] = []) {
        _finished = true
        guard !isCancelled else {
            operationHandler?(.canceled)
            return
        }
        
        if errors.isEmpty {
            operationHandler?(.success(result: data))
        } else {
            operationHandler?(.failed(errors: errors))
        }
    }
}

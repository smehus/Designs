//
//  NasaImageFacade.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

//TODO: Use a protocol 
internal final class NasaFacade {
    
    private let session: Session
    private let operationQueue: OperationQueue
    private let today = Date()
    private var apods = [APOD]()
    
    private var runningOperations = [Operation]()
    
    init(session: Session, queue: OperationQueue) {
        self.session = session
        self.operationQueue = queue
    }

    func fetchAPOD(for date: Date, completion: @escaping () -> ()) {
        let operation = APODOperation(date: date, session: session) { (result) in
            completion()
        }
        
        operationQueue.addOperation(operation)
    }
    
    func fetchWeeksAPODS(for date: Date, completion: @escaping () -> ()) {
        guard var firstDate = today.day(fromInterval: -7) else {
            completion()
            return
        }
        
        
        let gate = GateOperation { _ in
            print("APODS COUNT \(self.apods.count)")
            completion()
        }
        
        runningOperations.append(gate)
        Loop: while firstDate <= today {
            
            let operation = APODOperation(date: firstDate, session: session, handler: { [weak self] (result) in
                print("APOD OPERATION RETURN")
                guard
                    case let OperationResult.success(model) = result,
                    let apod = model
                else {
                    return
                }
            
                self?.apods.append(apod)
            })
            
            gate.addDependency(operation)
            
            operationQueue.addOperation(operation)
            runningOperations.append(operation)
            
            guard let newDate = firstDate.dayAfter else {
                break Loop
            }
            
            firstDate = newDate
        }
        
        
        
        operationQueue.addOperation(gate)
    }
}

class GateOperation: ObservedOperation<Bool> {
    override func execute() {
        finish(data: nil, errors: [])
    }
}

extension NasaFacade: ListDataSource {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(for section: Int) -> Int {
        return 10
    }
    func item(at indexPath: IndexPath) -> APOD? {
        return nil
    }
}


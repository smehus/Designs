//
//  NasaImageFacade.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

enum FacadeError: Error {
    case failed
}

//TODO: Use a protocol
internal final class NasaFacade {
    
    private let session: Session
    private let operationQueue: OperationQueue
    private let today = Date()
    private var apods = [APOD]()
    
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
    
    func fetchWeeksAPODS(for date: Date, completion: @escaping (APODListDataSource?, Error?) -> ()) {
        guard var firstDate = today.day(fromInterval: -7) else {
            completion(nil, FacadeError.failed)
            return
        }
        
        
        /// The JSON Processor was getting deallocated because the operation was getting finished immediately and released form the queue
        let gate = GateOperation { [unowned self] _ in
            let dataSource = APODListDataSource(apods: self.apods)
            completion(dataSource, nil)
        }
        
        Loop: while firstDate <= today {
            
            let operation = APODOperation(date: firstDate, session: session, handler: { [weak self] (result) in
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
            
            guard let newDate = firstDate.dayAfter else {
                break Loop
            }
            
            firstDate = newDate
        }
        
        
        
        operationQueue.addOperation(gate)
    }
}

class GateOperation: ObservedOperation<()> {
    override func execute() {
        finish(data: nil, errors: [])
    }
}

struct APODListDataSource: ListDataSource {
    
    private let apods: [APOD]
    
    init(apods: [APOD]) {
        self.apods = apods
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(for section: Int) -> Int {
        return apods.count
    }
    
    func item(at indexPath: IndexPath) -> APOD? {
        guard
            indexPath.section == 0,
            indexPath.row < apods.count
        else {
            return nil
        }
        
        return apods[indexPath.row]
    }
}


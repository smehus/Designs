//
//  NasaImageFacade.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

protocol NasaFacade {
    init(session: Session, queue: OperationQueue)
    func fetchAPOD(for date: Date, completion: @escaping () -> ())
    func fetchWeeksAPODS(for date: Date, completion: @escaping (APODListDataSource?, Error?) -> ())
}

enum FacadeError: Error {
    case failed
}

//TODO: Use a protocol
internal final class NasaNetworkFacade: NasaFacade {
    
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
        guard var firstDate = today.day(fromInterval: -60) else {
            completion(nil, FacadeError.failed)
            return
        }
        
        
        /// The JSON Processor was getting deallocated because the operation was getting finished immediately and released form the queue
        let gate = GateOperation { [unowned self] _ in
            let orderedPods = self.apods.sorted(by: { $0.date > $1.date })
            let dataSource = APODListDataSource(apods: orderedPods)
            completion(dataSource, nil)
        }
        
        Loop: while firstDate <= today {
            
            let operation = APODOperation(date: firstDate, session: session, handler: { [weak self] (result) in
                guard
                    case let OperationResult.success(model) = result,
                    let apod = model,
                    apod.mediaType == .image
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
    
    private let models: [APODCellModel]
    
    init(apods: [APOD]) {
        self.models = apods.map { APODCellModel(apod: $0) }
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(for section: Int) -> Int {
        return models.count
    }
    
    func item(at indexPath: IndexPath) -> APODCellModel? {
        guard
            indexPath.section == 0,
            indexPath.row < models.count
        else {
            return nil
        }
        
        return models[indexPath.row]
    }
}


//
//  NasaImageFacade.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

class APODJSONProcessor {
    
    private struct Keys {
        
    }
    
    private let handler: ([APOD]?, [Error]?) -> ()
    
    init(completion: @escaping ([APOD]?, [Error]?) -> ()) {
        self.handler = completion
    }
    
    func process() -> ((JSON?, Error?) -> ()) {
        return { [weak self] json, error in
            
            print("JSON \(json)")
            
            self?.handler([], nil)
        }
    }
}


internal final class NasaFacade {
    
    private let session: Session
    private let operationQueue: OperationQueue
    
    init(session: Session, queue: OperationQueue) {
        self.session = session
        self.operationQueue = queue
    }
    

    func fetchAPOD(for date: Date, completion: @escaping () -> ()) {

//        let handler: (OperationResult<[APOD]>) -> () = { result in
//            completion()
//        }
//
//        let operation = APODOperation(date: date, session: session, handler: handler)
//        operationQueue.addOperation(operation)
        
        
        let processor = APODJSONProcessor { models, errors in
            completion()
        }
        
        let request = NasaRequest.apod(date: date)
        session.execute(request: request, handler: processor.process())
    }
}

extension NasaFacade: ListDataSource {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(for section: Int) -> Int {
        return 10
    }
    func item<T>(at indexPath: IndexPath) -> T? {
        return nil
    }
}

protocol ListDataSource {
    var numberOfSections: Int { get }
    func numberOfRows(for section: Int) -> Int
    func item<T>(at indexPath: IndexPath) -> T?
}

struct APOD {
    
}



class APODOperation: ObservedOperation<[APOD]> {
    
    private var date: Date?
    private var session: Session?
    
    convenience init(date: Date, session: Session, handler: @escaping (OperationResult<[APOD]>) -> ()) {
        self.init(handler: handler)
        self.date = date
        self.session = session
    }
    
    override func execute() {
        
        guard let session = session, let date = self.date else { finish(data: nil); return }
        let processor = APODJSONProcessor { [weak self] models, errors in
            self?.finish(data: models, errors: errors ?? [])
        }
        
        let request = NasaRequest.apod(date: date)
        session.execute(request: request, handler: processor.process())
    }
}

//
//  NasaImageFacade.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

class JSONProcessor {
    
    private struct Keys {
        
    }
    
    private let handler: ([NASAModel]) -> ()
    
    init(completion: @escaping ([NASAModel]) -> ()) {
        self.handler = completion
    }
    
    func process() -> ((JSON?, Error?) -> ()) {
        return { [weak self] json, error in
            self?.handler([])
        }
    }
}


internal final class NasaImageFacade {
    
    private let session: Session
    private let operationQueue: OperationQueue
    
    init(session: Session, queue: OperationQueue) {
        self.session = session
        self.operationQueue = queue
    }
    
    func search(for query: String, completion: @escaping () -> ()) {

        let handler: (OperationResult<[NASAModel]>) -> () = { result in
            completion()
        }
        
        let operation = SearchOperation(query: "", session: session, handler: handler)
        operationQueue.addOperation(operation)
    }
}

struct NASAModel {
    
}

class SearchOperation: ObservedOperation<[NASAModel]> {
    
    private var searchString: String?
    private var session: Session?
    
    convenience init(query: String, session: Session, handler: @escaping (OperationResult<[NASAModel]>) -> ()) {
        self.init(handler: handler)
        self.searchString = query
        self.session = session
    }
    
    
    override func execute() {
        guard let session = session, let query = searchString else { finish(data: nil); return }
        let processor = JSONProcessor { [weak self] models in
            self?.finish(data: models)
        }
        
        
        let request = NasaRequest.images(query: query)
        session.execute(request: request, handler: processor.process())
    }
}

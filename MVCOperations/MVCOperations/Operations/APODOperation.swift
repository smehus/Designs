//
//  APODOperation.swift
//  MVCOperations
//
//  Created by scott mehus on 12/22/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

class APODOperation: ObservedOperation<APOD> {
    
    private var date: Date?
    private var session: Session?
    
    convenience init(date: Date, session: Session, handler: @escaping (OperationResult<APOD>) -> ()) {
        self.init(handler: handler)
        self.date = date
        self.session = session
    }
    
    override func execute() {
        guard let session = session, let date = self.date else { finish(data: nil); return }
        let request = NasaRequest.apod(date: date)
        let jsonProcessor = JSONProcessor<APOD>()
        
        session.execute(request: request) { (result) in
            switch result {
            case .failed(let error):
                self.finish(data: nil, errors: [error])
            case .success(let data):
                let apod = jsonProcessor.process(data: data)
                self.finish(data: apod, errors: [])
            }
        }
    }
}

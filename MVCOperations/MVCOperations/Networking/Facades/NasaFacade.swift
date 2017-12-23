//
//  NasaImageFacade.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation


internal final class NasaFacade {
    
    private let session: Session
    private let operationQueue: OperationQueue
    
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
    
    deinit {
        print("DEALLOCATE FACADE")
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


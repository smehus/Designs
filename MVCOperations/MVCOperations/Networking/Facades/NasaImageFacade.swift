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
    
    func process() -> ((JSON?, Error?) -> ()) {
        return { json, error in
            
        }
    }
}


internal final class NasaImageFacade {
    
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func search(for query: String) {
        let processor = JSONProcessor()
        let request = NasaRequest.images(query: query)
        session.execute(request: request, handler: processor.process())
    }
}

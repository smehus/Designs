//
//  Application.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

/// Used for general startup tasks and injecting initial dependencies
struct Application {
    
    // Run startup operations
    func run() -> Bool {
        guard
            let delegate = UIApplication.shared.delegate,
            let initialController = delegate.window??.rootViewController as? CoordinatorViewController
        else {
            return true
        }
        
        let facadeQueue = OperationQueue()
        
        let session = NetworkSession()
        let facade = NasaNetworkFacade(session: session, queue: facadeQueue)
        initialController.dataFacade = facade
        
        
        return true
    }
}

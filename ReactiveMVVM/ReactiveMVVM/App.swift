//
//  App.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/27/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

protocol Application {
    func run()
}

struct App: Application {
    
    private let coreDataStack = CoreDataStack(modelName: "Nasa_Store")
    
    func run() {
        
        guard
            let delegate = UIApplication.shared.delegate as? AppDelegate,
            let gateway = delegate.window?.rootViewController as? GatewayViewController
        else {
            return
        }
        
        let session = SessionManager.sharedSession
        let bridge = WebSerivceNasaBridge(session: session)
        gateway.viewModel = GatewayViewControllerViewModel(bridge: bridge, coreDataStack: coreDataStack)
    }
}

//
//  ViewController.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

private enum State {
    case none
    case loading
    case error
    case success
}

internal final class CoordinatorViewController: UIViewController {
    
    /// Serial Queue for adding and removing children
    private var coordinatorQueue: OperationQueue?
    private var currentContext: UIViewController?
    
    lazy var loadingViewController: LoadingViewController = {
        return LoadingViewController.instantiateFromStoryboard()
    }()
    
    private var state: State = .none {
        didSet {
            switch state {
            case .loading:
                handleLoadingState()
            default: break
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Serial Queue
        coordinatorQueue = OperationQueue()
        coordinatorQueue?.maxConcurrentOperationCount = 1
        
        state = .loading
    }
}

extension CoordinatorViewController {
    
    private func handleLoadingState() {
        guard let queue = coordinatorQueue else {
            assertionFailure("Missing Coordinator Operation Queueu")
            return
        }
        
        let addChildOperation = AddChildOperation(parent: self, child: loadingViewController, currentChild: currentContext)
        queue.addOperation(addChildOperation)
    }
}

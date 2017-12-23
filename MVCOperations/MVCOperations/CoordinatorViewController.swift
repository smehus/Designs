//
//  ViewController.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

private enum CoordinatorState {
    case none
    case loading
    case error
    case success(dataSource: AnyListDataSource<APOD>)
}

private func !=(lhs: CoordinatorState, rhs: CoordinatorState) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none),
         (.loading, .loading),
         (.error, .error),
         (.success, .success):
        return false
    default:
        return true
    }
}

internal final class CoordinatorViewController: UIViewController {
    
    var dataFacade: NasaFacade?
    
    /// Serial Queue for adding and removing children
    private var coordinatorQueue: OperationQueue?
    private var currentContext: UIViewController?
    
    lazy var loadingViewController: LoadingViewController = {
        return LoadingViewController.instantiateFromStoryboard()
    }()
    
    lazy var contentViewController: ContentSplitViewController = {
        return ContentSplitViewController.instantiateFromStoryboard()
    }()
    
    private var state: CoordinatorState = .none {
        didSet {
            guard state != oldValue else { return }
            handleStateChange()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Serial Queue
        coordinatorQueue = OperationQueue()
        coordinatorQueue?.maxConcurrentOperationCount = 1
        
        state = .loading
        
        loadData()
    }
    
    private func loadData() {
        
        dataFacade?.fetchWeeksAPODS(for: Date(), completion: { [unowned self] dataSource, error in
            guard
                let source = dataSource,
                error == nil
            else {
                print("Data Facade failed to do stuff")
                return
            }
            
            self.state = .success(dataSource: AnyListDataSource<APOD>(concrete: source))
        })
    }
}

extension CoordinatorViewController {
    
    private func handleStateChange() {
        guard let queue = coordinatorQueue else {
            assertionFailure("Missing Coordinator Operation Queueu")
            return
        }
        
        var nextController: UIViewController
        switch state {
        case .loading:
            nextController = loadingViewController
        case .success:
            nextController = contentViewController
        case .none:
            nextController = contentViewController
        case .error:
            nextController = contentViewController
        }
        
        let addChildOperation = AddChildOperation(parent: self, child: nextController, currentChild: currentContext)
        queue.addOperation(addChildOperation)
    }
}

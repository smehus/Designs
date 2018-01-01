//
//  GatewayViewModel.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/27/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import CoreData

protocol GatewayViewModel {
    var state: MutableProperty<GatewayState> { get set }
    func runStartupSequence()
    func contentController() -> APODCollectionViewController
}

enum GatewayState {
    case idle
    case loading
    case success
    case failed(errorMessage: String)
}

class GatewayViewControllerViewModel: GatewayViewModel {
    
    var state = MutableProperty<GatewayState>(.idle)
    
    private let bridge: NasaBridge
    private let coreDataStack: CoreDataStack
    
    required init(bridge: NasaBridge, coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.bridge = bridge
    }
    
    func runStartupSequence() {
        fetchAPODS()
    }
    
    func contentController() -> APODCollectionViewController {
        let controller = APODCollectionViewController.storyboardFile()
        controller.viewModel = APODCollectionViewControllerViewModel(coreDataStack: coreDataStack)
        return controller
    }
    
    private func fetchAPODS() {
        state.value = .loading
        
        bridge.makeFetchWeeksAPODS(startingDate: Date().dayBefore!)?.startWithResult({ [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.state.value = .failed(errorMessage: "Request failed \(error.localizedDescription)")
            case .success:
                self?.state.value = .success
            }
        })
    }
}


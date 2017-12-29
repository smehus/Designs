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

protocol GatewayViewModel {
    var state: MutableProperty<GatewayState> { get set }
    func runStartupSequence()
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
    
    required init(bridge: NasaBridge) {
        self.bridge = bridge
    }
    
    func runStartupSequence() {
        fetchAPODS()
    }
    
    private func fetchAPODS() {
        state.value = .loading
        bridge.makeFetchAPOD(at: Date()).startWithResult { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.state.value = .failed(errorMessage: "Request failed \(error.localizedDescription)")
            case .success(let success):
                if success {
                    self?.state.value = .success
                } else {
                    self?.state.value = .failed(errorMessage: "Request succeeded but data is invalid")
                }
            }
        }
    }
}

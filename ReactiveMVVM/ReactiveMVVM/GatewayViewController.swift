//
//  ViewController.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/25/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result


class GatewayViewController: UIViewController {
    
    var viewModel: GatewayViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel?.runStartupSequence()
    }
    
    private func setupBindings() {
        viewModel?.state.signal.observeValues { state in
            switch state {
            case .loading:
                print("Gatewaystate loading")
            case .success:
                print("Gatway state success")
            case .failed(let errorMessage):
                print("Gatway state failure \(errorMessage)")
            default: break
            }
        }
    }
}


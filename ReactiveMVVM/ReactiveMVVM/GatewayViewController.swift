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

struct APOD {
    
}

enum NetworkError: Error {
    case fake
}

class GatewayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func fetch() -> SignalProducer<Data?, NetworkError>? {
        return SignalProducer({ () -> Result<Data?, NetworkError> in
            return Result.success(nil)
        })
    }
}


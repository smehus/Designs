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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func requestSignal(with request: Request) -> SignalProducer<(Data, URLResponse), AnyError>? {
        guard let urlReqest = request.urlRequest else { return nil }
        return URLSession.shared.reactive.data(with: urlReqest)
    }
}


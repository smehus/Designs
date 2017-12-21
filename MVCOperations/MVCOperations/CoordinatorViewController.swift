//
//  ViewController.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

private enum State {
    case loading
    case error
    case success
}

internal final class CoordinatorViewController: UIViewController {
    
    private var state: State? {
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CoordinatorViewController {
    
    
}

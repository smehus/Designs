
//
//  LoadingViewController.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

/// Shown when data is being loaded
internal final class LoadingViewController: UIViewController {
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicator.stopAnimating()
    }
}

extension LoadingViewController: StoryboardInstantiable {
    static func instantiateFromStoryboard() -> LoadingViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! LoadingViewController
    }
}

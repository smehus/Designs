//
//  ContentSplitViewController.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

class ContentSplitViewController: UISplitViewController {

    var dataSource: AnyListDataSource<APOD>? {
        didSet {
            guard
                let source = dataSource,
                let nav = self.viewControllers.first as? UINavigationController,
                let master = nav.viewControllers.first as? MasterTableViewController
            else { return }
            
            master.dataSource = source
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ContentSplitViewController: StoryboardInstantiable {
    static func instantiateFromStoryboard() -> ContentSplitViewController {
        let storyboard = UIStoryboard(name: "Content", bundle: nil)
        return storyboard.instantiateInitialViewController() as! ContentSplitViewController
    }
}

//
//  AddChildOperation.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

class AddChildOperation: Operation {
    
    private unowned let parent: UIViewController
    private unowned let child: UIViewController
    private weak var currentChild: UIViewController?
    
    init(parent: UIViewController, child: UIViewController, currentChild: UIViewController?) {
        self.parent = parent
        self.child = child
        self.currentChild = currentChild
    }
    
    //TODO: Do some fancy animation
    override func main() {
        DispatchQueue.main.async {
            let currentChild = self.currentChild
            let child = self.child
            let parent = self.parent
            
            if let current = currentChild {
                current.view.removeFromSuperview()
                current.willMove(toParentViewController: nil)
                current.removeFromParentViewController()
            }
            
            child.willMove(toParentViewController: parent)
            parent.addChildViewController(child)
            parent.view.addSubview(child.view)
            
            child.view.translatesAutoresizingMaskIntoConstraints = false
            child.view.topAnchor.constraint(equalTo: parent.view.topAnchor).isActive = true
            child.view.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor).isActive = true
            child.view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor).isActive = true
            child.view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor).isActive = true
            
            child.didMove(toParentViewController: parent)
        }
    }
}

//
//  ErrorViewController.swift
//  MVCOperations
//
//  Created by scott mehus on 12/24/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {

}
extension ErrorViewController: StoryboardInstantiable {
    static func instantiateFromStoryboard() -> ErrorViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! ErrorViewController
    }
}

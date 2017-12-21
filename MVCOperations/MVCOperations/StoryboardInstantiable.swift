//
//  StoryboardInstantiable.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation


protocol StoryboardInstantiable {
    associatedtype T
    static func instantiateFromStoryboard() -> T
}

//
//  NasaRequest.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

enum NasaRequest {
    case all
}

extension NasaRequest: Request {
    
    var taskType: DataTaskType {
        return .dataTask
    }
    
    var urlRequest: URLRequest? {
        return nil
    }
}

//
//  NasaStore.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/26/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

protocol NasaBridge {
    func makeFetchAPOD(at date: Date)
}

class WebSerivceNasaBridge: NasaBridge {
    
    func makeFetchAPOD(at date: Date) {
        
    }
}

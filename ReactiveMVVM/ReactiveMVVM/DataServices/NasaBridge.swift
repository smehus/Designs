//
//  NasaStore.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/26/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

enum NasaRequest: Request {
    case apod(date: Date)
    
    var httpBody: Data? {
        return nil
    }
    
    var httpHeaders: [String : String]? {
        return nil
    }
    
    var parameters: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        return URL(string: "")!
    }
}

protocol NasaBridge {
    func makeFetchAPOD(at date: Date)
}

class WebSerivceNasaBridge: NasaBridge {
    
    private let session: SessionManager
    
    init(session: SessionManager) {
        self.session = session
    }
    
    func makeFetchAPOD(at date: Date) {
        let disposable = session.execute(request: NasaRequest.apod(date: Date())).map { (result) -> JSON? in
            guard case let .success(data) = result else { return nil }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSON
                return json
            } catch {
                return nil
            }
            }.map { (json) -> APOD? in
                guard let json = json else { return nil }
                return APOD(title: "")
        }
        
        disposable.startWithResult { (result) in
            switch result {
            case .failure(let error):
                break
            case .success(let apod):
                break
            }
        }
    }
}

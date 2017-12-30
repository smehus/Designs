//
//  NasaStore.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/26/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

enum NasaRequest: Request {
    case apod(date: Date)
    
    var httpBody: Data? {
        return nil
    }
    
    var apiKey: (key: String, value: String) {
        return ("api_key", "NfQJhPNcBzPoqmZ4Kb8Uqdcnf5sVdIZqQziQYt7k")
    }
    
    var httpHeaders: [String : String]? {
        return nil
    }
    
    var parameters: [String : String]? {
        switch self {
        case .apod(let date):
            return ["date": DateFormatter.apodFormatter.string(from: date), apiKey.key: apiKey.value]
        }
    }
    
    var baseURL: URL {
        return URL(string: "https://api.nasa.gov/planetary/apod")!
    }
}

protocol NasaBridge {
    func makeFetchAPOD(at date: Date) -> SignalProducer<Bool, NetworkError>
}

class WebSerivceNasaBridge: NasaBridge {
    
    private let session: SessionManager
    private let jsonDecoder = JSONDecoder()
    
    init(session: SessionManager) {
        self.session = session
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.apodFormatter)
    }
//
//    func makeFetchWeeksAPODS(startingDate: Date) {
//        let signals = [SignalProducer<APOD, NetworkError>]()
//
//        // Zip all signals together
//    }
//
    func makeFetchAPOD(at date: Date) -> SignalProducer<Bool, NetworkError> {
        return session.execute(request: NasaRequest.apod(date: Date())).map({ [weak self] (result) -> Bool in
            guard let strongSelf = self else{ return false }
            switch result {
            case .success(let data):
                do {
                    let flyweight = try strongSelf.jsonDecoder.decode(APODFlyweight.self, from: data)
                    
                    return true
                } catch let error {
                    print("⁉️ Failed to parse apod \(error.localizedDescription)")
                    return false
                }
            case .failure:
                return false
            }
        })
    }
}

enum ParsingError: Error {
    case invalidJSON
}

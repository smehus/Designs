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
import CoreData

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
    func makeFetchWeeksAPODS(startingDate: Date) -> SignalProducer<[Bool], NetworkError>?
}

class WebSerivceNasaBridge: NasaBridge {
    
    private let session: SessionManager
    private let jsonDecoder = JSONDecoder()
    private let coreDataStack: CoreDataStack
    
    var currentZip: SignalProducer<[Bool], NetworkError>?
    
    init(session: SessionManager, coreDataStack: CoreDataStack) {
        self.session = session
        self.coreDataStack = coreDataStack
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.apodFormatter)
    }
    
    func makeFetchWeeksAPODS(startingDate: Date) -> SignalProducer<[Bool], NetworkError>? {
        var signals = [SignalProducer<Bool, NetworkError>]()
        let today = Date()
        guard var deltaDate = today.day(fromInterval: -5) else {
            assertionFailure()
            return nil
        }
        
        Loop: while deltaDate <= today {
            
            let newSig = makeFetchAPOD(at: deltaDate)
            signals.append(newSig)
            guard let next = deltaDate.dayAfter else {
                break Loop
            }
            
            deltaDate = next
        }
        
        
        let sig = SignalProducer.zip(signals).on(starting: nil, started: nil, event: nil, failed: nil, completed: { [weak self] in
            guard let strongSelf = self else {
                assertionFailure()
                return
            }
            
            strongSelf.coreDataStack.saveContext()
            }, interrupted: nil, terminated: nil, disposed: nil, value: nil)
        
         return sig
    }

    func makeFetchAPOD(at date: Date) -> SignalProducer<Bool, NetworkError> {
        return session.execute(request: NasaRequest.apod(date: date)).map({ [weak self] (result) -> Bool in
            guard let strongSelf = self, let context = self?.coreDataStack.managedContext else{ return false }
            switch result {
            case .success(let data):
                do {
                    let flyweight = try strongSelf.jsonDecoder.decode(APODFlyweight.self, from: data)
                    try APOD.storeInScratchPad(model: flyweight, context: context)
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

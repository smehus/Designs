//
//  APOD+CoreDataClass.swift
//  
//
//  Created by scott mehus on 12/29/17.
//
//

import Foundation
import CoreData

enum APODError: Error {
    case coreDataFailure
}

@objc(APOD)
class APOD: NSManagedObject {

    static func storeInScratchPad(model: APODFlyweight, context: NSManagedObjectContext) throws {
        guard let apod = fetchOrCreate(model: model, context: context) else {
            throw APODError.coreDataFailure
        }
        
        apod.update(with: model)
    }
    
    private static func fetchOrCreate(model: APODFlyweight, context: NSManagedObjectContext) -> APOD? {
        let fetch: NSFetchRequest<APOD> = APOD.fetchRequest()
        fetch.predicate = NSPredicate(format: "%K == %@", #keyPath(APOD.date), model.date as NSDate)
        
        do {
            let results = try context.fetch(fetch)
            if let current = results.first {
                return current
            } else {
                return APOD(context: context)
            }
        } catch {
            assertionFailure("Failed to fetch APOD models")
            return nil
        }
    }
    
    func update(with flyweight: APODFlyweight) {
        self.title = flyweight.title
        self.url = flyweight.url.absoluteString
        self.service_version = flyweight.service_version
        self.media_type = flyweight.media_type
        self.hdurl = flyweight.hdurl?.absoluteString
        self.explanation = flyweight.explanation
        self.date = flyweight.date as NSDate
        self.copyright = flyweight.copyright
    }
}

//
//  APOD+CoreDataClass.swift
//  
//
//  Created by scott mehus on 12/29/17.
//
//

import Foundation
import CoreData

@objc(APOD)
class APOD: NSManagedObject {
    
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

    func store(model: APODFlyweight, context: NSManagedObjectContext) throws {
        let fetch: NSFetchRequest<APOD> = APOD.fetchRequest()
        fetch.predicate = NSPredicate(format: "%K == %@", #keyPath(APOD.date), model.date as NSDate)
        var updatedApod: APOD?
        do {
            let results = try context.fetch(fetch)
            if let current = results.first {
                updatedApod = current
            }
        } catch {
            updatedApod = APOD(context: context)
        }
        
        if let apod = updatedApod {
            apod.update(with: model)
            do {
                try context.save()
            } catch let error as NSError {
                print("FAILED TO SAVE CONTEXT \(error.localizedDescription)")
                throw error
            }
        }
    }
}

//
//  APOD+CoreDataProperties.swift
//  
//
//  Created by scott mehus on 12/29/17.
//
//

import Foundation
import CoreData


extension APOD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<APOD> {
        let request = NSFetchRequest<APOD>(entityName: String(describing: APOD.self))
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request
    }

    @NSManaged public var title: String
    @NSManaged public var url: String
    @NSManaged public var service_version: String?
    @NSManaged public var media_type: String?
    @NSManaged public var hdurl: String?
    @NSManaged public var explanation: String?
    @NSManaged public var date: NSDate
    @NSManaged public var copyright: String?

}

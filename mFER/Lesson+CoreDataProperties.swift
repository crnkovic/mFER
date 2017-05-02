//
//  Lesson+CoreDataProperties.swift
//  mFER
//
//  Created by Josip Crnković on 30/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import Foundation
import CoreData


extension Lesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        return NSFetchRequest<Lesson>(entityName: "Lesson");
    }

    @NSManaged public var location: String?
    @NSManaged public var from: NSDate?
    @NSManaged public var summary: String?
    @NSManaged public var to: NSDate?
    @NSManaged public var course: Course?

}

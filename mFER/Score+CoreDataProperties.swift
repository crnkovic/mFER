//
//  Score+CoreDataProperties.swift
//  mFER
//
//  Created by Josip Crnković on 30/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
        return NSFetchRequest<Score>(entityName: "Score");
    }

    @NSManaged public var value: Double
    @NSManaged public var scorePresent: Bool
    @NSManaged public var scorePassed: Bool
    @NSManaged public var scoreAllowed: Bool
    @NSManaged public var timeUpdated: NSDate?
    @NSManaged public var nameHr: String?
    @NSManaged public var nameEn: String?
    @NSManaged public var course: Course?

}

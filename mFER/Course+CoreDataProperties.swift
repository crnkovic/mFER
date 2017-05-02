//
//  Course+CoreDataProperties.swift
//  mFER
//
//  Created by Josip Crnković on 30/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course");
    }

    @NSManaged public var id: Int16
    @NSManaged public var nameEn: String?
    @NSManaged public var nameHr: String?
    @NSManaged public var scores: NSSet?
    @NSManaged public var lessons: NSSet?

}

// MARK: Generated accessors for scores
extension Course {

    @objc(addScoresObject:)
    @NSManaged public func addToScores(_ value: Score)

    @objc(removeScoresObject:)
    @NSManaged public func removeFromScores(_ value: Score)

    @objc(addScores:)
    @NSManaged public func addToScores(_ values: NSSet)

    @objc(removeScores:)
    @NSManaged public func removeFromScores(_ values: NSSet)

}

// MARK: Generated accessors for lessons
extension Course {

    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)

    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)

    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSSet)

    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSSet)

}

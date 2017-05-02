//
//  Repository.swift
//  mFER
//
//  Created by Josip Crnković on 29/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class Repository {
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "mFER")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    class func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    class func context() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    class func fetchCourses() -> [Course] {
        var courses = [Course]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")
        
        do {
            let result = try self.context().fetch(fetchRequest)
            
            for item in result {
                courses.append(item as! Course)
            }
            
        } catch {
            print ("Greska prilikom ucitavanja predmeta")
        }
        
        return courses

    }
    
    class func createCourse(_ data: JSON) -> Course {
        let course: Course = NSEntityDescription.insertNewObject(forEntityName: "Course", into: Repository.context()) as! Course
        
        course.id = Int16(data["sifpred"].stringValue) ?? 0
        course.nameHr = data["nazpred_hr"].stringValue
        course.nameEn = data["nazpred_en"].stringValue
        
        self.saveContext()
        
        return course
    }
    
    class func createScore(course: Course, data: JSON) {
        let score = NSEntityDescription.insertNewObject(forEntityName: "Score", into: Repository.context()) as! Score
        
        score.nameEn = data["name_en"].stringValue
        score.nameHr = data["name_hr"].stringValue
        score.value = data["score_value"].doubleValue
        score.scorePresent = data["score_present"].stringValue == "t"
        score.scorePassed = data["score_passed"].stringValue == "t"
        score.scoreAllowed = data["score_allowed"].stringValue == "t"
        score.timeUpdated = NSDate()
        score.course = course
        
        self.saveContext()
    }
    
    class func clear(entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.context().execute(deleteRequest)
        } catch let error as NSError {
            Alert.showError(message: error.localizedDescription)
        }
    }
}

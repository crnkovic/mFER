//
//  Calendar.swift
//  mFER
//
//  Created by Josip Crnković on 30/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class Schedule {
    private var lessons = [Lesson]()
    private var data: String
    private var lines = [String]()
    private var elements = [[String]]()
    private var courses = [String:Course]()
    
    init(data: String) {
        self.data = data
        
        data.enumerateLines { (line, _) -> () in
            self.lines.append(line)
        }
        
        let coursesRepo = Repository.fetchCourses()
        
        for course in coursesRepo {
            courses[course.nameHr!] = course
        }
    
        self.parse()
        self.generateLessons()
    }
    
    private func generateLessons() {
        Repository.clear(entity: "Lesson")
        
        for event in elements {
            var lesson = [String:Any]()
            
            for element in event {
                let splitData = element.components(separatedBy: ":")
                
                if splitData[0] == "LOCATION" {
                    lesson["location"] = splitData[1]
                }
                
                if splitData[0] == "SUMMARY" {
                    lesson["summary"] = splitData[1]
                    lesson["course"] = nil
                    
                    let summarySplit = splitData[1].components(separatedBy: " - ")
                    
                    if courses[summarySplit[0]] != nil {
                        lesson["course"] = courses[summarySplit[0]]
                        lesson["summary"] = summarySplit[1]
                    }
                }
            }
            
            if lesson["course"] != nil {
                
                let course = lesson["course"] as! Course?
                
                let l = NSEntityDescription.insertNewObject(forEntityName: "Lesson", into: Repository.context()) as! Lesson
                
                l.summary = lesson["summary"] as! String?
                l.location = lesson["location"] as! String?
                l.course = course
                
                course?.addToLessons(l)
                
                lessons.append(l)
            }
        }
        
        print (lessons)
        print ("-------------------------------------")

        
        Repository.saveContext()
    }
    
    private func parse() {
        var inEvent = false
        var i = 0
        
        for line in lines {
            if line == "BEGIN:VEVENT" {
                inEvent = true
                
                elements.append([])
                
                continue
            }
            
            if line == "END:VEVENT" {
                inEvent = false
                i += 1
                
                continue
            }
            
            if inEvent {
                elements[i].append(line)
            }
        }
    }
    
    func getLessons() -> [Lesson] {
        return lessons
    }
}

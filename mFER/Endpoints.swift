//
//  Endpoints.swift
//  mFER
//
//  Created by Josip Crnković on 20/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import Foundation

class Endpoints {
    static let ARTICLES = "https://www.fer.unizg.hr/feed/rss.php?urls="
    static let COURSES  = "https://www.fer.unizg.hr/_download/simplereport/report_77888_5859_mojipredmeti.json"
    static let SCORES = "https://www.fer.unizg.hr/_download/simplereport/report_77888_5861_bodovi.json?p3="
    
    static func articles(courseID: String) -> String {
        return ARTICLES + courseID
    }
    
    static func courses() -> String {
        return COURSES
    }
    
    static func scores(courseID: Int) -> String {
        return SCORES + String(courseID)
    }
}
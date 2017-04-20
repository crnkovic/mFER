//
//  Course.swift
//  mFER
//
//  Created by Josip Crnković on 20/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import Foundation

class Course {
    private var nameHr: String
    private var nameEn: String
    private var id: Int
    
    init(id: Int, nameHr: String, nameEn: String) {
        self.id = id
        self.nameHr = nameHr
        self.nameEn = nameEn
    }
    
    func courseID() -> Int {
        return id
    }
    
    func name() -> String {
        return nameHr
    }
    
    func name(english: Bool) -> String {
        return english ? nameEn : nameHr
    }
}

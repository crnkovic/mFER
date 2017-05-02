//
//  Auth.swift
//  mFER
//
//  Created by Josip Crnković on 20/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Auth {
    static func logout() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.NOTIFICATIONS)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.REFRESH)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.USERNAME)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.PASSWORD)
        
        // Remove all user data from the CoreData
        Repository.clear(entity: "Course")
        Repository.clear(entity: "Score")
        Repository.clear(entity: "Lesson")
    }
    
    static func username() -> String {
        return UserDefaults.standard.object(forKey: UserDefaultsKeys.USERNAME) as! String
    }
    
    static func password() -> String {
        return UserDefaults.standard.object(forKey: UserDefaultsKeys.PASSWORD) as! String
    }
    
    static func encodedCredentials() -> String {
        return credentials(username: Auth.username(), password: Auth.password()).base64EncodedString()
    }
    
    static func encodeCredentials(credentials: Data) -> String {
        return credentials.base64EncodedString()
    }
    
    static func credentials(username: String, password: String) -> Data {
        return String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
    }
}

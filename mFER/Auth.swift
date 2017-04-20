//
//  Auth.swift
//  mFER
//
//  Created by Josip Crnković on 20/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import Foundation

class Auth {
    static func logout() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.NOTIFICATIONS)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.REFRESH)
    }
}

//
//  Util.swift
//  mFER
//
//  Created by Josip Crnković on 20/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import Foundation
import SVProgressHUD

class Alert {
    static func showLoader() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
    }
    
    static func showSuccess(message: String) {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.dismiss(withDelay: 1)
        SVProgressHUD.showSuccess(withStatus: message)
    }
    
    static func hideLoader() {
        SVProgressHUD.dismiss()
    }
}

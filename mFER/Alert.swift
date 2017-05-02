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
    class func showLoader() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
    }
    
    class func showSuccess(message: String) {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.dismiss(withDelay: 1)
        SVProgressHUD.showSuccess(withStatus: message)
    }
    
    class func hideLoader() {
        SVProgressHUD.dismiss()
    }
    
    class func showError(message: String) {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.showError(withStatus: message)

    }
}

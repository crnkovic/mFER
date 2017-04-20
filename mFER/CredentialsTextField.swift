//
//  CredentialsTextField.swift
//  mFER
//
//  Created by Josip Crnković on 20/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import UIKit

@IBDesignable
class CredentialsTextField: UITextField {
    func setup() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 1
    }
}

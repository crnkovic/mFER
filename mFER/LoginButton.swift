//
//  LoginButtonView.swift
//  mFER
//
//  Created by Josip Crnković on 20/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import UIKit

@IBDesignable
class LoginButton: UIButton {
    
    // Disable the login button
    // Set user interaction to false and darken the background color
    func disable() {
        self.isUserInteractionEnabled = false
        
        self.backgroundColor = UIColor(
            red: CGFloat(159.0/255.0),
            green: 0,
            blue: CGFloat(15.0/255.0),
            alpha: 1
        )
        
    }
    
    // Enable the loggin button
    // Set user interaction to true and lighten the background color
    func enable() {
        self.isUserInteractionEnabled = true
        
        self.backgroundColor = UIColor(
            red: CGFloat(217.0/255.0),
            green: CGFloat(0),
            blue: CGFloat(21.0/255.0),
            alpha: 1
        )
    }
    
    func setup() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 1
    }

}

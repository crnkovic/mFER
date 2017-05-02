//
//  LoginViewController.swift
//  mFER
//
//  Created by Josip Crnković on 20/04/17.
//  Copyright © 2017 Josip Crnković. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import AlamofireRSSParser

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: CredentialsTextField!
    @IBOutlet weak var passwordTextField: CredentialsTextField!
    @IBOutlet weak var loginButton: LoginButton!
    var invalidCredentialsAlertController = UIAlertController(title: "Greška", message: "Unijeli ste neispravno korisničko ime ili lozinku!", preferredStyle: .alert)
    var emptyCredentialsAlertController = UIAlertController(title: "Greška", message: "Niste upisali korisničko ime ili lozinku!", preferredStyle: .alert)

    
    private func setup() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        usernameTextField.tag = 0
        passwordTextField.tag = 1
        
        usernameTextField.setup()
        passwordTextField.setup()
        loginButton.setup()
        
        invalidCredentialsAlertController.addAction(UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: nil
        ))
        
        emptyCredentialsAlertController.addAction(UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: nil
        ))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        // Gesture to dismiss the keyboard when tapped
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    @IBAction func login(_ sender: LoginButton) {
        view.endEditing(true)
        performLogin()
    }
    
    private func performLogin() {
        if !hasEnteredCredentials() {
            return
        }
        
        loginButton.disable()

        if UserDefaults.standard.object(forKey: UserDefaultsKeys.NOTIFICATIONS) == nil {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.NOTIFICATIONS)
        }
        
        if UserDefaults.standard.object(forKey: UserDefaultsKeys.REFRESH) == nil {
            UserDefaults.standard.set("15 min", forKey: UserDefaultsKeys.REFRESH)
        }
        
        Alert.showLoader()
        
        Alamofire.request(Endpoints.COURSES)
            .authenticate(user: usernameTextField.text!, password: passwordTextField.text!)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if response.result.isFailure {
                    Alert.hideLoader()
                    self.loginButton.enable()
                    
                    self.present(self.invalidCredentialsAlertController, animated: true)
                } else {
                    let username = self.usernameTextField.text!
                    let password = self.passwordTextField.text!
                    
                    // Save username and password to the UserDefaults
                    UserDefaults.standard.set(username, forKey: UserDefaultsKeys.USERNAME)
                    UserDefaults.standard.set(password, forKey: UserDefaultsKeys.PASSWORD)
                    UserDefaults.standard.set(Double(Date.timeIntervalSinceReferenceDate), forKey: UserDefaultsKeys.UPDATED)
                    
                    for item in JSON(response.result.value!).arrayValue {
                        
                        // Save a new course to the CoreData
                        let course = Repository.createCourse(item)
                        
                        Alamofire.request(Endpoints.scores(courseID: course.id))
                            .authenticate(user: username, password: password)
                            .validate(statusCode: 200..<300)
                            .responseJSON { response in
                                for score in JSON(response.result.value!).arrayValue {
                                    // No scores for this course
                                    if score.isEmpty {
                                        continue
                                    }
                                    
                                    Repository.createScore(course: course, data: score)
                                }
                          }
                    }
                    
                    Alamofire.request("https://www.fer.unizg.hr/feed/rss.php?subscriptions=1")
                        .authenticate(user: Auth.username(), password: Auth.password())
                        .validate(statusCode: 200..<300)
                        .responseRSS() { (response) -> Void in
                            if let feed: RSSFeed = response.result.value {
                                for item in feed.items {
                                    print(item)
                                }
                            }
                    }
                    
                    
                    // Reset the form
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                    self.loginButton.enable()
                    Alert.hideLoader()
                    
                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                }
            }
    }

    // Check if user has entered credentials
    private func hasEnteredCredentials() -> Bool {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            present(emptyCredentialsAlertController, animated: true)
            
            return false
        }
        
        return true
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            
            performLogin()
        }
        
        return false
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}
}

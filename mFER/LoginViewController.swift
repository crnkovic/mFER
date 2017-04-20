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
        
        var courses = [Course]()
        
        Alamofire.request(Endpoints.COURSES, method: .get)
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
                    
                    // Reset the form
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                    self.loginButton.enable()
                    Alert.hideLoader()
                    
                    UserDefaults.standard.set(username, forKey: UserDefaultsKeys.USERNAME)
                    UserDefaults.standard.set(password, forKey: UserDefaultsKeys.PASSWORD)
                    
                    let result = JSON(response.result.value!).arrayValue
                    
                    for e in result {
                        let course = Course(id: e["sifpred"].intValue, nameHr: e["nazpred_hr"].stringValue, nameEn: e["nazpred_en"].stringValue)
                        
                        courses.append(course)
                        
                        // Save to core data
                        // Get all scores
                        
                        
//                        Alamofire.request(Endpoints.scores(courseID: course.courseID()), method: .get)
//                            .authenticate(user: self.usernameTextField.text!, password: self.passwordTextField.text!)
//                            .validate(statusCode: 200..<300)
//                            .responseJSON { scoresResponse in
//                                print(JSON(scoresResponse.result.value!))
//                          }
                    }
                    
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

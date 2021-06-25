//
//  RegistrationVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class RegistrationVC: UIViewController {
    
    // MARK: - Properties
    
    private let registerView = RegistrationView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = registerView
        registerView.usernameField.delegate = self
        registerView.emailField.delegate = self
        registerView.passswordField.delegate = self
        buttonActionFunction()
    }
    
    // MARK: - Methods
    func buttonActionFunction() {
        
        registerView.signUpButtonAction = {
            self.registerView.usernameField.resignFirstResponder()
            self.registerView.emailField.resignFirstResponder()
            self.registerView.passswordField.resignFirstResponder()
            
            guard let username = self.registerView.usernameField.text, !username.isEmpty,
                  let email = self.registerView.emailField.text,!email.isEmpty,
                  let password = self.registerView.passswordField.text,!password.isEmpty,password.count >= 8
                  else { return }
            
            AuthManager.shared.registerNewUser(username: username, email: email, password: password) { (registered) in
                DispatchQueue.main.async {
                    if registered {
                        // good to go
                        #warning("還沒做")
                    } else {
                        // failed
                    }
                }
            }
            
        }
    }
    
}

//MARK: - TextFieldDelegate
extension RegistrationVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == registerView.usernameField {
            registerView.emailField.becomeFirstResponder()
        }
        else if textField == registerView.emailField {
            registerView.passswordField.becomeFirstResponder()
        }
        else if textField == registerView.passswordField {
            registerView.didTapSignUpButton()
        }
        
        return true
    }
    
}

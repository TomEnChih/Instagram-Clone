//
//  LoginVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit
import SafariServices

class LoginVC: UIViewController {

    // MARK: - Properties
    
    private let loginView = LoginView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.usernameEmailField.delegate = self
        loginView.passswordField.delegate = self
        view = loginView
        buttonActionFunction()
    }
    
    // MARK: - Methods
    
    func buttonActionFunction() {
        
        loginView.LoginButtonAction = {
            self.loginView.passswordField.resignFirstResponder()
            self.loginView.usernameEmailField.resignFirstResponder()
            
            guard let usernameEmail = self.loginView.usernameEmailField.text,!usernameEmail.isEmpty,
                  let password = self.loginView.passswordField.text,!password.isEmpty,password.count >= 8 else { return }
            
            var email: String?
            var username: String?
            
            if usernameEmail.contains("@"),usernameEmail.contains(".") {
                //email
                email = usernameEmail
            } else {
                // username
                username = usernameEmail
            }
            
            AuthManager.shared.loginUser(username: username, email: email, password: password) { (success) in
                DispatchQueue.main.async {
                    if success {
                        // user logged in
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        // error occurred
                        let alert = UIAlertController(title: "Log In Error",
                                                      message: "We were unable to log you in", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
        }
        
        loginView.CreateAccountButtonAction = {
            let vc = RegistrationVC()
            vc.title = "創建新帳號"
            
            self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
        
        loginView.PrivacyButtonAction = {
            guard let url = URL(string: "https://help.instagram.com/519522125107875") else {
                return
            }
            
            let vc = SFSafariViewController(url: url)
            
            self.present(vc, animated: true, completion: nil)
        }
        
        loginView.TermsButtonAction = {
            guard let url = URL(string: "https://www.instagram.com/about/legal/terms/before-january-19-2013/") else {
                return
            }
            
            let vc = SFSafariViewController(url: url)
            
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }
    
    
}

    //MARK: - TextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView.usernameEmailField {
            loginView.passswordField.becomeFirstResponder()
        }
        else if textField == loginView.passswordField {
            loginView.didTapLoginButton()
        }
        
        return true
    }

}

//
//  LoginVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit
import SafariServices

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private let loginView = LoginView()
    
    static let loginNotificationName = NSNotification.Name("UpdateUser")

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.emailField.delegate = self
        loginView.passswordField.delegate = self
        view = loginView
        setupKeyboardObservers()
        configureGesture()
        loginView.delegate = self
    }
    
    // MARK: - Methods
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func configureGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDismisskeyboard))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func handleDismisskeyboard() {
        loginView.emailField.resignFirstResponder()
        loginView.passswordField.resignFirstResponder()
    }
    
    
    //MARK: tableView隨keyboard調整
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        /// keybord height: 346
        /// 原始 loginButton 距離 view.bottom: 236
        loginView.emailField.snp.updateConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-130)
            make.width.equalTo(self.view).offset(-50)
            make.height.equalTo(52)
        }
        
        let keyboardDuration = notification.userInfo? [UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        loginView.emailField.snp.updateConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(self.view).offset(-50)
            make.height.equalTo(52)
        }
        
        let keyboardDuration = notification.userInfo? [UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - TextFieldDelegate

extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView.emailField {
            loginView.passswordField.becomeFirstResponder()
        }
        else if textField == loginView.passswordField {
            loginView.handleLogin()
        }
        
        return true
    }
    
}

//MARK: - LoginViewDelegate

extension LoginController: LoginViewDelegate {
    
    func didTapLoginButton() {
        handleDismisskeyboard()
        
        guard let email = loginView.emailField.text,!email.isEmpty,
              let password = loginView.passswordField.text,!password.isEmpty,password.count >= 8 else { return }
        
        AuthManager.shared.loginUser(email: email, password: password) { (success) in
            DispatchQueue.main.async {
                if success {
                    // user logged in
                    NotificationCenter.default.post(name: LoginController.loginNotificationName, object: nil)
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
    
    func didTapCreateAccountButton() {
        handleDismisskeyboard()
        let vc = RegistrationController()
        vc.title = "Create New Account"
        
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    func didTapTermsButton() {
        guard let url = URL(string: "https://help.instagram.com/519522125107875") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        
        present(vc, animated: true, completion: nil)
    }
    
    func didTapPrivacyButton() {
        guard let url = URL(string: "https://www.instagram.com/about/legal/terms/before-january-19-2013/") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        
        present(vc, animated: true, completion: nil)
    }
}

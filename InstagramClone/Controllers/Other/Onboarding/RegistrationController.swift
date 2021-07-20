//
//  RegistrationVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private let registerView = RegistrationView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = registerView
        registerView.usernameField.delegate = self
        registerView.emailField.delegate = self
        registerView.passswordField.delegate = self
        setupKeyboardObservers()
        configureGesture()
        registerView.delegate = self
    }
    
    // MARK: - Methods
    private func configureGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDismisskeyboard))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func handleDismisskeyboard() {
        registerView.usernameField.resignFirstResponder()
        registerView.emailField.resignFirstResponder()
        registerView.passswordField.resignFirstResponder()
    }
    
    //MARK: tableView隨keyboard調整
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        /// keybord height: 346
        /// 原始 loginButton 距離 view.bottom: 314
        registerView.textFieldAndRegisterStackView.snp.updateConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(registerView.plusPhotoButton.snp.bottom).offset(10)
            make.width.equalTo(self.view).offset(-50)
            make.height.equalTo(234)
        }
                
        let keyboardDuration = notification.userInfo? [UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        registerView.textFieldAndRegisterStackView.snp.updateConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(registerView.plusPhotoButton.snp.bottom).offset(50)
            make.width.equalTo(self.view).offset(-50)
            make.height.equalTo(234)
        }
        
        let keyboardDuration = notification.userInfo? [UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
}

//MARK: - TextFieldDelegate

extension RegistrationController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == registerView.usernameField {
            registerView.emailField.becomeFirstResponder()
        }
        else if textField == registerView.emailField {
            registerView.passswordField.becomeFirstResponder()
        }
        else if textField == registerView.passswordField {
            registerView.handleSignUp()
        }
        
        return true
    }
    
}

//MARK: - RegistrationViewDelegate

extension RegistrationController: RegistrationViewDelegate {
    
    func didTapSignUpButton() {
        registerView.usernameField.resignFirstResponder()
        registerView.emailField.resignFirstResponder()
        registerView.passswordField.resignFirstResponder()
        
        guard let username = registerView.usernameField.text,
              let email = registerView.emailField.text,
              let password = registerView.passswordField.text,
              let image = registerView.plusPhotoButton.image(for: .normal) else { return }
        
        AuthManager.shared.registerNewUser(profileImage: image, username: username, email: email, password: password) { (registered) in
            if registered {
                // good to go
                self.dismiss(animated: true, completion: nil)
            } else {
                // failed
            }
        }
    }
    
    func didTapPlusPhotoButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func didTapTextField() {
        guard let username = registerView.usernameField.text, !username.isEmpty,
              let email = registerView.emailField.text,!email.isEmpty,
              let password = registerView.passswordField.text,!password.isEmpty,password.count >= 8 else {
            
            registerView.registerButton.backgroundColor = UIColor(displayP3Red: 149/255, green: 144/255, blue: 204/255, alpha: 0.3)
            registerView.registerButton.isEnabled = false
            return
        }
        
        registerView.registerButton.backgroundColor = .systemBlue
        registerView.registerButton.isEnabled = true
    }
}

//MARK: - ImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            selectedImageFromPicker = originalImage
            
        }
        
        if let selectedImage = selectedImageFromPicker {
            pickImage(image: selectedImage)
        }
    }
    
    private func pickImage(image: UIImage) {
        registerView.plusPhotoButton.setImage(image, for: .normal)
        registerView.plusPhotoButton.layer.masksToBounds = true
        registerView.plusPhotoButton.layer.cornerRadius = registerView.plusPhotoButton.frame.width/2
        registerView.plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        registerView.plusPhotoButton.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
    }
    
}

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
        
        registerView.plusPhotoButtonAction = {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        
        registerView.textFieldAction = {
            guard let username = self.registerView.usernameField.text, !username.isEmpty,
                  let email = self.registerView.emailField.text,!email.isEmpty,
                  let password = self.registerView.passswordField.text,!password.isEmpty,password.count >= 8
                  else {
                self.registerView.registerButton.backgroundColor = UIColor(displayP3Red: 149/255, green: 144/255, blue: 204/255, alpha: 0.3)
                self.registerView.registerButton.isEnabled = false
                return
            }
            self.registerView.registerButton.backgroundColor = .systemBlue
            self.registerView.registerButton.isEnabled = true
        }
        
        registerView.signUpButtonAction = {
            self.registerView.usernameField.resignFirstResponder()
            self.registerView.emailField.resignFirstResponder()
            self.registerView.passswordField.resignFirstResponder()
            
            guard let username = self.registerView.usernameField.text, !username.isEmpty,
                  let email = self.registerView.emailField.text,!email.isEmpty,
                  let password = self.registerView.passswordField.text,!password.isEmpty,password.count >= 8,
                  let image = self.registerView.plusPhotoButton.image(for: .normal)
                  else { return }
            
            AuthManager.shared.registerNewUser(profileImage: image, username: username, email: email, password: password) { (registered) in
                    if registered {
                        // good to go
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        // failed
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

//MARK: - ImagePickerControllerDelegate

extension RegistrationVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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

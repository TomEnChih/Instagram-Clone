//
//  RegistrationView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class RegistrationView: UIView {

    // MARK: - Properties
    
    var signUpButtonAction:(()->Void)?
    
    var textFieldAction:(()->Void)?
        
    var plusPhotoButtonAction:(()->Void)?
    
    // MARK: - IBElement
    
    let plusPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.viewfinder"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    let usernameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username..."
        textField.returnKeyType = UIReturnKeyType.next
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        textField.autocapitalizationType = UITextAutocapitalizationType.none
//        textField.autocorrectionType = UITextAutocorrectionType.no
//        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8.0
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
//        textField.borderStyle = .roundedRect
//        textField.clearButtonMode = .whileEditing
//        textField.keyboardType = .default
        return textField
    }()
    
    let emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email..."
        textField.returnKeyType = UIReturnKeyType.next
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        textField.autocapitalizationType = UITextAutocapitalizationType.none
//        textField.autocorrectionType = UITextAutocorrectionType.no
//        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8.0
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
//        textField.borderStyle = .roundedRect
//        textField.clearButtonMode = .whileEditing
//        textField.keyboardType = .default
        return textField
    }()
    
    let passswordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password..."
        textField.returnKeyType = UIReturnKeyType.continue
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        textField.autocapitalizationType = UITextAutocapitalizationType.none
//        textField.autocorrectionType = UITextAutocorrectionType.no
//        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8.0
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
//        textField.borderStyle = .roundedRect
//        textField.clearButtonMode = .whileEditing
//        textField.keyboardType = .default
        return textField
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8.0
        button.backgroundColor = UIColor(displayP3Red: 149/255, green: 144/255, blue: 204/255, alpha: 0.3)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Autolayout
    func autoLayout() {
        
        plusPhotoButton.snp.makeConstraints { (make) in
            make.size.equalTo(140)
            make.top.equalTo(self.snp.topMargin).offset(40)
            make.centerX.equalTo(self)
        }
        
        usernameField.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(plusPhotoButton.snp.bottom).offset(50)
            make.width.equalTo(self).offset(-50)
            make.height.equalTo(52)
        }
        
        emailField.snp.makeConstraints { (make) in
            make.top.equalTo(usernameField.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(self).offset(-50)
            make.height.equalTo(52)
        }
        
        passswordField.snp.makeConstraints { (make) in
            make.top.equalTo(emailField.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(self).offset(-50)
            make.height.equalTo(52)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(passswordField.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(self).offset(-50)
            make.height.equalTo(52)
        }
        
        
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(plusPhotoButton)
        addSubview(usernameField)
        addSubview(emailField)
        addSubview(passswordField)
        addSubview(registerButton)
        autoLayout()
        
        registerButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
        plusPhotoButton.addTarget(self, action: #selector(didTapPlusPhotoButton), for: .touchUpInside)

        usernameField.addTarget(self, action: #selector(didTapTextField), for: .editingChanged)
        emailField.addTarget(self, action: #selector(didTapTextField), for: .editingChanged)
        passswordField.addTarget(self, action: #selector(didTapTextField), for: .editingChanged)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    @objc func didTapSignUpButton() {
        signUpButtonAction?()
    }
    
    @objc func didTapPlusPhotoButton() {
        plusPhotoButtonAction?()
    }
    
    @objc func didTapTextField() {
        textFieldAction?()
    }

}

//
//  RegistrationView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

protocol RegistrationViewDelegate: AnyObject {
    func didTapSignUpButton()
    func didTapPlusPhotoButton()
    func didTapTextField()
}


class RegistrationView: UIView {

    // MARK: - Properties
    
    weak var delegate: RegistrationViewDelegate?
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
        textField.isSecureTextEntry  = true
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
//        textField.keyboardType = 
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
        button.backgroundColor = UIColor.garywhite
        button.isEnabled = false
        return button
    }()
    
    lazy var textFieldAndRegisterStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameField,emailField,passswordField,registerButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: - Autolayout
    func autoLayout() {
        
        plusPhotoButton.snp.makeConstraints { (make) in
            make.size.equalTo(140)
            make.top.equalTo(self.snp.topMargin).offset(40)
            make.centerX.equalTo(self)
        }
        
        textFieldAndRegisterStackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(plusPhotoButton.snp.bottom).offset(50)
            make.width.equalTo(self).offset(-50)
            make.height.equalTo(234)
        }
        
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(plusPhotoButton)
        addSubview(textFieldAndRegisterStackView)
        autoLayout()
        
        registerButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        plusPhotoButton.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        usernameField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        emailField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        passswordField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    @objc func handleSignUp() {
        delegate?.didTapSignUpButton()
    }
    
    @objc func handleAddPhoto() {
        delegate?.didTapPlusPhotoButton()
    }
    
    @objc func handleTextField() {
        delegate?.didTapTextField()
    }

}

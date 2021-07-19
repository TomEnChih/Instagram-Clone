//
//  LoginView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit
import SnapKit

class LoginView: UIView {

    // MARK: - Properties
    
    var LoginButtonAction:(()->Void)?
    
    var CreateAccountButtonAction:(()->Void)?
    
    var TermsButtonAction:(()->Void)?
    
    var PrivacyButtonAction:(()->Void)?
    
    // MARK: - IBElement
    
    var headerImageView: UIImageView = {
        var view = UIImageView(image: UIImage(named: "gradient"))
        return view
    }()
    
    var logoTextImageView: UIImageView = {
        var view = UIImageView(image: UIImage(named: "text"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let usernameEmailField: UITextField = {
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
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8.0
        button.backgroundColor = .systemBlue
        return button
    }()
    
    let createAccountButton: UIButton = {
        let button = UIButton()
        
        let title = NSMutableAttributedString(string: "New User?  ", attributes: [NSMutableAttributedString.Key.font:UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        let subTitle = NSMutableAttributedString(string: "Create an Account", attributes: [NSMutableAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 17) ,NSAttributedString.Key.foregroundColor:UIColor.systemBlue])

        title.append(subTitle)
        button.setAttributedTitle(title, for: .normal)
        return button
    }()
    
    let termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Servicd", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    // MARK: - Autolayout
    func autoLayout() {
        
        headerImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.bottom.equalTo(usernameEmailField.snp.top).offset(-10)
            make.width.equalTo(self)
        }
        
        logoTextImageView.snp.makeConstraints { (make) in
            make.center.equalTo(headerImageView)
            make.width.equalTo(headerImageView).multipliedBy(0.7)
//            make.height.equalTo(headerImageView).multipliedBy(0.5)
        }
        
        usernameEmailField.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(self).offset(-50)
            make.height.equalTo(52)
        }
        
        passswordField.snp.makeConstraints { (make) in
            make.top.equalTo(usernameEmailField.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(self).offset(-50)
            make.height.equalTo(52)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passswordField.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(self).offset(-50)
            make.height.equalTo(52)
        }
        
        createAccountButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(self).offset(-50)
            make.height.equalTo(52)
        }
        
        termsButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(privacyButton.snp.top).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(self).offset(-20)
            make.height.equalTo(50)
        }
        
        privacyButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottomMargin).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(self).offset(-20)
            make.height.equalTo(50)
        }
        
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(headerImageView)
        addSubview(logoTextImageView)
        addSubview(usernameEmailField)
        addSubview(passswordField)
        addSubview(loginButton)
        addSubview(createAccountButton)
        addSubview(termsButton)
        addSubview(privacyButton)
        autoLayout()
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    @objc func didTapLoginButton() {
        LoginButtonAction?()
    }
    
    @objc private func didTapCreateAccountButton() {
        CreateAccountButtonAction?()
    }
    
    @objc private func didTapTermsButton() {
        TermsButtonAction?()
    }
    
    @objc private func didTapPrivacyButton() {
        PrivacyButtonAction?()
    }
}

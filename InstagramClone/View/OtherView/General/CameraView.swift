//
//  CameraView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/13.
//

import UIKit

protocol CameraButtonDelegate: AnyObject {
    func didTapCapturePhoto()
    func didTapDismiss()
}

class CameraView: UIView {

    // MARK: - Properties
    
    weak var delegate: CameraButtonDelegate?
    
    // MARK: - IBElements
    
    let capturePhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .highlighted)
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        return button
    }()
    
    // MARK: - Autolayout
    
    private func autoLayout() {
        
        capturePhotoButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-24)
            make.centerX.equalTo(self)
            make.size.equalTo(80)
        }
        
        dismissButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.size.equalTo(50)
        }
        
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(capturePhotoButton)
        autoLayout()
        capturePhotoButton.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    @objc func handleCapturePhoto() {
        delegate?.didTapCapturePhoto()
    }
    
    @objc func handleDismiss() {
        delegate?.didTapDismiss()
    }
    
}

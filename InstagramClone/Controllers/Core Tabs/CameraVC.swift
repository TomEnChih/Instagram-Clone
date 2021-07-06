//
//  CameraVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    
    // MARK: - Properties
    
    private let cameraView = CameraView()
    
    // MARK: - Init
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
        view = cameraView
        didTapTakePicture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handleUpPicture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - Methods
    
    private func didTapTakePicture() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分享", style: .done, target: self, action: #selector(didReleasePost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(didReturnHomeView))
    }
    
    @objc func didReleasePost() {
        print("發佈成功")
    }
    
    @objc func didReturnHomeView() {
        
        self.tabBarController?.selectedIndex = 0
        
    }
    
}

//MARK: - ImagePickerControllerDelegate,UINavigationControllerDelegate
extension CameraVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    private func handleUpPicture() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            pickImage(image: selectedImage)
        }
    }
    
    private func pickImage(image: UIImage) {
        cameraView.postImageView.image = image
        navigationController?.setNavigationBarHidden(false, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 0
        
    }
    
}

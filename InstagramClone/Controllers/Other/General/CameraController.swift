//
//  CameraController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit 
import AVFoundation

class CameraController: UIViewController {
    // MARK: - Properties
    
    private let cameraView = CameraView()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view = cameraView
        cameraView.delegate = self
        setupCaptureSession()
    }
    
    // MARK: - Methods
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        //1. setup inputs
        
        guard let captureDevice = AVCaptureDevice.default(for: .audio) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error{
            print("Could not setup camera input:",error)
        }
        
        //2. setup outputs
        
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
}

//MARK: - CameraButtonDelegate
extension CameraController: CameraButtonDelegate {
    
    func didTapCapturePhoto() {
        print("Camera action")
    }
    
    func didTapDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    
}

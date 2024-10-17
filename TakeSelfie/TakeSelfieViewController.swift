//
//  TakeSelfieViewController.swift
//  ValifyFrameWork
//
//  Created by Nada_Hamed on 17/10/2024.
//

import UIKit
import AVFoundation

class TakeSelfieViewController: UIViewController {
    
    // MARK: Properties
    var approveDelegate: ApprovableProtocol?
    var captureSession: AVCaptureSession!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var takePhotoButton: UIButton!
    private var photoOutput: AVCapturePhotoOutput!
    private let captureBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        button.layer.cornerRadius = button.layer.frame.size.width / 2
        button.layer.borderWidth = 8
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission { granted in
            if granted {
                self.setUpCamera()
            } else {
                print("Camera access denied")
                self.captureBtn.isHidden = true
            }
        }
        bindCaptureBtn()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captureBtn.center = CGPoint(x: view.layer.frame.width / 2, y: view.layer.frame.height - 60)
        view.addSubview(captureBtn)
    }
    
}

// MARK: - Actions

extension TakeSelfieViewController {
    @objc private func captureButtonAction() {
        capturePhoto()
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto 
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension TakeSelfieViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        guard let data = photo.fileDataRepresentation(), let capturedImage = UIImage(data: data) else {
            print("Error: Unable to get image from data.")
            return
        }
        
        let correctedImage = UIImage(cgImage: capturedImage.cgImage!, scale: capturedImage.scale, orientation: .right)
        
        captureSession.stopRunning() 
        let vc = PresentSelfieViewController()
        vc.navigationDelegate = self
        vc.approveDelegate = self.approveDelegate
        vc.passedImage = correctedImage
        if let navigationController = navigationController{
            navigationController.pushViewController(vc, animated: true)
        }else{
            print("no navigation")
        }
    }
}

// MARK: - Private Handlers

private extension TakeSelfieViewController {
    func setUpCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            fatalError("No camera available.")
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            captureSession.addInput(input)
        } catch {
            print("Error accessing the camera: \(error)")
            return
        }
        
        photoOutput = AVCapturePhotoOutput()
        captureSession.addOutput(photoOutput)
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = view.bounds
        view.layer.addSublayer(videoPreviewLayer)
        captureSession.startRunning()
    }
    
    func bindCaptureBtn() {
        captureBtn.addTarget(self, action: #selector(captureButtonAction), for: .touchUpInside)
    }
}

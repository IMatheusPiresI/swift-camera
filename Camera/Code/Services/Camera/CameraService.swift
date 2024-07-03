//
//  CameraService.swift
//  Camera
//
//  Created by Matheus Pires de Sousa on 30/06/24.
//

import Foundation
import AVFoundation

class CameraService {
    
    var delegate: AVCapturePhotoCaptureDelegate?
    
    var captureSession: AVCaptureSession!
    let output = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var device: AVCaptureDevice?
    
    public var torchActive: Bool = false
    
    public func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
        self.delegate = delegate
    }
    
    public func checkCameraPermissions(completion: @escaping (Result<CameraSuccess, CameraError>) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    completion(.failure(.accessDenied))
                    return
                }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
            
        case .authorized:
            self.setupCamera(completion: completion)
            break
        case .denied:
            completion(.failure(.accessDenied))
            
        case .restricted:
            completion(.failure(.accessRestricted))
            
        @unknown default:
            completion(.failure(.unknown))
        }
    }
    
    private func setupCamera(completion: @escaping (Result<CameraSuccess, CameraError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async{
            let session = AVCaptureSession()
            
            if let device = AVCaptureDevice.default(for: .video) {
                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    
                    if session.canAddInput(input) {
                        session.addInput(input)
                    }
                    
                    if session.canAddOutput(self.output){
                        session.addOutput(self.output)
                    }
                    
                    self.previewLayer.videoGravity = .resizeAspectFill
                    self.previewLayer.session = session
                    
                    session.startRunning()
                    self.captureSession = session
                    self.device = device
                    completion(.success(.accessAllowed))
                } catch {
                    completion(.failure(.unknown))
                }
            }
        }
    }
    
    public func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        output.capturePhoto(with: settings, delegate: self.delegate!)
        self.turnOffFlash()
    }
    
    public func hasDeviceTorch() -> Bool {
        if let device = AVCaptureDevice.default(for: .video) {
            return device.hasTorch
        }
        return false
    }
    
    private func turnOnFlash() {
        do {
            try device?.lockForConfiguration()
            device?.torchMode = .on
            self.torchActive = true
            device?.unlockForConfiguration()
        }
        catch {
            print("ERROR TURN ON FLASH",  error)
        }
    }
    
    private func turnOffFlash() {
        do {
            try device?.lockForConfiguration()
            device?.torchMode = .off
            self.torchActive = false
            device?.unlockForConfiguration()
        }
        catch {
            print("ERROR TURN OFF FLASH",  error)
        }
    }
    
    public func toggleFlash() {
        let hasTorch = hasDeviceTorch()
        if let deviceCam = device , hasTorch {
            if deviceCam.torchMode == .off {
                turnOnFlash()
            } else {
                turnOffFlash()
            }
        }
    }
    
    public func focus(at point: CGPoint) {
        guard let device = device else { return }
        
        do {
            try device.lockForConfiguration()
            
            if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.autoFocus) {
                device.focusPointOfInterest = point
                device.focusMode = .autoFocus
            }
            
            if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(.autoExpose) {
                device.exposurePointOfInterest = point
                device.exposureMode = .autoExpose
            }
            
            device.unlockForConfiguration()
        } catch {
            print("ERROR FOCUSING CAMERA", error)
        }
    }
}

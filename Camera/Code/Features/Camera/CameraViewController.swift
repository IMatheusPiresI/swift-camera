//
//  CameraViewController.swift
//  Camera
//
//  Created by Matheus Pires de Sousa on 29/06/24.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var screen: CameraView?
    var initialZoomFactor: CGFloat = 1.0
    var cameraViewModel: CameraViewModel?
    
    override func loadView() {
        self.screen = CameraView()
        self.view = self.screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screen?.delegate(delegate: self)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.cameraViewModel = CameraViewModel(delegate: self)
        checkCameraPermissions()
        showTorchButton()
    }
    
    override func viewDidLayoutSubviews() {
        setupPreviewLayer()
    }
    
    func checkCameraPermissions(){
        self.cameraViewModel?.cameraCheckPermissionsError()
    }
    
    
    func setupPreviewLayer() {
        self.cameraViewModel?.setupCamera()
    }
    
    func showTorchButton() {
        self.cameraViewModel?.showTorchButton()
    }
}

extension CameraViewController: CameraViewDelegate {
    func pinchToZoomCam(gesture: UIPinchGestureRecognizer) {
        guard let device = self.cameraViewModel?.cameraService.device else { return }
        if gesture.state == .began {
            initialZoomFactor = device.videoZoomFactor
        } else if gesture.state == .changed {
            let maxZoomFactor = device.activeFormat.videoMaxZoomFactor
            let minZoomFactor = device.minAvailableVideoZoomFactor
            
            let zoomFactor = min(max(initialZoomFactor * gesture.scale, minZoomFactor), maxZoomFactor)
            do {
                try device.lockForConfiguration()
                device.videoZoomFactor = zoomFactor
                device.unlockForConfiguration()
            } catch {
                print("Error locking configuration: \(error)")
            }
        }
    }
    
    func tapToFocusCam(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self.screen?.viewCameraContent)
        self.cameraViewModel?.focusCam(point: point)
    }
    
    func toggleFlash() {
        self.cameraViewModel?.toggleFlash()
    }
    
    func goBack() {
        self.cameraViewModel?.navigateGoBack()
    }
    
    func onTakePhoto() {
        self.cameraViewModel?.cameraService.capturePhoto(with: AVCapturePhotoSettings())
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Erro ao capturar foto: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("Erro ao obter dados da foto")
            return
        }
        
        let image = UIImage(data: imageData)
        if let photo = image {
            self.cameraViewModel?.openPreviewPhoto(photo: photo)
        }
    }
}

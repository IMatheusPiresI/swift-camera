//
//  CameraViewModel.swift
//  Camera
//
//  Created by Matheus Pires de Sousa on 01/07/24.
//

import Foundation
import AVFoundation
import UIKit

class CameraViewModel {
    var cameraService: CameraService = CameraService()
    var delegate: CameraViewController?
    var animationFocusView: Bool = false
    
    init(delegate: CameraViewController) {
        self.delegate = delegate
    }
    
    private func navigateToCameraErrorAccessBlock() {
        DispatchQueue.main.async {
            guard let navigationController = self.delegate?.navigationController else {
                return
            }
            
            var viewControllers = navigationController.viewControllers
            let cameraAccessBlockViewController = CameraAccessBlockViewController()
            viewControllers.removeLast()
            viewControllers.append(cameraAccessBlockViewController)
            
            navigationController.setViewControllers(viewControllers, animated: true)
        }
    }
    
    private func navigateToCameraAccessError(error: CameraError) {
        switch (error) {
        case .accessDenied:
            navigateToCameraErrorAccessBlock()
            
        case .accessRestricted:
            navigateToCameraErrorAccessBlock()
            
        case .unknown:
            navigateToCameraErrorAccessBlock()
        case .isEmpty:
            print("isEmpty Cam Devices")
        }
    }
    
    public func cameraCheckPermissionsError() {
        self.cameraService.checkCameraPermissions { result in
            switch result {
            case .failure(let error):
                self.navigateToCameraAccessError(error: error)
            case .success(_):
                break
            }
        }
    }
    
    public func navigateGoBack() {
        self.delegate?.navigationController?.popViewController(animated: true)
    }
    
    public func setupCamera() {
        if let delegate = self.delegate {
            self.cameraService.start(delegate: delegate, completion: { error in
                if let errorMessage = error?.localizedDescription {
                    print(errorMessage)
                }
            })
            
            if let cameraBounds = delegate.screen?.viewCameraContent.bounds {
                delegate.screen?.viewCameraContent.layer.addSublayer(self.cameraService.previewLayer)
                self.cameraService.previewLayer.videoGravity = .resizeAspectFill
                self.cameraService.previewLayer.frame = cameraBounds
            }
        }
    }
    
    private func changeButtonIconFlash() {
        let imageTorch = self.cameraService.torchActive ? "bolt.fill" : "bolt.slash.fill"
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let symbolImage = UIImage(systemName: imageTorch, withConfiguration: symbolConfig)
        self.delegate?.screen?.buttonFlash.setImage(symbolImage, for: .normal)
        self.delegate?.screen?.buttonFlash.imageView?.tintColor = .white
        self.delegate?.screen?.buttonFlash.imageView?.image = symbolImage
    }
    
    public func toggleFlash() {
        self.cameraService.toggleFlash()
        self.changeButtonIconFlash()
    }
    
    public func showTorchButton() {
        let hasTorch = self.cameraService.hasDeviceTorch()
        
        if hasTorch {
            self.delegate?.screen?.buttonFlash.isHidden = false
        }
    }

    private func showFocusCamView(at point: CGPoint) {
        if !animationFocusView {
            self.animationFocusView = true
            
            self.delegate?.screen?.viewCameraFocus.layer.removeAllAnimations()
            self.delegate?.screen?.viewCameraFocus.center = point
            self.delegate?.screen?.viewCameraFocus.isHidden = false
            self.delegate?.screen?.viewCameraFocus.alpha = 1.0
            self.delegate?.screen?.viewCameraFocus.transform = .identity
            
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1) {
                    self.delegate?.screen?.viewCameraFocus.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.45) {
                    self.delegate?.screen?.viewCameraFocus.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.30) {
                    self.delegate?.screen?.viewCameraFocus.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15) {
                    self.delegate?.screen?.viewCameraFocus.alpha = 0.0
                }
            }) { _ in
                self.delegate?.screen?.viewCameraFocus.isHidden = true
                self.animationFocusView = false
            }
        }
    }
    
    public func focusCam(point: CGPoint) {
        let convertedPoint = self.cameraService.previewLayer.captureDevicePointConverted(fromLayerPoint: point)
        self.cameraService.focus(at: convertedPoint)
        self.showFocusCamView(at: point)
    }
    
    public func openPreviewPhoto(photo: UIImage) {
        let photoPreviewViewController = PhotoPreviewViewController()
        photoPreviewViewController.photo = photo
        photoPreviewViewController.modalPresentationStyle = .fullScreen
        photoPreviewViewController.modalTransitionStyle = .crossDissolve
        
        self.delegate?.present(photoPreviewViewController, animated: true, completion: nil)
    }
}

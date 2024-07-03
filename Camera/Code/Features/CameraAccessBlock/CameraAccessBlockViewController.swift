//
//  CameraAccessBlockViewController.swift
//  Camera
//
//  Created by Matheus Pires de Sousa on 01/07/24.
//

import UIKit

class CameraAccessBlockViewController: UIViewController {
    var screen: CameraAccessBlockView?
    var cameraAccessBlockViewModel: CameraAccessBlockViewModel?
    
    override func loadView() {
        self.screen = CameraAccessBlockView()
        self.view = self.screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screen?.delegate(delegate: self)
        self.cameraAccessBlockViewModel = CameraAccessBlockViewModel(delegate: self)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
}


extension CameraAccessBlockViewController: CameraAccessBlockViewDelegate {
    func goBackToCamera() {
        self.cameraAccessBlockViewModel?.goBack()
    }
    
    func openAppSettings() {
        self.cameraAccessBlockViewModel?.openSettings()
    }
}

//
//  ViewController.swift
//  Camera
//
//  Created by Matheus Pires de Sousa on 29/06/24.
//

import UIKit
import AVFoundation

class WelcomeViewController: UIViewController {
    
    var screen: WelcomeView?
    
    override func loadView() {
        self.screen = WelcomeView()
        self.view = self.screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screen?.delegate(delegate: self)
    }
    
    private func navigateToCamera() {
        let cameraVC = CameraViewController()
        cameraVC.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.pushViewController(cameraVC, animated: true)
    }
    
}

extension WelcomeViewController: WelcomeViewDelegate {
    func onPressGoToCamera() {
        self.navigateToCamera()
    }
}

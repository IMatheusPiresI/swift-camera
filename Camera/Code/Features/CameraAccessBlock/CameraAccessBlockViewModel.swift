//
//  CameraAccessBlockViewModel.swift
//  Camera
//
//  Created by Matheus Pires de Sousa on 02/07/24.
//

import Foundation
import UIKit

class CameraAccessBlockViewModel {
    let delegate: CameraAccessBlockViewController?
    
    init(delegate: CameraAccessBlockViewController?) {
        self.delegate = delegate
    }
    
    func goBack() {
        self.delegate?.navigationController?.popViewController(animated: true)
    }
    
    func openSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
}

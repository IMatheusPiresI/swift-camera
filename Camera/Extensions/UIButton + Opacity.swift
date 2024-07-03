//
//  UIButton + Opacity.swift
//  Camera
//
//  Created by Matheus Pires de Sousa on 29/06/24.
//

import UIKit

extension UIButton {
    func addOpacityEffect() {
        self.addTarget(self, action: #selector(applyOpacityEffect), for: [.touchDown, .touchDragEnter])
        self.addTarget(self, action: #selector(removeOpacityEffect), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }
    
    @objc private func applyOpacityEffect() {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.8
        }
    }
    
    @objc private func removeOpacityEffect() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        }
    }
}

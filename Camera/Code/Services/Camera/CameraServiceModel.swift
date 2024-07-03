//
//  CameraServiceModel.swift
//  Camera
//
//  Created by Matheus Pires de Sousa on 30/06/24.
//

import Foundation

enum CameraError: Error {
    case accessDenied
    case accessRestricted
    case isEmpty
    case unknown
}

enum CameraSuccess {
    case accessAllowed
}
